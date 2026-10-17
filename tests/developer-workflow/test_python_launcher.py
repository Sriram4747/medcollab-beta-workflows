"""Launcher lifecycle contracts; application assertions remain in existing suites."""

import importlib.util
import json
import os
from pathlib import Path
import signal
import sys
import tempfile
import threading
import time
import unittest
from unittest.mock import patch


spec = importlib.util.spec_from_file_location("test_vocle_launcher", Path(__file__).resolve().parents[2] / "scripts/test_vocle.py")
launcher = importlib.util.module_from_spec(spec)
spec.loader.exec_module(launcher)


class PythonLauncherTests(unittest.TestCase):
    def test_forwards_source_revision_options_and_previous_python_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            previous = Path(directory) / "previous report"
            (previous / "evidence").mkdir(parents=True)
            args = launcher.parse_args(["--source", directory, "--commit", "a" * 40,
                                        "--previous", str(previous), "--flutter-bin", "relative sdk/flutter",
                                        "--android", "--security", "--profile", "full"])
            config = vars(args) | {"node": "node", "output": str(Path(directory) / "new report")}
            argv = launcher.runner_arguments(config)
            self.assertEqual(argv[argv.index("--source") + 1], str(Path(directory).resolve()))
            self.assertEqual(argv[argv.index("--commit") + 1], "a" * 40)
            self.assertEqual(argv[argv.index("--previous") + 1], str((previous / "evidence").resolve()))
            self.assertTrue(Path(argv[argv.index("--flutter-bin") + 1]).is_absolute())
            self.assertIn("--android", argv)
            self.assertIn("--security", argv)

    def test_venv_caches_and_home_are_local_without_application_credentials(self):
        with tempfile.TemporaryDirectory() as directory:
            scratch = Path(directory)
            env = launcher.session_environment(scratch, {"PATH": "runtime-path", "HOME": directory,
                                                        "MONGODB_URI": "must-not-leak", "GITHUB_TOKEN": "must-not-leak"})
            for key in ("PUB_CACHE", "NPM_CONFIG_CACHE", "GRADLE_USER_HOME", "HOME", "TMPDIR", "VIRTUAL_ENV"):
                self.assertTrue(Path(env[key]).is_relative_to(scratch))
            self.assertNotIn("MONGODB_URI", env)
            self.assertNotIn("GITHUB_TOKEN", env)
            self.assertIn("venv", env["PATH"])

    def test_setup_failure_keeps_report_and_rejects_reused_output(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "reports"
            args = launcher.parse_args(["--output", str(output), "--profile", "tooling"])
            with patch.object(launcher.shutil, "which", return_value=None):
                self.assertEqual(launcher.run_session(args), 1)
            session = json.loads((output / "local-session.json").read_text(encoding="utf-8"))
            self.assertEqual(session["status"], "ERROR")
            self.assertIn("git", session["error"])
            self.assertFalse((output / "evidence/pass-manifest.json").exists())
            with self.assertRaises(FileExistsError):
                launcher.run_session(args)

    def test_cleanup_removes_owned_readonly_files_and_refuses_other_paths(self):
        scratch = Path(tempfile.mkdtemp(prefix="vocle-python-"))
        readonly = scratch / "readonly.txt"
        readonly.write_text("disposable", encoding="utf-8")
        os.chmod(readonly, 0o444)
        launcher.remove_session(scratch)
        self.assertFalse(scratch.exists())
        with tempfile.TemporaryDirectory() as other:
            with self.assertRaisesRegex(RuntimeError, "unsafe"):
                launcher.remove_session(Path(other))
            self.assertTrue(Path(other).exists())

    def test_cancellation_waits_for_child_cleanup_and_returns_non_success(self):
        with tempfile.TemporaryDirectory() as directory:
            ready = Path(directory) / "ready"
            cleaned = Path(directory) / "cleaned"
            fixture = (
                "import signal,sys,time\nfrom pathlib import Path\n"
                "def stop(*args):\n Path(sys.argv[2]).write_text('closed')\n sys.exit(0)\n"
                "signal.signal(signal.SIGBREAK if sys.platform == 'win32' else signal.SIGTERM, stop)\n"
                "Path(sys.argv[1]).write_text('ready')\nwhile True: time.sleep(0.05)\n"
            )
            command = launcher.ManagedCommand()

            def cancel_after_ready():
                for _ in range(100):
                    if ready.exists():
                        break
                    time.sleep(0.05)
                # Exercise an actual pending Python signal during the OS wait.
                signal.raise_signal(signal.SIGINT)
                for _ in range(100):
                    if command.child.poll() is not None:
                        return
                    time.sleep(0.05)
                command.child.kill()  # Bound a regression instead of hanging CI.

            trigger = threading.Thread(target=cancel_after_ready)
            trigger.start()
            try:
                result = command.run([sys.executable, "-c", fixture, str(ready), str(cleaned)],
                                     env=dict(os.environ), cwd=directory)
                self.assertEqual(result, 130)
                self.assertEqual(cleaned.read_text(), "closed")
                self.assertIsNotNone(command.child.poll())
            finally:
                trigger.join(timeout=10)


if __name__ == "__main__":
    unittest.main()
