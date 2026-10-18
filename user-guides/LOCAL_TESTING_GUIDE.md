# Vocle local testing: developer user guide

Updated: 18 October 2026. Applies to `scripts/test_vocle.py` and
`scripts/test_vocle_cloudinary.py` in this repository.

## Contents

1. [What this tool does](#1-what-this-tool-does)
2. [Choose your test scope](#2-choose-your-test-scope)
3. [Before you start: hardware, storage, time and inputs](#3-before-you-start-hardware-storage-time-and-inputs)
4. [Install the prerequisites on Windows](#4-install-the-prerequisites-on-windows)
5. [Get the repository and check your setup](#5-get-the-repository-and-check-your-setup)
6. [Run all 187 functional cases](#6-run-all-187-functional-cases)
7. [Other useful commands](#7-other-useful-commands)
8. [Run the real Cloudinary tests](#8-run-the-real-cloudinary-tests)
9. [Find and read your results](#9-find-and-read-your-results)
10. [What cleanup removes and what stays](#10-what-cleanup-removes-and-what-stays)
11. [Troubleshooting](#11-troubleshooting)
12. [Share evidence with QA and compare runs](#12-share-evidence-with-qa-and-compare-runs)
13. [Linux, macOS and architecture limitations](#13-linux-macos-and-architecture-limitations)
14. [First-run checklist and reference links](#14-first-run-checklist-and-reference-links)

## 1. What this tool does

Run one Python command on your development computer. The launcher creates a
temporary Python virtual environment, prepares the required tools and packages,
runs the existing repository tests, saves the results and cleans up its owned
temporary resources. You do not need to create or activate a venv yourself.

Python coordinates the run. Node executes the backend tests, Flutter/Dart executes
the Flutter tests, and an Android emulator executes the native tests. Linux
containers isolate backend tests. Docker and the emulator run outside the Python
venv because they need operating-system services.

The same maintained assertions are reused locally and in GitHub workflows. Local
testing gives developers feedback before submitting changes. GitHub still
independently validates the submitted revision. A local report does not bypass CI
or QA approval. A test that fails locally remains a failure in the report.

## 2. Choose your test scope

| What you need | Command options | Functional scope | Extra execution |
| --- | --- | --- | --- |
| All 187 functional cases, with CI checks | `--commit SHA --android --ci-checks` | 147 backend + 32 Flutter + 8 Android | Retained tests, tooling, analysis and secret scan |
| Functional plus isolated security | `--commit SHA --all` | The same 187 | Existing media, data and API security suites; CI checks |
| Everything above plus real Cloudinary | `--commit SHA --all --cloudinary --test-cloud NAME` | The same 187 | Real provider tests with private prompts |
| Work in progress without Android | `--source . --ci-checks` | 179 backend/Flutter | Includes uncommitted application edits |
| Tooling only | `--profile tooling --ci-checks` | No functional cases | Runner/reporting and prerequisite checks |
| Backend smoke only | `--profile backend-smoke` | Smoke coverage only | Does not establish 147 or 187 case completion |
| Isolated security only | `--profile security` | No functional cases | Existing security runtime |

`SHA` means a complete lowercase 40-character Git commit ID. The examples below
obtain it with `git rev-parse HEAD`; you usually do not type it manually.

The 48 retained sanity cases are already included in the 147 backend cases.
The 33 retained Flutter tests are additional. Security has 819 suite executions
(97 media + 31 data + 691 discovery); real Cloudinary adds 34. Some security IDs
occur in more than one suite. Do not add those numbers to the 187 and describe
them as unique functional cases. Tooling check counts are also separate.

## 3. Before you start: hardware, storage, time and inputs

### Validated environment and planning guidance

The complete 187-case path was validated on **Windows 11 x64**, with Android Studio
JDK 21, an x86_64 Google Play Android image, and WSL 2. Linux CI validates tooling
and backend smoke; it does not establish a complete Linux Android run. See
[other-platform limits](#13-linux-macos-and-architecture-limitations).

The following are planning estimates, not measured minimum requirements or
installation guarantees:

| Resource | Plan for |
| --- | --- |
| CPU | x64 processor with hardware virtualization; 8 logical cores recommended for a full run. The owned AVD requests 4 cores. |
| RAM | 32 GB recommended for a full run. The AVD requests 4 GB; Gradle can request an 8 GB heap, while WSL and the host also need memory. 16 GB machines may need other applications closed and can still run out of memory. |
| Temporary free disk | Allow **50 GB free** on the drive used by your OS temporary directory before a full cold run. There is no measured peak-storage guarantee. |
| Permanent Android setup | Allow a further **15–30 GB** for Android Studio, SDK platforms, emulator, system image, NDK and supporting tools; actual installed selections vary. Budget around **75 GB free total** on a new machine when everything shares one drive. |
| Retained reports | Budget **0.5–2 GB per full run**, with extra space for security/diagnostics. The October 18 full result, including extra browser verification copies, occupies about **201 MiB**. This is retained evidence size, not peak working space. |
| Network | Reliable internet for setup. Expect several GB of downloads on a cold machine; transient caches are removed, so later runs can download again. No measured transfer-size guarantee. |
| Time | The validated 187-case run took about **28 minutes**, reusing installed Flutter/SDK/JDK. Plan **30–90+ minutes** for a cold run; security/provider suites and slow networks add time. |
| Power | Use AC power and prevent sleep during the run. |

Space is needed both where the repository/reports live and where the temporary
session lives. By default Windows uses `%TEMP%`; moving reports with `--output`
does not move the temporary runtime. If drives differ, check each one. An existing
Docker engine stores images on its configured Docker data drive as well.

For a first estimate in PowerShell:

```powershell
Get-PSDrive -PSProvider FileSystem
[System.IO.Path]::GetTempPath()
```

### Information and permissions you need

| Input or permission | Needed when? | What to prepare |
| --- | --- | --- |
| Repository access | Always | Clone this fork or use a checkout with the testing scripts. Private access, if applicable, must already work in Git. |
| Source revision | Full 187 run | A local commit containing the app changes you want tested. The launcher does not commit or push your work. |
| Android SDK and JDK paths | Full 187 run | Usually discovered on Windows; set `ANDROID_HOME` and `JAVA_HOME` if installed elsewhere. |
| Administrator/IT approval | First-time Windows platform setup | WSL/virtualization may need elevation and one restart. The tests normally run in a regular terminal. |
| SDK license acceptance | Android setup | Review and accept the applicable Android SDK licenses yourself. |
| Linux sudo or local Docker access | Linux backend/security | Required to start the private engine or use an existing engine. |
| Cloudinary test cloud name, API key and API secret | Only live provider testing | Approved, isolated test account. Enter the key and secret only in the hidden terminal prompts. |
| Output location | Optional | Default is automatic. A custom `--output` directory must not already exist. |

The 187-case command does not ask for production database, Firebase, MSG91 or
Cloudinary credentials. It uses disposable databases and controlled test fixtures.
Do not supply production `.env` files or real user data. Live provider testing is
an explicit additional selection.

### Downloads and corporate networks

Setup accesses package/SDK registries and release hosts, including GitHub and its
download CDNs, nodejs.org, registry.npmjs.org, pub.dev, storage.googleapis.com,
pypi.org/files.pythonhosted.org, Ubuntu package mirrors, download.docker.com,
Docker Hub/auth endpoints, fastdl.mongodb.org, Google Android/Maven repositories,
Gradle distribution/plugin hosts and Maven Central. This list is indicative;
redirects and dependency hosts can vary. Live testing additionally accesses the
approved Cloudinary API/delivery hosts through its existing broker.

The launcher intentionally filters environment variables. General proxy, custom
CA and package-mirror environment variables are not automatically carried into
the isolated session. If your network requires them, arrange an approved setup
with IT; there is no documented universal proxy flag. Do not disable TLS, checksum
verification or container isolation to get around a download error.

## 4. Install the prerequisites on Windows

### 4.1 Python and Git: install once

1. Install **64-bit Python 3.10 or later** from the
   [Python Windows downloads page](https://www.python.org/downloads/windows/).
   Include `venv`/pip and put Python on PATH. Python 3.12 was validated locally.
2. Install Git using the [official Git installation instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
   Ensure `git` is available to terminal applications.
3. Open a new PowerShell window and check:

```powershell
python --version
git --version
python -m venv --help
```

If `python` opens the Microsoft Store or is missing, fix your Python installation
or Windows app execution alias. If your installation uses the `py` launcher,
you may use `py -3` in place of `python` in the commands below after confirming
it selects Python 3.10+. Do not install Python packages into your global Python
environment for this runner.

### 4.2 WSL 2 and virtualization: install/enable once

For automatic minimal Docker setup on Windows, WSL 2 must be able to start.
Use a supported Windows 11 x64 machine. Microsoft's installation command also
supports Windows 10 version 2004/build 19041 or later; this project's complete run
was validated on Windows 11. See the [Microsoft WSL installation guide](https://learn.microsoft.com/en-us/windows/wsl/install).

Enable CPU virtualization in BIOS/UEFI if it is disabled. Windows Virtual Machine
Platform is needed by WSL 2. The Android emulator also needs a working hypervisor;
follow [Android's acceleration instructions](https://developer.android.com/studio/run/emulator-acceleration)
for Windows Hypervisor Platform (WHPX).

The Python launcher can request elevation to install the WSL platform with its
fixed setup helper. If it prints `RESTART_REQUIRED`, restart Windows and rerun
the same test command. That attempt has not run the application tests.

If IT prefers to prepare WSL beforehand, run the following in an administrator
PowerShell, then restart when requested:

```powershell
wsl --install --no-distribution --web-download
```

After the restart, check in a normal terminal:

```powershell
wsl --status
```

You do not need to install a personal Ubuntu distribution or Docker Desktop for
the managed path. The runner imports its own disposable `Vocle-Test-...` guest.
Windows WSL remains installed after the guest is removed. If your machine is
itself a VM, IT must provide the virtualization capabilities needed by WSL and
the emulator; otherwise use a suitable development machine.

### 4.3 Android Studio, SDK and JDK: install once for all 187 cases

1. Install [Android Studio](https://developer.android.com/studio).
2. Open **SDK Manager** (from the welcome screen's More Actions or the IDE's
   Tools menu). Note the **Android SDK Location**.
3. Install the SDK packages in the table below. Enable **Show Package Details**
   where required. Complete downloads before starting the tests.
4. Review/accept licenses when prompted. The launcher does not accept them for you.

| SDK selection | Requirement for the current app |
| --- | --- |
| Android SDK Platform-Tools | Provides `adb` |
| Android Emulator | Provides the headless native test device |
| Android SDK Command-line Tools | Provides `avdmanager` and `sdkmanager` |
| Android SDK Platform 35 and Build-Tools 35.0.0 | Current Flutter 3.29.3 default compile SDK; install additional versions if a selected app revision explicitly requires them |
| NDK (Side by side) 27.0.12077973 | Explicit version in the app's Android build configuration |
| x86_64 Android system image with Google Play | Validated selection: `system-images;android-36.1;google_apis_playstore;x86_64`; includes a document viewer used by media tests |

Do not assume an arbitrary emulator image has the same native behavior. The
launcher currently selects the lexically last installed `*/*/x86_64/package.xml`
image; there is no image-selection CLI flag. If several images are installed,
check the selected image printed by the launcher. For reproducibility, use a
dedicated SDK installation with the validated image if necessary. You do not
need to create an AVD manually.

The Android Studio JDK 21 was validated. On a standard Windows install its path
is `C:\Program Files\Android\Android Studio\jbr`. If yours differs, configure
these variables in the PowerShell terminal used for testing:

```powershell
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
Test-Path "$env:ANDROID_HOME\platform-tools\adb.exe"
Test-Path "$env:ANDROID_HOME\emulator\emulator.exe"
Test-Path "$env:ANDROID_HOME\cmdline-tools\latest\bin\avdmanager.bat"
& "$env:JAVA_HOME\bin\java.exe" -version
& "$env:ANDROID_HOME\emulator\emulator.exe" -accel-check
```

Change the example paths to your actual locations. Versioned command-line-tools
directories are accepted too; `latest` is just the common example. If
`ANDROID_SDK_ROOT` is also set, keep it consistent with `ANDROID_HOME`.
Terminal assignments above last for that terminal session only.

For command-line SDK installation, use the installed `sdkmanager.bat` and the
[official sdkmanager instructions](https://developer.android.com/tools/sdkmanager).
For example, after configuring Java/SDK paths:

```powershell
& "$env:ANDROID_HOME\cmdline-tools\latest\bin\sdkmanager.bat" --install 'platform-tools' 'emulator' 'platforms;android-35' 'build-tools;35.0.0' 'ndk;27.0.12077973' 'system-images;android-36.1;google_apis_playstore;x86_64'
& "$env:ANDROID_HOME\cmdline-tools\latest\bin\sdkmanager.bat" --licenses
```

Read the license prompts. Gradle may request other SDK components for plugins;
allow space and install the exact versions named by a genuine SDK diagnostic.
Do not change app SDK versions merely to suppress a setup error.

### 4.4 What the script prepares automatically

| Component | Behavior |
| --- | --- |
| Python venv | Creates and deletes it; `--ci-checks` installs its needed Python packages there |
| Node/npm | Reuses a working Node >=22 with npm, or downloads locked Node 22.20.0 on a supported platform |
| Flutter | Reuses exact Flutter 3.29.3 if found or explicitly provided; otherwise installs a disposable pinned SDK |
| Dart/Flutter packages | Fetches the app's dependencies using the existing runner and checks dependency integrity |
| Backend/sanity packages | Uses locked dependency installation in the isolated test setup |
| Minimal Docker/containerd | Reuses a running local Linux Docker engine, or provisions a private engine on x64 Windows/Linux |
| MongoDB | Prepares test-owned Mongo binaries/databases; no MongoDB service installation or Atlas account needed |
| Gradle | Prepares verified Gradle 8.10.2 in the disposable cache for Android |
| Gitleaks | Prepares the checksum-verified version when `--ci-checks` is selected |
| Android AVD | Creates/boots a temporary 4-core/4-GB AVD from the installed image, then removes it |

Runtime pins/checksums are in `scripts/vocle-runtime-lock.json`. Do not upgrade
Flutter or dependency lockfiles just to make a failed case disappear.

## 5. Get the repository and check your setup

### Fresh checkout

Open a **normal Windows PowerShell terminal**, not an Android device shell, Python
interactive prompt or WSL shell. The IDE terminal is fine if it is PowerShell.
Use a short local path that you can write to. Avoid cloud-synced/network folders,
commas and shell characters such as `&`, `%`, `^` or `!` in tool/checkout paths.

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\source" -Force | Out-Null
Set-Location "$env:USERPROFILE\source"
git clone --branch master https://github.com/Sriram4747/medcollab-beta-workflows.git
Set-Location .\medcollab-beta-workflows
```

Use your team's approved source checkout when different, while retaining the
current testing scripts. This repository's `origin` is the experimental testing
fork. `upstream` is read-only; do not push test tooling or findings there.

### Existing checkout

Change into the **repository root**, the folder containing `scripts`,
`medcollab-app`, `medcollab-backend` and `.git`. For example:

```powershell
Set-Location 'C:\path\to\medcollab-beta-workflows'
git status --short
git remote -v
git rev-parse --show-toplevel
Test-Path .\scripts\test_vocle.py
python .\scripts\test_vocle.py --help
```

Use a fresh clone or update through your normal Git workflow if the script is
missing/outdated. Preserve your existing edits; do not reset/clean the checkout.
Run one local validation at a time. Close Android emulators and disconnect
physical Android devices before a full run:

```powershell
& "$env:ANDROID_HOME\platform-tools\adb.exe" devices
```

If `ANDROID_HOME` was not set and your SDK is in its standard location, set it
using section 4.3 before this check. The device list should contain no connected
devices. The launcher will create the one required emulator itself.

## 6. Run all 187 functional cases

### Step 1: decide which application bytes to test

For all 187 cases, the app must be in a **local Git commit**. Review your changes
and create a commit through your normal workflow if you want those changes tested.
A local commit does not require a push. The launcher does not create commits.

`--commit (git rev-parse HEAD)` tests committed application code. Uncommitted app
edits are excluded. The harness separately fingerprints the test definitions it
uses; keep test/tooling changes committed for a reviewable shared run. Do not edit
test definitions or dependency files while a run is active.

### Step 2: run this in the repository root

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks
```

Nothing else needs to be started: no backend server, Mongo service, emulator,
manual venv or production accounts. Allow setup downloads and any first-time
Windows platform approval. After a required restart, repeat this command.

### Step 3: wait for the result and cleanup

Typical progress:

```text
Reports for this invocation: ...\test-results\full-187\<run-id>
Creating disposable venv and package caches: ...\vocle-python-...
Preparing local Linux container runtime...
Selecting or installing pinned Flutter 3.29.3...
Creating a disposable Android emulator...
Running existing tests from disposable Python environment.
Running backend-driver
Running flutter-analysis
Running android-driver
Functional cases executed: 187/187; PASS=...; FAIL=...; ...
Reports: ...\test-results\full-187\<run-id>
Session: ...; cleanup: ...
```

Some long commands buffer their output until they finish. A quiet terminal during
image downloads or a cold Android build is not by itself proof of a hang. Check
the run folder/logs rather than launching a second run. Wait for the final
`Reports:` and `cleanup:` lines before judging completion or sharing the report.

## 7. Other useful commands

All examples below run from the repository root in PowerShell.

### Include the additional isolated security suites

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --all
```

`--all` means Android + isolated security + CI checks. Live Cloudinary and
iOS/physical-device delivery coverage still require separate, explicit support.

### Test uncommitted app changes without Android (179 cases)

```powershell
python .\scripts\test_vocle.py --source . --ci-checks
```

Add `--security` to include isolated security. This is working-tree evidence, not
an eight-case Android run. The existing native runner accepts committed archives.
Do not combine an older device report with different uncommitted app bytes.

### Tooling or security only

```powershell
python .\scripts\test_vocle.py --source . --profile tooling --ci-checks
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --profile security
```

These are separate invocations and each gets its own folder; neither replaces the
latest full-run pointer. A small tooling PASS does not establish 187-case coverage.

### Existing versus disposable Docker

Default `--runtime auto` reuses a working local Linux engine if available,
otherwise provisions the supported private engine. To force the private path:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks --runtime managed
```

`--runtime existing` requires a running local Linux Docker engine. Windows
containers and remote Docker contexts are rejected. User Docker configuration,
existing engine and its downloaded image cache remain installed after a reused
engine run. Docker Desktop is optional for the validated managed Windows path.

### Explicit Flutter or custom output

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks --flutter-bin 'C:\tools\flutter-3.29.3\bin\flutter.bat'
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks --output 'D:\VocleReports\my-new-run'
```

The explicit Flutter path must report 3.29.3. A custom output directory must be
new; existing evidence is never overwritten. All sub-results for the invocation
remain in that directory. `LATEST_FULL_RUN.txt` still points to a full invocation
with custom output. `--source` can name another checkout for backend/Flutter;
the native integration currently requires committed source available in this
harness checkout, so use `--source .` for the documented 187-case path.

## 8. Run the real Cloudinary tests

This suite creates synthetic assets in an external provider account. Ask the
account owner for an approved **isolated non-production test cloud**, its name,
API key and API secret, and permission to upload/delete test assets. Provider
usage/charges depend on that account. Ordinary 187-case testing needs none of
these inputs.

Run in your own interactive PowerShell terminal:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --all --cloudinary --test-cloud YOUR_TEST_CLOUD
```

Replace `YOUR_TEST_CLOUD` with the approved cloud name. Do not use the literal
placeholder. The script asks privately for the API key and API secret; nothing
is displayed while you type. Enter them and press Enter. Keys/secrets must not
be pasted into chat, command arguments, Git or credential files. They are not
read from a production `.env`. Source/run identity, broker restrictions, scoped
resource cleanup and independent cleanup verification still apply.

This option runs the provider lane first; its sanitized results and the other
lanes are retained in the same full-run folder. A provider failure is retained as
non-success evidence; inspect its session details. A private terminal is required.

For provider tests alone:

```powershell
python .\scripts\test_vocle_cloudinary.py --test-cloud YOUR_TEST_CLOUD --commit (git rev-parse HEAD)
```

Standalone results use `test-results\cloudinary\<run-id>\`. `--offline-check`
on that standalone launcher validates preparation/guards without provider calls;
it does not execute the 34 live cases.

If provider cleanup is unproven, retain its report/recovery journal, contact the
test account owner, and follow the session's recovery details. The supported
cleanup retry takes the same cloud, source SHA and exact recorded results path:

```powershell
python .\scripts\test_vocle_cloudinary.py --test-cloud YOUR_TEST_CLOUD --commit EXACT_40_CHARACTER_SOURCE_SHA --resume-cleanup 'C:\path\to\vocle-cloudinary-results'
```

Replace the placeholders; this retries only recorded resources. Do not delete
the cloud, clear a whole folder/account or discard the recovery journal to make
cleanup appear successful. Artifact-hygiene failures can retain a private
temporary directory instead of exporting unsafe evidence; inspect
`privateEvidenceDirectory`/recovery fields in `local-session.json`.

## 9. Find and read your results

### One invocation, one result folder

```text
repository-root/
  test-results/
    LATEST_FULL_RUN.txt
    full-187/
      <UTC timestamp>-<unique id>/
        README.md
        vocle-regression-dashboard.html       <- open this for the 187 cases
        functional-summary.json              <- executed count + outcomes
        vocle-regression-results.json
        vocle-regression-junit.xml
        vocle-regression-detailed-report.md
        vocle-regression-summary.md
        qa-defects.md / qa-defects.json
        local-session.md / local-session.json <- source, environment, cleanup
        setup.log
        android-emulator.log / docker-daemon.log (when applicable)
        evidence/
          backend/                           <- original backend reports
          flutter.json / flutter.ndjson
          android/                           <- original 8-case native report
          security/                          <- if selected
          diagnostics/                       <- commands, analysis and tooling
          manifest.json / results.json / submission.md
          detailed/                          <- all-checks dashboard
        cloudinary/                          <- if selected through main launcher
```

Other scopes use `test-results/functional-179/`, `tooling/`, `backend-smoke/`,
`security/` or `cloudinary/`. Run IDs use UTC, so the displayed time can differ
from your local clock. The root dashboard is written when orchestration finishes;
it will not exist yet during setup. An early setup failure may produce only
setup/session diagnostics and no functional dashboard.

To open the latest full dashboard after the run finishes:

```powershell
Get-Content .\test-results\LATEST_FULL_RUN.txt
$vocleLatest = Get-Content .\test-results\LATEST_FULL_RUN.txt
Start-Process -FilePath $vocleLatest[1]
```

Line 1 is the full run folder, line 2 its dashboard, line 3 the executed/session/
cleanup summary. The pointer updates when a full invocation finishes, including
failed or incomplete attempts. It means latest full-scope attempt, not latest
PASS. During a run it may still point to the previous finished invocation.
Read `functional-summary.json` and confirm **187 executed**, not just 187 selected.

The HTML report is self-contained and opens locally in a browser. Use its status,
module and ID filters; expand a case for its recorded expectation, observed
diagnostic and reproduction procedure. Procedure text is not a per-step trace.
Original artifacts and logs remain under `evidence/` in this same run folder.
`dashboard-check/` and `verification.json` in the October 18 sample were extra
maintainer verification artifacts; the normal launcher does not create them.

### Understand the statuses

| Status | Meaning / next action |
| --- | --- |
| `PASS` | The recorded checks passed within the case's stated scope. |
| `FAIL` | A checked expectation failed. Review the diagnostic, fix the cause and rerun. |
| `NEEDS_DECISION` | Intended behavior is unresolved. Product/QA must approve a contract, then implementation/assertions can be completed. It is not a pass. |
| `ERROR` | Setup, harness or execution could not complete reliably. Read its error category and logs before diagnosing app behavior. |
| `BLOCKED` | Required dependency/coverage is unavailable, or an explicitly optional lane was not selected. Required omissions prevent a full pass. |
| `SKIP` | Not executed; no pass credit. |
| Security `OBSERVATION` | The discovery suite recorded something for review. A green workflow can retain observations; it does not mean zero findings or prove a vulnerability. |

The top-level functional dashboard contains the selected functional catalog only.
The `evidence/detailed/` dashboard and combined console totals also contain
tooling and optional coverage, such as unselected provider/iOS/Jest lanes. Those
counts are not the 187-case denominator. Inspect whether a blocked row is required
or optional before interpreting it as missing selected functional execution.

`Session: NON_SUCCESS; cleanup: PASS` means the runtime cleaned up but the tests
or coverage gate did not all pass. It is normal to receive a nonzero exit when
the app has failures/undecided requirements. `cleanup: PASS` is resource cleanup,
not application correctness. `cleanup: ERROR` requires investigation.

Capture the process exit code immediately after testing with `$LASTEXITCODE`.
The launcher uses 0 for a passing session, 1 for failure/error, 3 for a requested
restart and 130 for interruption. Invalid arguments can exit 2. An outer shell
may display interruption differently; the saved session is the detailed record.

Baseline example, not a promise for your source: the October 18 committed run
executed 187/187 with 135 PASS, 31 FAIL, 21 NEEDS_DECISION, zero functional
ERROR/BLOCKED/SKIP and cleanup PASS. Fixing only environment setup does not fix
those product outcomes.

## 10. What cleanup removes and what stays

| Removed on successful cleanup | Retained |
| --- | --- |
| Owned Python venv, transient package caches and temporary app copies | Your checkout, commits and edits |
| Owned private WSL distribution/engine, or owned private Linux engine | Installed WSL Windows platform and its optional components |
| Owned test containers/databases/Mongo binaries | Existing local Docker installation and reused engine/image cache |
| Temporary AVD and dedicated test app | Installed Android Studio, SDK/system images and JDK; existing user AVDs |
| Disposable Flutter SDK, if installed for this run | A pre-existing Flutter SDK used by the run |
| Owned provider resources, when proven cleanup succeeds | Reports and any required private recovery evidence |

Android Gradle can install missing licensed SDK components into your existing
SDK; those shared SDK components are not temporary and remain installed. A
pre-existing Flutter SDK may retain SDK engine artifacts it downloaded. Reports
are intentionally kept until you archive/delete them. Existing user services,
emulators and WSL distributions must not be manually deleted as test cleanup.

To cancel, press **Ctrl+C once**, then wait for cleanup and the final report.
Avoid closing the terminal or killing the process tree. A power loss/forced
termination can prevent cleanup; do not assume the report is complete. Preserve
the session path and request help to identify its exact owned resources before
removing anything. Never use broad `docker system prune`, delete all AVDs or
unregister unrelated WSL distributions as a recovery step.

You can archive old, completed run folders after review. Do not delete an active
run or an unresolved provider recovery journal. `test-results/` is Git-ignored:
share approved evidence through your team's artifact channel, not by adding the
entire generated directory to Git.

## 11. Troubleshooting

| Symptom | What to check / do |
| --- | --- |
| Python/Git missing | Install them, reopen the terminal and verify PATH. No suite has run if setup stops here. |
| Cannot create venv/pip missing | Use a complete Python install with venv/pip. On Debian/Ubuntu install its matching `python3-venv` package. Do not manually create a venv in the repo. |
| `RESTART_REQUIRED` | Save the printed report path, restart Windows, then repeat the same command. If persistent, check firmware virtualization, Virtual Machine Platform and IT policy. |
| WSL import / `0x80370102` | WSL 2 virtualization is not available; inspect `setup.log`, validate a real post-install reboot and consult IT. |
| UAC denied / device managed by IT | Ask IT to install approved platform prerequisites. The Python venv cannot supply kernel virtualization. |
| Android SDK/JDK unavailable | Set the actual absolute `ANDROID_HOME`/`JAVA_HOME`; verify platform-tools, emulator, command-line tools and Java. |
| No x86_64 system image | Install the validated Google Play image through SDK Manager. Apple Silicon ARM images do not satisfy this selector. |
| Multiple/physical devices | Close the other emulators and disconnect physical devices; rerun when `adb devices` is empty. The launcher owns its fresh device. |
| Emulator exits/does not boot | Read `android-emulator.log`; check acceleration, RAM, free space, selected image and other virtualization workloads. Boot deadline is five minutes. |
| SDK licenses/build-tools/NDK error | Review licenses and install the exact requested SDK packages via SDK Manager; see section 4.3. |
| Missing PDF viewer/intent handler | Check the selected system image. Use the validated Google Play image; do not mark a native media assertion PASS without execution. |
| Wrong Flutter version | Remove an incorrect explicit override or pass the path to Flutter 3.29.3. The automatic path can install the pinned SDK. |
| Gradle/SDK/TLS/package download fails | Read `setup.log` and `evidence/diagnostics/`; check network, free space, trust configuration and registry access with IT. Keep checksum/TLS checks enabled. |
| Docker existing engine fails | Confirm it is local, running and uses Linux containers; use `--runtime managed` on supported x64 hosts when appropriate. |
| Remote Docker context rejected | Select an approved local engine or managed mode. Do not point local tests at a remote/production daemon. |
| `ENOSPC`, disk-full or memory error | Free space on temp, report and Docker drives; close heavy apps. Use the hardware/storage guidance. Fix the environment before trusting incomplete results. |
| Output directory already exists | Choose a new directory or omit `--output`; never overwrite previous evidence. |
| Android requested without commit | Add `--commit (git rev-parse HEAD)` and use full profile; commit your intended app changes first. |
| Only 18 tooling checks / no 187 functional results | Check the exact command and profile. Run the section 6 command and open the root functional dashboard for its newly printed folder. |
| 179 rather than 187 | Android was not selected. Use section 6 for committed full coverage. |
| `NON_SUCCESS`, but cleanup passed | Inspect functional failures, unresolved decisions and required supporting checks. This is not automatically a setup error. |
| Provider private-terminal error | Run in your own interactive terminal; do not pass credentials through redirection, chat or scripts. |
| Provider cleanup/hygiene error | Preserve the recovery journal; follow section 8 and ask the test account owner. Never perform broad cloud deletion. |
| Long Windows paths | Use a short local writable checkout/temp path. The launcher handles long disposable cleanup paths; retain the exact error if a dependency still fails. |

For help, supply the command with secrets omitted, OS/architecture, Python
version, source SHA, report directory, `local-session.json`, relevant sanitized
diagnostics, and cleanup status. For a missing dashboard, share setup/session
diagnostics; do not describe tests as executed without case evidence.

## 12. Share evidence with QA and compare runs

Keep JSON and manifest together: the manifest binds the recorded report checksum,
source revision, harness fingerprint, actual coverage and gate. The main evidence
folder includes `submission.md` with the existing submission format. Follow your
team's PR evidence policy; edit its placeholder report URL to an approved artifact
link when submitting. Do not use a failing/incomplete run as a success certificate.

`qa-defects.md` groups non-passing cases and requests ownership. Owners remain
`UNASSIGNED` until an approved ownership mapping exists. The runner does not
automatically assign people or send notifications.

To request a comparison against a previous complete Python session:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks --previous 'C:\path\to\previous-run'
```

The new run keeps comparison output under its own `evidence/comparison/`.
Changed definitions, harness/environment, source kind or unexecuted coverage can
make rows `NOT_COMPARABLE`. A status change is not proof of a code fix without
compatible execution evidence. `--previous` does not import old results as new
case executions. No previous report is needed for an ordinary first run.

## 13. Linux, macOS and architecture limitations

The documented full path is Windows x64. Do not assume every OS runs all 187
without platform preparation:

| Platform | Current boundary |
| --- | --- |
| Windows x64 | Full 187 path validated. Automatic minimal Docker uses WSL 2; Android SDK/JDK/image remain developer prerequisites. |
| Linux x64 | Backend/tooling CI is validated on Ubuntu 24.04. Automatic private Docker needs root or usable `sudo`; Flutter needs its OS libraries. Complete native 187 execution has not been validated on Linux. |
| macOS Intel | Node bootstrap is configured, but minimal Docker guest provisioning is not. An existing local Linux Docker engine and Flutter OS prerequisites are needed. Full 187 execution has not been validated. |
| macOS Apple Silicon | Node bootstrap is configured, but the Android selector requires x86_64 images and is not an ARM emulator workflow. No complete 187-case support claim. Use an approved x64 validation machine for native coverage. |
| Windows/Linux ARM | Automatic minimal Docker is x64-only; automatic Node assets are also limited by the runtime lock. An existing Node/engine does not establish native full-suite compatibility. |

For Linux, install Python 3.10+ with venv/pip, Git, and the OS libraries required
by pinned Flutter. The [manual Flutter installation guide](https://docs.flutter.dev/install/manual)
lists OS prerequisites; choose Flutter 3.29.3 rather than changing this project's
pin. An existing Docker engine avoids private-daemon sudo setup. For managed
Linux setup, the helper may request sudo; `sudo -v` beforehand can authorize it.

Example Bash commands for the supported backend/Flutter path, from repo root:

```bash
python3 --version
git --version
python3 scripts/test_vocle.py --source . --commit "$(git rev-parse HEAD)" --ci-checks
```

That selects 179 functional cases, not Android. Bash uses `$(...)`; PowerShell's
examples use `(...)`. If validating Android on another x64 platform, install a
working accelerated emulator, the required SDK/image and JDK, set absolute
`ANDROID_HOME`/`JAVA_HOME`, and use `--android --ci-checks --commit` with the full
profile. Treat the first native run as platform validation and inspect errors;
do not infer parity from the Windows result. This workflow makes no iOS or real
carrier/camera/FCM delivery certification claim.

## 14. First-run checklist and reference links

- [ ] I am using a suitable platform, with virtualization, RAM and disk space.
- [ ] Python 3.10+ and Git work in this terminal.
- [ ] My checkout contains the current launcher and I am at the repository root.
- [ ] The Android SDK, image, licenses and JDK are ready for the 187-case run.
- [ ] WSL 2/engine setup is permitted; I have restarted if requested.
- [ ] Other Android devices/emulators are disconnected; one test invocation will run.
- [ ] My intended app changes are committed if I need Android coverage.
- [ ] I understand whether I selected 187 functional, additional security or live provider testing.
- [ ] I have approved test cloud access only if I selected Cloudinary.
- [ ] I will wait for cleanup, then check actual execution and open the root dashboard.

Repository references:

- [Current local workflow mapping](../docs/VOCLE_LOCAL_WORKFLOW_PARITY.md)
- [Recorded validation results](../docs/VOCLE_LOCAL_VALIDATION_RESULTS.md)
- [Native runner scope and limitations](../docs/VOCLE_FUNCTIONAL_REGRESSION_DEVICE_RUNNER.md)
- [Functional catalog](../docs/VOCLE_FUNCTIONAL_REGRESSION_TEST_CATALOG.md)
- [Developer launcher](../scripts/test_vocle.py)
- [Runtime versions/checksums](../scripts/vocle-runtime-lock.json)

Official setup references were checked on 18 October 2026: Microsoft WSL,
Android Emulator acceleration, sdkmanager and Flutter manual installation linked
above. Storage/time/hardware budgets in this guide are project planning estimates;
the recorded 28-minute run and retained evidence size are observations from one
machine. SDK availability, downloads and host policy can change.
