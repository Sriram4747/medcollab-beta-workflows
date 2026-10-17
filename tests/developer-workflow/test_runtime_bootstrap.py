"""Verify automatic setup, pinned downloads, isolation and ownership safeguards."""

import io
import json
import os
from pathlib import Path
import sys
import tarfile
import tempfile
import unittest
from unittest.mock import patch
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "scripts"))
from vocle_bootstrap import Bootstrap, SetupRequired, decode, download, extract, owned_mounts, proxy_args, windows_mount


class RuntimeBootstrapTests(unittest.TestCase):
    def test_checksum_failure_rejects_download_before_execution(self):
        with tempfile.TemporaryDirectory() as directory:
            destination = Path(directory) / "runtime.zip"
            with patch("urllib.request.urlopen", return_value=io.BytesIO(b"tampered")):
                with self.assertRaisesRegex(SetupRequired, "checksum"):
                    download({"url": "https://example.invalid/runtime.zip", "sha256": "0" * 64}, destination)
            self.assertFalse(destination.exists())

    def test_zip_traversal_cannot_write_outside_disposable_directory(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            archive = root / "bad.zip"
            with zipfile.ZipFile(archive, "w") as bundle:
                bundle.writestr("../escaped.txt", "refuse")
            with self.assertRaisesRegex(SetupRequired, "Unsafe"):
                extract(archive, root / "install")
            self.assertFalse((root / "escaped.txt").exists())

    def test_tar_escape_symlink_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            archive = Path(directory) / "bad.tar"
            with tarfile.open(archive, "w") as bundle:
                link = tarfile.TarInfo("node/link")
                link.type, link.linkname = tarfile.SYMTYPE, "../../outside"
                bundle.addfile(link)
            with self.assertRaisesRegex(SetupRequired, "escapes"):
                extract(archive, Path(directory) / "install")

    def test_windows_mount_translation_retains_spaces_and_refuses_remote_shares(self):
        self.assertEqual(windows_mount(r"C:\work folder\target"), "/mnt/c/work folder/target")
        with self.assertRaises(SetupRequired):
            windows_mount(r"\\server\share\target")
        self.assertEqual(decode("No distributions".encode("utf-16-le")), "No distributions")

    def test_assertion_network_none_is_preserved_and_only_preparation_uses_host(self):
        assertion = ["run", "--network", "none", "--mount", r"type=bind,source=C:\work folder,target=/target,readonly", "image"]
        mapped = proxy_args(assertion, "wsl")
        self.assertNotIn("--network=host", mapped)
        self.assertIn("none", mapped)
        self.assertIn("type=bind,source=/mnt/c/work folder,target=/target,readonly", mapped)
        self.assertEqual(proxy_args(["run", "--rm", "image"], "linux")[1], "--network=host")

    def test_private_daemon_never_uses_global_data_configuration_or_tcp(self):
        with tempfile.TemporaryDirectory() as directory:
            scratch = Path(directory)
            setup = Bootstrap(scratch, scratch, {"PATH": os.environ["PATH"]}, {})
            flags = setup.daemon_flags(scratch, "unix://" + str(scratch / "socket"))
            for key in ("--config-file", "--data-root", "--exec-root", "--pidfile", "--containerd"):
                self.assertTrue(Path(flags[flags.index(key) + 1]).is_relative_to(scratch))
            self.assertIn("--bridge=none", flags)
            self.assertFalse(any("tcp://" in flag for flag in flags))

    def test_namespace_cleanup_selects_only_mounts_inside_the_owned_engine(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory).resolve() / "engine"
            # mountinfo uses forward slashes even when fixture tests run on Windows.
            path = root.as_posix()
            lines = [f"1 0 0:1 / {path}/exec/netns/default rw - nsfs nsfs rw",
                     f"2 0 0:1 / {path}-other/netns/default rw - nsfs nsfs rw",
                     "3 0 0:1 / /run/docker/netns/default rw - nsfs nsfs rw"]
            self.assertEqual(owned_mounts("\n".join(lines), root), [root / "exec/netns/default"])

    def test_remote_existing_context_is_refused(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            setup = Bootstrap(root, root, {"PATH": "tools"}, {})
            with patch("vocle_bootstrap.shutil.which", return_value="docker"), patch.object(setup, "command", return_value=(0, "ssh://remote")) as command:
                with self.assertRaisesRegex(SetupRequired, "remote"):
                    setup.docker()
                self.assertEqual(command.call_count, 1)  # Inspect local config before contacting a daemon.

    def test_one_time_windows_setup_reports_restart_and_does_not_run_tests(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            setup = Bootstrap(root, root, {"PATH": os.environ["PATH"]}, {})
            setup.wsl = "wsl.exe"
            (root / "windows-setup.json").write_text(json.dumps({"exitCode": 3010}))
            with patch.object(setup, "command", side_effect=[(1, "not installed"), (0, "installed")]):
                with self.assertRaises(SetupRequired) as error:
                    setup.ensure_wsl()
            self.assertEqual(error.exception.status, "RESTART_REQUIRED")
            self.assertIsNone(setup.guest)

    def test_cleanup_refuses_unverified_wsl_ownership(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            state = {}
            setup = Bootstrap(root, root, {"PATH": os.environ["PATH"]}, state)
            setup.guest = "Vocle-Test-" + "a" * 32
            with patch.object(setup, "verify_wsl_owner", side_effect=SetupRequired("path not owned")), patch.object(setup, "command") as command:
                with self.assertRaises(SetupRequired):
                    setup.close()
                command.assert_not_called()
            self.assertEqual(state["runtimeSetup"]["cleanup"], "ERROR")


if __name__ == "__main__":
    unittest.main()
