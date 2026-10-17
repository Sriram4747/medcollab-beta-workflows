#!/usr/bin/env python3
"""Run Vocle's existing regression harness in a disposable local session.

Python 3.10+, Git, Node 22+/npm, Flutter 3.29.3 and (for backend runtime)
a Linux Docker engine are prerequisites. No Python packages are required.
"""

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import shutil
import signal
import stat
import subprocess
import sys
import tempfile
import uuid
import venv


ROOT = Path(__file__).resolve().parents[1]
VALUE_OPTIONS = ("commit", "previous", "flutter_bin", "apk", "profile")
ENV_KEYS = {
    "PATH", "SYSTEMROOT", "SYSTEMDRIVE", "WINDIR", "COMSPEC", "PROGRAMFILES",
    "PROGRAMFILES(X86)", "PROGRAMW6432", "LANG", "LC_ALL", "JAVA_HOME",
    "ANDROID_HOME", "ANDROID_SDK_ROOT",
}


def parse_args(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=ROOT, help="Checkout, including uncommitted application changes")
    parser.add_argument("--commit", help="Exact 40-character SHA; omit to include working changes")
    parser.add_argument("--output", type=Path, help="New directory for reports; must not exist")
    parser.add_argument("--previous", type=Path, help="Previous Python session or existing evidence directory")
    parser.add_argument("--flutter-bin", help="Flutter 3.29.3 executable; otherwise use PATH")
    parser.add_argument("--apk", type=Path, help="Record APK evidence (existing runner limitations apply)")
    parser.add_argument("--android", action="store_true", help="Use the existing emulator runner")
    parser.add_argument("--security", action="store_true", help="Include existing isolated security runtime")
    parser.add_argument("--profile", choices=("full", "tooling", "backend-smoke"), default="full")
    args = parser.parse_args(argv)
    for key in ("source", "output", "previous", "apk"):
        value = getattr(args, key)
        if value is not None:
            setattr(args, key, value.expanduser().resolve())
    if args.previous and (args.previous / "evidence").is_dir():
        args.previous /= "evidence"
    if args.flutter_bin and ("/" in args.flutter_bin or "\\" in args.flutter_bin):
        args.flutter_bin = str(Path(args.flutter_bin).expanduser().resolve())
    if args.commit and (len(args.commit) != 40 or any(c not in "0123456789abcdef" for c in args.commit)):
        parser.error("--commit requires a complete lowercase 40-character SHA")
    return args


def session_environment(scratch, environment=None):
    original = os.environ if environment is None else environment
    env = {k.upper(): v for k, v in original.items() if k.upper() in ENV_KEYS}
    locations = {
        "HOME": "home", "USERPROFILE": "home", "APPDATA": "appdata",
        "LOCALAPPDATA": "localappdata", "PUB_CACHE": "pub-cache",
        "NPM_CONFIG_CACHE": "npm-cache", "GRADLE_USER_HOME": "gradle",
        "TMP": "tmp", "TEMP": "tmp", "TMPDIR": "tmp",
    }
    # Preserve discovery of a preinstalled Android SDK before isolating HOME.
    if not env.get("ANDROID_HOME") and not env.get("ANDROID_SDK_ROOT"):
        base = original.get("LOCALAPPDATA") if os.name == "nt" else original.get("HOME")
        candidate = Path(base or "") / "Android/Sdk"
        if sys.platform == "darwin":
            candidate = Path(base or "") / "Library/Android/sdk"
        if base and candidate.is_dir():
            env["ANDROID_HOME"] = str(candidate.resolve())
    for key, folder in locations.items():
        directory = scratch / folder
        directory.mkdir(exist_ok=True)
        env[key] = str(directory)
    bin_dir = scratch / "venv" / ("Scripts" if os.name == "nt" else "bin")
    env["VIRTUAL_ENV"] = str(scratch / "venv")
    env["PATH"] = str(bin_dir) + os.pathsep + env.get("PATH", "")
    env["PYTHONDONTWRITEBYTECODE"] = "1"
    # Docker uses the existing local engine/context, never an application .env.
    docker_config = Path(original.get("DOCKER_CONFIG") or (Path(original.get("USERPROFILE") or original.get("HOME") or "~") / ".docker"))
    if docker_config.is_dir():
        env["DOCKER_CONFIG"] = str(docker_config.resolve())
    return env


class ManagedCommand:
    """Forward cancellation so the Node harness can finish its own cleanup."""

    def __init__(self):
        self.child = None
        self.interrupted = False

    def cancel(self, _signum, _frame):
        self.interrupted = True
        if self.child and self.child.poll() is None:
            print("Stopping checks and waiting for disposable-resource cleanup...", flush=True)
            try:
                self.child.send_signal(signal.CTRL_BREAK_EVENT if os.name == "nt" else signal.SIGTERM)
            except ProcessLookupError:
                pass
        else:
            raise KeyboardInterrupt

    def run(self, argv, *, env, cwd):
        names = [signal.SIGINT, signal.SIGTERM]
        if os.name == "nt":
            names.append(signal.SIGBREAK)
        saved = {name: signal.signal(name, self.cancel) for name in names}
        try:
            self.child = subprocess.Popen(
                argv, cwd=cwd, env=env, stdin=subprocess.DEVNULL,
                creationflags=subprocess.CREATE_NEW_PROCESS_GROUP if os.name == "nt" else 0,
            )
            # Windows can defer Python signal handlers during an infinite OS wait.
            # Short bounded waits let Ctrl+C reach the harness while it is running.
            while True:
                try:
                    code = self.child.wait(timeout=0.2)
                    break
                except subprocess.TimeoutExpired:
                    continue
            return 130 if self.interrupted else code
        finally:
            for name, handler in saved.items():
                signal.signal(name, handler)


def runner_arguments(config):
    argv = [config["node"], str(ROOT / "tests/developer-workflow/run.mjs"),
            "--source", str(config["source"]), "--output", str(Path(config["output"]) / "evidence")]
    for key in VALUE_OPTIONS:
        if config.get(key):
            argv.extend(["--" + key.replace("_", "-"), str(config[key])])
    for key in ("android", "security"):
        if config.get(key):
            argv.append("--" + key)
    return argv


def worker(config_path):
    config = json.loads(Path(config_path).read_text(encoding="utf-8"))
    if sys.prefix == sys.base_prefix:
        raise RuntimeError("Disposable Python venv was not activated")
    print("Running existing tests from disposable Python environment.", flush=True)
    return ManagedCommand().run(runner_arguments(config), env=dict(os.environ), cwd=ROOT)


def remove_session(scratch):
    # Only delete the exact directory allocated by mkdtemp in the system temp root.
    resolved = scratch.resolve()
    if resolved.parent != Path(tempfile.gettempdir()).resolve() or not resolved.name.startswith("vocle-python-"):
        raise RuntimeError("Refusing unsafe disposable-session cleanup: " + str(resolved))

    def writable_retry(function, filename, _exc):
        path = Path(filename)
        if not path.resolve().is_relative_to(resolved):
            raise RuntimeError("Cleanup path escaped the disposable session")
        os.chmod(path, stat.S_IWRITE | stat.S_IREAD | stat.S_IEXEC)
        function(filename)

    if sys.version_info >= (3, 12):
        shutil.rmtree(resolved, onexc=writable_retry)
    else:
        shutil.rmtree(resolved, onerror=writable_retry)


def run_session(args):
    output = args.output or ROOT / "tests/developer-workflow/output" / (
        "python-" + datetime.now(timezone.utc).strftime("%Y-%m-%dT%H-%M-%SZ") + "-" + uuid.uuid4().hex[:8])
    output.mkdir(parents=True, exist_ok=False)
    state = {"schemaVersion": 1, "startedAt": datetime.now(timezone.utc).isoformat(),
             "status": "ERROR", "profile": args.profile, "source": str(args.source),
             "python": sys.version.split()[0], "cleanup": "NOT_STARTED", "runnerExitCode": None}
    scratch = None
    code = 1
    try:
        if sys.version_info < (3, 10):
            raise RuntimeError("Python 3.10 or later is required")
        for tool in ("git", "node", "npm"):
            if not shutil.which(tool):
                raise RuntimeError("Install prerequisite and put it on PATH: " + tool)
        node = shutil.which("node")
        version = subprocess.check_output([node, "--version"], text=True, timeout=15).strip()
        if int(version.lstrip("v").split(".")[0]) < 22:
            raise RuntimeError("Node 22 or later is required; found " + version)
        state["node"] = version
        scratch = Path(tempfile.mkdtemp(prefix="vocle-python-"))
        state["temporaryDirectory"] = str(scratch)
        state["cleanup"] = "PENDING"
        print("Creating disposable venv and package caches: " + str(scratch), flush=True)
        venv.EnvBuilder(with_pip=False).create(scratch / "venv")
        config = {key: str(value) if isinstance(value, Path) else value for key, value in vars(args).items()}
        config.update(output=str(output), node=node)
        config_path = scratch / "session.json"
        config_path.write_text(json.dumps(config), encoding="utf-8")
        python = scratch / "venv" / ("Scripts/python.exe" if os.name == "nt" else "bin/python")
        command = ManagedCommand()
        code = command.run([str(python), "-B", str(Path(__file__).resolve()), "--_worker", str(config_path)],
                           env=session_environment(scratch), cwd=ROOT)
        state["runnerExitCode"] = code
        manifest_path = output / "evidence/manifest.json"
        if manifest_path.is_file():
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            state.update(gate=manifest["gate"], releaseGate=manifest.get("releaseGate"))
        else:
            raise RuntimeError("Runner produced no manifest; see terminal diagnostics")
        state["status"] = "PASS" if code == 0 and state["gate"] == "PASS" else "INTERRUPTED" if code == 130 else "ERROR" if code == 0 else "NON_SUCCESS"
        if state["status"] != "PASS" and code == 0:
            code = 1
    except KeyboardInterrupt:
        state["status"], state["error"], code = "INTERRUPTED", "Cancelled by user", 130
    except Exception as error:
        state["error"] = str(error)
        code = 1
    finally:
        if scratch:
            try:
                remove_session(scratch)
                state["cleanup"] = "PASS"
            except Exception as error:
                state["cleanup"], state["cleanupError"], state["status"], code = "ERROR", str(error), "ERROR", 1
        state["finishedAt"] = datetime.now(timezone.utc).isoformat()
        (output / "local-session.json").write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
        (output / "local-session.md").write_text(
            "# Disposable local test session\n\n"
            + f"Session: **{state['status']}**. Profile: {args.profile}. "
            + f"Test gate: {state.get('gate', 'NO_EVIDENCE')}. Cleanup: {state['cleanup']}.\n\n"
            + "Existing JSON, Markdown, JUnit, ownership and submission evidence: [evidence/](evidence/).\n\n"
            + "Open [the local dashboard](evidence/detailed/vocle-regression-dashboard.html) for test details.\n\n"
            + "A tooling/smoke PASS does not certify the full application or release.\n\n"
            + ("Error: " + state["error"] + "\n" if state.get("error") else "")
            + ("Cleanup error: " + state["cleanupError"] + "\n" if state.get("cleanupError") else ""),
            encoding="utf-8",
        )
        print(f"Reports: {output}\nSession: {state['status']}; cleanup: {state['cleanup']}", flush=True)
        if state.get("error"):
            print(state["error"], file=sys.stderr)
    return code


if __name__ == "__main__":
    if len(sys.argv) == 3 and sys.argv[1] == "--_worker":
        sys.exit(worker(sys.argv[2]))
    try:
        sys.exit(run_session(parse_args()))
    except (FileExistsError, PermissionError) as error:
        print("Cannot create a fresh report directory: " + str(error), file=sys.stderr)
        sys.exit(1)
