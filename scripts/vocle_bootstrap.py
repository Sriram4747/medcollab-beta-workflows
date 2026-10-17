"""Automatic runtimes for the disposable launcher; no application assertions."""

import hashlib
import json
import os
from pathlib import Path, PurePosixPath, PureWindowsPath
import platform
import re
import shutil
import signal
import subprocess
import sys
import tarfile
import time
import urllib.request
import uuid
import zipfile

HERE = Path(__file__).resolve().parent
LOCK = json.loads((HERE / "vocle-runtime-lock.json").read_text(encoding="utf-8"))


class SetupRequired(RuntimeError):
    def __init__(self, message, status="BOOTSTRAP_BLOCKED"):
        super().__init__(message)
        self.status = status


def decode(raw):
    return raw.decode("utf-16-le" if b"\0" in raw[:80] else "utf-8-sig", errors="replace").strip("\ufeff\0\r\n ")


def checked(argv, *, env=None, timeout=120, check=True, log=None):
    command = list(map(str, argv))
    if os.name == "nt" and command[0].lower().endswith((".bat", ".cmd")):
        if any(re.search(r'[&|<>^%\r\n"]', arg) for arg in command):
            raise ValueError("Unsafe batch argument")
        command = 'cmd.exe /d /s /c "' + " ".join('"' + arg + '"' for arg in command) + '"'
    child = subprocess.Popen(command, env=env, stdin=subprocess.DEVNULL,
                             stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                             start_new_session=os.name != "nt")
    try:
        raw, _ = child.communicate(timeout=timeout)
    except BaseException:
        if os.name == "nt":
            subprocess.run(["taskkill.exe", "/pid", str(child.pid), "/T", "/F"], capture_output=True, timeout=15)
        else:
            try:
                os.killpg(child.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
        child.wait(timeout=15)
        raise
    text = decode(raw)
    if log:
        with Path(log).open("a", encoding="utf-8") as target:
            target.write(text + "\n")
    if check and child.returncode:
        raise SetupRequired("Setup command failed: " + str(argv[0]) + ": " + text[-2000:])
    return child.returncode, text


def download(asset, destination):
    print("Downloading " + asset["url"].rsplit("/", 1)[-1], flush=True)
    digest = hashlib.sha256()
    request = urllib.request.Request(asset["url"], headers={"User-Agent": "Vocle-local-tests/1"})
    with urllib.request.urlopen(request, timeout=60) as response, destination.open("wb") as target:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
            target.write(chunk)
    if digest.hexdigest() != asset["sha256"]:
        destination.unlink()
        raise SetupRequired("Runtime download checksum mismatch: " + asset["url"])
    return destination


def extract(archive, destination):
    """Extract pinned binary bundles; reject traversal and unsafe links."""
    destination.mkdir(parents=True, exist_ok=True)

    def safe(name):
        path = PurePosixPath(name.replace("\\", "/"))
        if path.is_absolute() or ".." in path.parts or re.match(r"^[A-Za-z]:", name):
            raise SetupRequired("Unsafe runtime archive member: " + name)
        return path

    if zipfile.is_zipfile(archive):
        with zipfile.ZipFile(archive) as bundle:
            for entry in bundle.infolist():
                safe(entry.filename)
                if (entry.external_attr >> 16) & 0o170000 == 0o120000:
                    raise SetupRequired("Unexpected ZIP symlink")
            bundle.extractall(destination)
    else:
        with tarfile.open(archive) as bundle:
            for entry in bundle.getmembers():
                path = safe(entry.name)
                if entry.issym():
                    # Node's bin/npm -> ../lib/node_modules/npm/bin/npm-cli.js.
                    target = path.parent / entry.linkname
                    depth = 0
                    for part in target.parts:
                        depth += -1 if part == ".." else 1 if part != "." else 0
                        if depth < 0:
                            raise SetupRequired("Runtime symlink escapes archive")
                    if PurePosixPath(entry.linkname).is_absolute():
                        raise SetupRequired("Absolute runtime symlink refused")
                elif not (entry.isfile() or entry.isdir()):
                    raise SetupRequired("Unsafe runtime archive entry")
            bundle.extractall(destination, **({"filter": "data"} if hasattr(tarfile, "data_filter") else {}))


def windows_mount(path):
    value = PureWindowsPath(path)
    if not value.is_absolute() or not re.fullmatch(r"[A-Za-z]:", value.drive):
        raise SetupRequired("Managed WSL requires a local drive path: " + path)
    return "/mnt/" + value.drive[0].lower() + "/" + "/".join(value.parts[1:])


def proxy_args(args, mode):
    result = list(args)
    if mode == "wsl":
        for index, arg in enumerate(result):
            if index and result[index - 1] == "--mount":
                result[index] = ",".join("source=" + windows_mount(piece[7:]) if piece.startswith("source=") else piece for piece in arg.split(","))
    if result and result[0] == "run" and not any(arg == "--network" or arg.startswith("--network=") for arg in result):
        # Only dependency preparation lacks --network. Assertions keep --network none.
        result.insert(1, "--network=host")
    return result


def owned_mounts(mountinfo, directory):
    owned = directory.resolve()
    result = []
    for line in mountinfo.splitlines():
        mount = re.sub(r"\\([0-7]{3})", lambda match: chr(int(match[1], 8)), line.split()[4])
        point = Path(mount).resolve()
        if point.is_relative_to(owned):
            result.append(point)
    return sorted(result, key=lambda path: len(path.parts), reverse=True)


def docker_proxy(config_file, args):
    config = json.loads(Path(config_file).read_text(encoding="utf-8"))
    prefix = ([config["wsl"], "--distribution", config["distribution"], "--user", "root", "--exec"]
              if config["mode"] == "wsl" else [])
    command = prefix + [config["docker"], "--config", config["clientConfig"], "--host", config["socket"]] + proxy_args(args, config["mode"])
    return subprocess.call(command)


class Bootstrap:
    def __init__(self, scratch, output, env, state):
        self.scratch, self.output, self.env, self.state = scratch, output, env, state
        self.log = output / "setup.log"
        self.guest = None
        self.daemon = None
        self.containerd = None
        self.daemon_log = None
        self.sudo = []
        self.wsl = shutil.which("wsl.exe") if os.name == "nt" else None
        state["runtimeSetup"] = {"downloads": [], "docker": "NOT_REQUESTED", "cleanup": "PENDING"}
        self.details = state["runtimeSetup"]

    def command(self, argv, **kwargs):
        return checked(argv, env=self.env, log=self.log, **kwargs)

    def asset(self, asset, filename):
        result = download(asset, self.scratch / filename)
        self.details["downloads"].append({"url": asset["url"], "sha256": asset["sha256"]})
        return result

    def node(self):
        existing = shutil.which("node", path=self.env["PATH"])
        if existing:
            code, version = self.command([existing, "--version"], check=False)
            if not code and int(version.lstrip("v").split(".")[0]) >= 22 and shutil.which("npm", path=self.env["PATH"]):
                self.details["node"] = {"kind": "existing", "version": version}
                return existing
        machine = "arm64" if platform.machine().lower() in ("arm64", "aarch64") else "x64"
        key = ("windows" if os.name == "nt" else sys.platform) + "-" + machine
        if key not in LOCK["node"]:
            raise SetupRequired("Automatic Node installation unavailable for " + key)
        asset = LOCK["node"][key]
        directory = self.scratch / "node"
        extract(self.asset(asset, asset["url"].rsplit("/", 1)[-1]), directory)
        install = next(directory.iterdir())
        bin_dir = install if os.name == "nt" else install / "bin"
        self.env["PATH"] = str(bin_dir) + os.pathsep + self.env["PATH"]
        self.details["node"] = {"kind": "disposable", "version": "22.20.0"}
        return str(bin_dir / ("node.exe" if os.name == "nt" else "node"))

    def flutter(self, explicit=None):
        name = "flutter.bat" if os.name == "nt" else "flutter"
        candidates = [explicit] if explicit else [shutil.which(name, path=self.env["PATH"]), str(HERE.parent / "tests/functional-regression/output/flutter-sdk-3.29.3/bin" / name)]
        for candidate in filter(None, candidates):
            if not Path(candidate).is_file():
                continue
            code, text = self.command([candidate, "--version", "--machine"], timeout=120, check=False)
            try:
                if not code and json.loads(text)["frameworkVersion"] == LOCK["flutter"]["version"]:
                    self.details["flutter"] = {"kind": "existing", "version": "3.29.3", "path": candidate}
                    return candidate
            except (ValueError, KeyError):
                pass
        if explicit:
            raise SetupRequired("Explicit Flutter executable must provide version 3.29.3: " + explicit)
        print("Installing disposable Flutter 3.29.3 SDK and its required artifacts...", flush=True)
        directory = self.scratch / "flutter-sdk"
        self.command(["git", "clone", "--depth", "1", "--branch", "3.29.3", "--", LOCK["flutter"]["repository"], directory], timeout=900)
        _, sha = self.command(["git", "-C", directory, "rev-parse", "HEAD"])
        if sha != LOCK["flutter"]["commit"]:
            raise SetupRequired("Flutter release commit does not match the runtime lock")
        executable = str(directory / "bin" / name)
        self.command([executable, "--version", "--machine"], timeout=900)
        self.details["flutter"] = {"kind": "disposable", "version": "3.29.3", "commit": sha}
        return executable

    def ensure_wsl(self):
        if not self.wsl:
            self.wsl = str(Path(os.environ.get("SystemRoot", "C:/Windows")) / "System32/wsl.exe")
        code, text = self.command([self.wsl, "--status"], check=False)
        if code == 0:
            return
        print("Preparing the Windows WSL platform. Windows may request administrator permission.", flush=True)
        result = self.output / "windows-setup.json"
        code, _ = self.command(["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", HERE / "Setup-VocleWsl.ps1", "-Result", result], timeout=1800, check=False)
        detail = json.loads(result.read_text(encoding="utf-8-sig")) if result.exists() else {}
        self.details["windowsPlatformSetup"] = detail
        if code or detail.get("exitCode") not in (0, 3010):
            raise SetupRequired("Windows WSL setup did not complete. See windows-setup.json and setup.log. " + detail.get("error", text))
        if detail.get("exitCode") == 0:
            ready, _ = self.command([self.wsl, "--status"], check=False)
            if ready == 0:
                return  # Existing virtualization components may already be ready.
        raise SetupRequired("Windows WSL setup completed. Restart Windows once, then rerun the same Python command. No tests were executed. The Windows platform remains installed; each test guest is disposable.", "RESTART_REQUIRED")

    def daemon_flags(self, directory, socket):
        return ["--config-file", str(directory / "daemon.json"), "--host", socket,
                "--data-root", str(directory / "data"), "--exec-root", str(directory / "exec"),
                "--pidfile", str(directory / "dockerd.pid"), "--storage-driver=vfs",
                "--containerd", str(directory / "containerd.sock"),
                "--bridge=none", "--iptables=false", "--ip6tables=false", "--ip-forward=false", "--ip-masq=false"]

    def docker(self, policy="auto"):
        existing = shutil.which("docker", path=self.env["PATH"])
        if policy != "managed" and existing:
            _, endpoint = self.command([existing, "context", "inspect", "--format", "{{.Endpoints.docker.Host}}"])
            if not endpoint.startswith(("unix://", "npipe://")):
                raise SetupRequired("Refusing a remote Docker context; local tests require a local engine")
            code, kind = self.command([existing, "info", "--format", "{{.OSType}}"], timeout=30, check=False)
            if not code and kind == "linux":
                self.details["docker"] = "existing-local"
                return existing
        if policy == "existing":
            raise SetupRequired("No running local Linux Docker engine; use the default automatic runtime setup")
        if platform.machine().lower() not in ("amd64", "x86_64"):
            raise SetupRequired("Automatic minimal Docker is currently supported on x64 Windows/Linux; an existing local Linux Docker engine can be reused")
        if os.name == "nt":
            self.ensure_wsl()
            return self.wsl_docker()
        if sys.platform != "linux":
            raise SetupRequired("This platform needs a local Linux Docker engine; automatic guest provisioning currently supports Windows WSL and Linux")
        return self.linux_docker()

    def shim(self, config):
        config_path = self.scratch / "docker-proxy.json"
        config_path.write_text(json.dumps(config), encoding="utf-8")
        executable = self.scratch / ("docker-proxy.cmd" if os.name == "nt" else "docker-proxy")
        if os.name == "nt":
            text = '@echo off\r\n"' + sys.executable + '" "' + str(Path(__file__).resolve()) + '" --proxy "' + str(config_path) + '" %*\r\n'
        else:
            import shlex
            text = "#!/bin/sh\nexec " + " ".join(shlex.quote(value) for value in [sys.executable, str(Path(__file__).resolve()), "--proxy", str(config_path)]) + ' "$@"\n'
        executable.write_text(text, encoding="utf-8")
        executable.chmod(0o700)
        return str(executable)

    def wait_daemon(self, command):
        for _ in range(120):
            if self.daemon.poll() is not None:
                raise SetupRequired("Private Docker daemon stopped during setup; see docker-daemon.log")
            code, kind = self.command(command + ["info", "--format", "{{.OSType}}"], timeout=10, check=False)
            if not code and kind == "linux":
                return
            time.sleep(0.5)
        raise SetupRequired("Private Docker daemon did not become ready; see docker-daemon.log")

    def start_engines(self, prefix, directory, binary):
        self.daemon_log = (self.output / "docker-daemon.log").open("wb")
        path = str(binary.parent) + ":/usr/sbin:/usr/bin:/sbin:/bin"
        # Write an owned PID before exec; never discover/stop a system containerd.
        launch = prefix + ["env", "PATH=" + path, "sh", "-c", 'echo $$ > "$1"; shift; exec "$@"', "vocle-runtime"]
        containerd_args = [str(binary.parent / "containerd"), "--config", str(directory / "containerd.toml"),
                           "--root", str(directory / "containerd-data"), "--state", str(directory / "containerd-state"),
                           "--address", str(directory / "containerd.sock")]
        options = {"env": self.env, "stdout": self.daemon_log, "stderr": subprocess.STDOUT,
                   "stdin": subprocess.DEVNULL, "start_new_session": os.name != "nt"}
        self.containerd = subprocess.Popen(launch + [str(directory / "containerd.pid"), *containerd_args], **options)
        for _ in range(60):
            if self.containerd.poll() is not None:
                raise SetupRequired("Private containerd stopped during setup; see docker-daemon.log")
            code, _ = self.command(prefix + [binary.parent / "ctr", "--address", directory / "containerd.sock", "version"], timeout=5, check=False)
            if code == 0:
                break
            time.sleep(0.5)
        else:
            raise SetupRequired("Private containerd did not become ready")
        socket = "unix://" + str(directory / "docker.sock")
        self.daemon = subprocess.Popen(launch + [str(directory / "dockerd-launch.pid"), str(binary.parent / "dockerd"), *self.daemon_flags(directory, socket)], **options)
        self.wait_daemon(prefix + [binary, "--host", socket])
        self.details["containerd"] = "disposable-private-socket"
        return socket

    def wsl_docker(self):
        name = "Vocle-Test-" + uuid.uuid4().hex
        self.guest = name
        self.details["distribution"] = name
        rootfs = self.asset(LOCK["wslRootfs"], "ubuntu-base.tar.gz")
        code, text = self.command([self.wsl, "--import", name, self.scratch / "wsl", rootfs, "--version", "2"], timeout=300, check=False)
        if code:
            if self.details.get("windowsPlatformSetup") and re.search(r"HYPERV_NOT_INSTALLED|0x80370102|restart|reboot", text, re.I):
                raise SetupRequired("Windows installed WSL but its virtual machine platform needs a restart. Restart once and rerun the same command. " + text[-1000:], "RESTART_REQUIRED")
            raise SetupRequired("The private WSL 2 guest could not start. See setup.log. " + text[-1500:])
        prefix = [self.wsl, "--distribution", name, "--user", "root", "--exec"]
        # TLS trust and, when enabled by the kernel, the AppArmor loader are OS
        # requirements. Install them only in this disposable guest.
        _, apparmor = self.command(prefix + ["sh", "-c", "cat /sys/module/apparmor/parameters/enabled 2>/dev/null || true"])
        packages = ["ca-certificates", "procps"] + (["apparmor"] if apparmor.upper() == "Y" else [])
        self.command(prefix + ["apt-get", "update"], timeout=600)
        self.command(prefix + ["env", "DEBIAN_FRONTEND=noninteractive", "apt-get", "install", "-y", "--no-install-recommends", *packages], timeout=600)
        _, installed = self.command(prefix + ["dpkg-query", "-W", *packages])
        self.details["guestPackages"] = installed
        bundle = self.asset(LOCK["docker"], "docker.tgz")
        self.command(prefix + ["mkdir", "-p", "/opt/vocle/client"])
        self.command(prefix + ["tar", "xzf", windows_mount(str(bundle)), "-C", "/opt/vocle"])
        configuration = self.scratch / "daemon.json"
        configuration.write_text("{}", encoding="ascii")
        self.command(prefix + ["cp", windows_mount(str(configuration)), "/opt/vocle/daemon.json"])
        containerd_config = self.scratch / "containerd.toml"
        containerd_config.write_text("version = 2\n", encoding="ascii")
        self.command(prefix + ["cp", windows_mount(str(containerd_config)), "/opt/vocle/containerd.toml"])
        binary = "/opt/vocle/docker/docker"
        socket = self.start_engines(prefix, PurePosixPath("/opt/vocle"), PurePosixPath(binary))
        self.details["docker"] = "disposable-wsl-engine"
        return self.shim({"mode": "wsl", "wsl": self.wsl, "distribution": name, "docker": binary, "socket": socket, "clientConfig": "/opt/vocle/client"})

    def linux_docker(self):
        if os.geteuid() != 0:
            if not shutil.which("sudo", path=self.env["PATH"]):
                raise SetupRequired("Starting a private Linux container engine requires root or sudo permission")
            self.sudo = ["sudo", "-n"]
            code, _ = self.command(self.sudo + ["true"], check=False)
            if code and sys.stdin.isatty():
                print("Linux needs permission to start the private Docker engine; sudo may request your password.", flush=True)
                subprocess.run(["sudo", "-v"], env=self.env, timeout=120, check=False)
                code, _ = self.command(self.sudo + ["true"], check=False)
            if code:
                raise SetupRequired("Private Docker needs Linux permission to start a container daemon. Authorize sudo once (sudo -v), then rerun; an existing local Docker engine also works.")
        directory = self.scratch / "docker-engine"
        extract(self.asset(LOCK["docker"], "docker.tgz"), directory)
        (directory / "client").mkdir()
        (directory / "daemon.json").write_text("{}", encoding="ascii")
        (directory / "containerd.toml").write_text("version = 2\n", encoding="ascii")
        binary = directory / "docker/docker"
        socket = self.start_engines(self.sudo, directory, binary)
        if self.sudo:
            self.command(self.sudo + ["chown", str(os.getuid()) + ":" + str(os.getgid()), directory / "docker.sock"])
        self.details["docker"] = "disposable-linux-engine"
        return self.shim({"mode": "linux", "docker": str(binary), "socket": socket, "clientConfig": str(directory / "client")})

    def verify_wsl_owner(self):
        if not re.fullmatch(r"Vocle-Test-[a-f0-9]{32}", self.guest or ""):
            raise SetupRequired("Unsafe WSL cleanup identity")
        import winreg
        try:
            registry = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Lxss")
        except FileNotFoundError:
            return False
        with registry as key:
            for index in range(winreg.QueryInfoKey(key)[0]):
                with winreg.OpenKey(key, winreg.EnumKey(key, index)) as entry:
                    if winreg.QueryValueEx(entry, "DistributionName")[0] == self.guest:
                        base = winreg.QueryValueEx(entry, "BasePath")[0].removeprefix("\\\\?\\")
                        if Path(base).resolve() != (self.scratch / "wsl").resolve():
                            raise SetupRequired("WSL cleanup refused: registered path does not belong to this session")
                        return True
        return False

    def close(self):
        try:
            if self.guest and self.verify_wsl_owner():
                self.command([self.wsl, "--terminate", self.guest], check=False)
                self.command([self.wsl, "--unregister", self.guest], timeout=120)
                if self.verify_wsl_owner():
                    raise SetupRequired("Owned WSL guest was not removed")
            elif not self.guest:
                for process, name in ((self.daemon, "dockerd"), (self.containerd, "containerd")):
                    if process and process.poll() is None:
                        if self.sudo:
                            pid = (self.scratch / ("docker-engine/" + name + ".pid")).read_text().strip()
                            if not pid.isdecimal():
                                raise SetupRequired("Invalid owned runtime PID")
                            actual = Path("/proc", pid, "cmdline").read_bytes().split(b"\0")[0]
                            expected = str(self.scratch / "docker-engine/docker" / name).encode()
                            if actual != expected:
                                raise SetupRequired("Cleanup refused: PID no longer identifies the owned runtime")
                            self.command(self.sudo + ["kill", "-TERM", pid])
                        else:
                            process.terminate()
                        process.wait(timeout=30)
            for process in (self.daemon, self.containerd):
                if process:
                    process.wait(timeout=30)
            # Private Linux daemon may leave root-owned files. Delete only its checked data root.
            if sys.platform == "linux" and (self.scratch / "docker-engine").exists():
                data = (self.scratch / "docker-engine").resolve()
                if data.parent != self.scratch.resolve() or data.name != "docker-engine":
                    raise SetupRequired("Unsafe Docker data cleanup path")
                # Network namespaces are bind mounts; Docker may retain these
                # after stopping. Unmount only exact paths inside our data root.
                for point in owned_mounts(Path("/proc/self/mountinfo").read_text(), data):
                    self.command(self.sudo + ["umount", "--", point])
                self.command(self.sudo + ["rm", "-rf", "--", data])
            self.details["cleanup"] = "PASS"
        except Exception:
            self.details["cleanup"] = "ERROR"
            raise
        finally:
            if self.daemon_log:
                self.daemon_log.close()


if __name__ == "__main__" and len(sys.argv) > 2 and sys.argv[1] == "--proxy":
    sys.exit(docker_proxy(sys.argv[2], sys.argv[3:]))
