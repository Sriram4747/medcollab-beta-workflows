# Vocle local testing: developer user guide

Updated: 18 October 2026. Applies to `scripts/test_vocle.py` and
`scripts/test_vocle_cloudinary.py` in this repository.

**First time here?** Follow sections 3, 4, 5 and 6 in order. Section 4 is the
one-time machine setup. Section 6 is the command you repeat when testing a new
commit. Section 9 shows how to open the dashboard. You can leave sections 7 and 8
until you need extra security or live Cloudinary tests.

This walkthrough assumes you are new to the tools. Each setup step says where
to download, what to select and what a successful check looks like. If you already
have a tool, run its check first and reuse it when it meets the listed version.
Installing the launcher does **not** install every machine prerequisite.

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

### Start here: who installs what?

For the **Windows x64 full 187-case run**, use this table before downloading
anything. "Developer" means you or your IT team complete that setup once.

| Item | Who prepares it? | Version or selection | Instructions |
| --- | --- | --- | --- |
| Windows and hardware virtualization | Developer/IT | Windows 11 x64 is the validated path; firmware virtualization enabled | [4.2 A](#a-check-windows-and-hardware-virtualization) |
| Python with venv/pip | Developer | Launcher requires 3.10+; use maintained **64-bit Python 3.13.x** for a fresh install | [4.1 A](#a-install-and-check-python) |
| Git | Developer | Current stable Git for Windows x64; no exact Git pin | [4.1 B](#b-install-and-check-git) |
| Windows Hypervisor Platform | Developer/IT | Windows optional feature for emulator acceleration | [4.2 B](#b-enable-the-windows-features-for-virtualization) |
| WSL 2 platform | Script can request setup, or developer/IT installs beforehand | WSL **2**, not WSL 1; elevation/restart may be needed | [4.2 C](#c-prepare-wsl-2-or-let-the-script-request-it) |
| Android Studio / SDK tools | Developer | Stable Windows x64 Studio as the SDK installer; required SDK versions below | [4.3 A–C](#a-install-android-studio-and-find-the-sdk-folder) |
| JDK | Developer | **JDK 21**; reuse Studio's bundled JDK if it reports 21 | [4.3 D](#d-check-java-and-configure-the-sdkjdk-paths) |
| Android system image and SDK licenses | Developer | Google Play **x86_64**, Android **36.1**; review licenses | [4.3 C and E](#c-install-the-exact-android-packages) |
| Python venv, Node/npm, Flutter/Dart, packages, minimal Docker, MongoDB, Gradle, Gitleaks, temporary AVD | Script | Reuses compatible tools or prepares the versions in the runtime lock | [4.4](#44-what-the-script-prepares-automatically) |

You do **not** need to install Docker Desktop, a personal Ubuntu distribution,
MongoDB, Node.js, Flutter, Dart or Gradle just to follow this Windows walkthrough.
You also do not need to create a Python venv or Android virtual device yourself.
The script needs the Android **image** installed before it can create the device.

### How to use the commands in this guide

1. Press the Windows key, type **PowerShell**, and open **Windows PowerShell** or
   a Windows Terminal **PowerShell** tab. Use a normal window unless a step says
   **administrator**.
2. Copy only the lines inside a `powershell` code block. Do not copy a displayed
   `PS C:\...>` prompt. Paste the block and press Enter.
3. Run the blocks in order. If a check fails, resolve it before continuing.
4. `$env:...` reads or sets a Windows environment variable for this terminal.
   `Test-Path` prints `True` when a file exists. The `&` at the start of a line
   runs an executable whose path is in quotes.
5. When a step says to reopen the terminal, close the whole terminal window. If
   you use the Android Studio terminal, reopen the IDE too so it reads new settings.

### 4.1 Python and Git: install once

#### A. Install and check Python

**Already installed?** In normal PowerShell, run:

```powershell
python --version
python -c "import sys, struct, venv, ensurepip; print(sys.executable); print('Python bits:', struct.calcsize('P') * 8)"
python -m pip --version
```

Continue if you see Python **3.10 or later**, `Python bits: 64`, an executable
path and a pip version without an import error. The reference full run used
Python 3.12.0. That is a historical observation, not a request to install an old
unpatched release. For a fresh setup, use a maintained **3.13.x** build, which has
official Windows installers (3.13.16 when this guide was updated). Python 3.12's
newer security releases are source-only, so an old 3.12 installer is not the
recommended fresh-install route. See the [official 3.13 download](https://www.python.org/downloads/release/python-31316/)
and [Python's release notice](https://blog.python.org/2026/10/python-31022-31117/).
The launcher accepts 3.10+, but only the recorded 3.12 environment has had the
complete local 187-case validation; this is not a full-suite certification of
every newer Python version.

**Not installed? Follow these steps:**

1. Open the [official Python Windows downloads page](https://www.python.org/downloads/windows/).
2. Choose **Python install manager**, then its **Installer (MSIX)**. Open the
   downloaded file and select **Install**. Use the current manager release;
   the manager version is separate from the Python 3.13 runtime version.
3. Close and reopen normal PowerShell. Install the maintained 3.13 runtime:

   ```powershell
   pymanager install 3.13
   py -V:3.13 --version
   py -V:3.13 -c "import struct, venv, ensurepip; print('Python bits:', struct.calcsize('P') * 8)"
   py -V:3.13 -m pip --version
   ```

4. Expect `Python 3.13.x`, `Python bits: 64` and a pip version. The `x` represents
   the patch installed by the manager; do not type `.x` in a command.
5. Run `python --version` as well. All later examples use `python`. If it selects
   a different installation or opens the Store, use **`py -V:3.13` in place of
   `python`** in those examples. Section 6 includes the complete alternate command.

If MSIX installation is blocked, ask IT to install the official manager using
its MSI deployment option, or supply an approved maintained 64-bit Python with
venv/pip. If `pymanager` is missing after reopening, check **Start > Manage app
execution aliases** for Python's manager aliases and ask IT if they are locked.
An older `py` launcher can coexist with the manager; `pymanager install 3.13`
avoids confusing the old launcher with the manager's installer command.
See [Python's Windows installation and troubleshooting guide](https://docs.python.org/3/using/windows.html).

Do not download the **embeddable ZIP**, a source archive or a preview/free-threaded
build for this walkthrough. If using a traditional Python `.exe` installer
provided by IT, enable **Add python.exe to PATH** and include **pip**. Do not
install test packages into global Python; the Vocle launcher supplies its own venv.

**Done when:** one of `python` or `py -V:3.13` passes the version, 64-bit and pip
checks above. Remember which command works on your machine.

#### B. Install and check Git

1. Run `git --version` in normal PowerShell. If it prints `git version 2...`,
   you already have Git. This launcher has no exact Git version pin. The
   reference machine used `2.53.0.windows.2`.
2. If missing, open [Git for Windows](https://gitforwindows.org/) and choose the
   current stable **x64 installer**. Use the installer, not a source-code ZIP.
3. Open the downloaded `.exe`. Follow the installer. On its PATH selection page,
   choose **Git from the command line and also from 3rd-party software** so
   PowerShell and Python can find it. Keep your team's approved choices for
   editor, credential manager and other settings; there are no extra Vocle
   requirements on those pages.
4. Close and reopen PowerShell, then run:

   ```powershell
   git --version
   Get-Command git
   ```

**Done when:** a Git version and the path to `git.exe` appear. If Git works only
in Git Bash, rerun the installer to enable its command-line PATH option. Tests
below use **PowerShell**.

### 4.2 WSL 2 and virtualization: install/enable once

There are three separate pieces here: hardware virtualization, Windows emulator
acceleration, and WSL 2 for the managed Docker runtime. A Python venv cannot supply
these OS capabilities.

#### A. Check Windows and hardware virtualization

1. Open **Settings > System > About**. Under **System type**, confirm an **x64-based
   processor** and 64-bit Windows. Use Windows 11 x64 for the validated full path.
   ARM Windows is not this workflow's complete 187-case path.
2. Press **Ctrl+Shift+Esc**, open **Performance > CPU**, and find **Virtualization**.
   Continue if it says **Enabled**.
3. If it says **Disabled**, save your work. Ask IT or follow your computer maker's
   instructions to enter BIOS/UEFI and enable Intel **VT-x / Virtualization
   Technology** or AMD **SVM / AMD-V**. Firmware screens differ, so there is no
   universal key/menu to copy. Save the firmware setting, boot Windows, then
   check Task Manager again. The launcher cannot make this firmware change.

If your work computer is itself a VM, ask IT whether this workload is supported
on that VM. This guide validates a suitable x64 Windows host, not nested VMs.

#### B. Enable the Windows features for virtualization

1. Open Start and search for **Turn Windows features on or off**. Open it and
   approve the Windows administrator prompt, or ask IT to do this step.
2. Select **Windows Hypervisor Platform** for Android emulator acceleration.
3. Select **Virtual Machine Platform** for WSL 2. If already selected, leave it on.
4. Click **OK** and let Windows finish. Save your work and select **Restart now**
   if requested. A terminal restart is not a Windows restart.
5. After signing in, return to this guide. The emulator check in section 4.3 F
   confirms whether acceleration actually works.

Use [Android's official WHPX instructions](https://developer.android.com/studio/run/emulator-acceleration#vm-windows-whpx)
if the check fails. The walkthrough uses Windows Hypervisor Platform, so you do
not need to add an old Intel HAXM installer or disable Windows security features.

#### C. Prepare WSL 2 or let the script request it

**Option 1: let the launcher prepare it.** No separate WSL download is needed.
When you run section 6, the fixed setup helper can request administrator approval
to install the WSL platform. Approve only if permitted by your team. If it prints
`RESTART_REQUIRED`, note the report path, restart Windows, reopen PowerShell,
return to your repository folder, and run the **same test command** again. That
setup-only attempt has not executed the 187 application cases.

**Option 2: install it now so the first test run has less setup to do.** Use this
if you or IT want to finish the OS preparation before testing:

1. Open Start, search **PowerShell**, right-click it and select **Run as
   administrator**. Approve the Windows prompt.
2. Run this exact command:

   ```powershell
   wsl --install --no-distribution --web-download
   ```

3. Let installation finish. Save your work and restart Windows if requested.
4. Open a **normal** PowerShell window and check:

   ```powershell
   wsl --version
   wsl --status
   wsl --list --verbose
   ```

5. An installed WSL version with kernel details is expected. On an otherwise
   unused machine, **no installed distributions** is fine: the test launcher
   imports its own guest. If `wsl --status` says the default version is 1, run
   `wsl --set-default-version 2` and check again. This changes the default for
   new distributions, not the version of an existing personal distribution.

If Windows says the kernel/platform needs an update, run `wsl --update` in the
administrator window, restart if requested and repeat the checks. If `--version`
is unrecognized or WSL reports that virtualization cannot start, use the
[Microsoft installation](https://learn.microsoft.com/en-us/windows/wsl/install)
and [troubleshooting](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)
instructions with IT. A status command alone does not prove a test guest will
boot; the launcher checks that during preparation.

You do not need to download Docker Desktop or open a Linux terminal. The runner
creates its own disposable `Vocle-Test-...` guest. WSL's Windows platform stays
installed after the test guest is removed. A working existing local Linux Docker
engine is another supported path, explained in section 7.

### 4.3 Android Studio, SDK and JDK: install once for all 187 cases

The **SDK** is Android's build/device tool folder. A **system image** is the
Android OS the emulator boots. An **AVD** is a virtual device created from an
image. Install the SDK and image here; the script creates and removes the AVD.
The **JDK** supplies Java for Android build tools.

#### A. Install Android Studio and find the SDK folder

1. Open the [official Android Studio download page](https://developer.android.com/studio).
2. Download the **stable Windows 64-bit `.exe` installer**. Studio itself has no
   launcher version pin. The SDK package versions and JDK major below are the
   versions to check. You do not need a Canary/preview Studio build.
3. Open the downloaded installer. Keep Android Studio selected, finish installation,
   then launch it. On a new installation, complete its initial setup wizard and
   let the recommended SDK downloads finish. A Google account sign-in is not
   required for this local test command.
4. At the welcome screen select **More Actions > SDK Manager**. If a project is
   already open, use **Tools > SDK Manager** instead.
5. At the top, copy the **Android SDK Location** into a note. The usual location
   is `C:\Users\YOUR_WINDOWS_NAME\AppData\Local\Android\Sdk`. Your displayed
   location is the one to use, even if it is on another drive.

An existing installation is fine: start at step 4 and check its packages. The
launcher does not need a Flutter IDE plugin or an Android project opened in Studio.
See the [official Studio installation guide](https://developer.android.com/studio/install)
if the installer or setup wizard cannot finish.

#### B. Install the SDK tools through SDK Manager

1. In **SDK Manager**, select the **SDK Tools** tab.
2. Select **Android SDK Platform-Tools**, **Android Emulator**, and **Android SDK
   Command-line Tools (latest)**. These supply `adb`, `emulator`, `sdkmanager`
   and `avdmanager`. Use the current stable offered versions; the launcher does
   not pin their exact patch revisions.
3. Enable **Show Package Details**. Expand **Android SDK Build-Tools** and select
   **35.0.0**. Expand **NDK (Side by side)** and select **27.0.12077973**.
4. Click **Apply**, review the package list and any licenses, and finish the
   download. Leave any packages needed by other projects installed.

For orientation, the current validation machine has Emulator 36.5.10,
Platform-Tools 37.0.0 and Command-line Tools 20.0. These are observed tool
revisions, not extra pins or a reason to downgrade a working installation.

#### C. Install the exact Android packages

In SDK Manager's **SDK Platforms** tab, enable **Show Package Details**:

1. Expand the Android **API 35** entry and select **Android SDK Platform 35**.
2. Expand the Android **36.1** entry and select its **Google Play x86_64** system
   image. Make sure it is **Google Play** and **x86_64**. An ARM64 image, a plain
   Google APIs image or another Android API image does not reproduce this baseline.
3. Click **Apply**, review licenses, then wait for **Finish**.

The required package identifiers below are authoritative if the UI wording differs.
If the exact image is missing from the UI, install the command-line tools first,
configure Java/SDK paths in part D, then use part E's command to request it.

| Package | Exact SDK package identifier | Why we need it |
| --- | --- | --- |
| Platform-Tools | `platform-tools` | Device connection with `adb` |
| Emulator | `emulator` | Boots the temporary device |
| Command-line Tools | `cmdline-tools;latest` | SDK/AVD management commands |
| Compile platform | `platforms;android-35` | Current pinned Flutter app build default |
| Build tools | `build-tools;35.0.0` | Android build utilities |
| NDK | `ndk;27.0.12077973` | Explicit version in the app's build configuration |
| Test device image | `system-images;android-36.1;google_apis_playstore;x86_64` | Validated native behavior, including the document viewer used by media tests |

**API 35 for compilation and Android 36.1 for the test device are intentional.**
They serve different purposes. Do not change the app's SDK versions to match the
device image.

You do not need to create a device in Device Manager. If you have several x86_64
images, the current launcher selects the lexically last installed
`*/*/x86_64/package.xml` path, not a user-selected AVD. Part F prints the same
selection order so you can check before running. There is no image-selection
CLI flag. If the first image differs, use a dedicated SDK with the validated
packages or ask the maintainer to help; do not remove images other projects need.

#### D. Check Java and configure the SDK/JDK paths

Open **normal PowerShell**. Start with the usual installation paths:

```powershell
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
Test-Path "$env:ANDROID_HOME\platform-tools\adb.exe"
Test-Path "$env:JAVA_HOME\bin\java.exe"
& "$env:JAVA_HOME\bin\java.exe" -version
```

Both checks should print `True`, followed by Java version **21...** and a 64-bit
VM line. Java sometimes prints its version on the terminal's error stream; version
text by itself is not a failed check. Android Studio's JDK 21.0.10 was used on the
validation machine; use maintained JDK 21 patches rather than pinning that patch.

**If either path is wrong:** replace the right-hand quoted path with the actual
SDK location from part A or your actual JDK folder. `ANDROID_HOME` must be the
folder containing `platform-tools`, `emulator` and `cmdline-tools`. `JAVA_HOME`
must be the folder containing `bin\java.exe`, **not** the `bin` folder itself.
Keep quotes around paths containing spaces.

**If Studio has no JDK 21 or bundles another major:**

1. Open [Microsoft's official OpenJDK downloads](https://learn.microsoft.com/en-us/java/openjdk/download#openjdk-21).
2. Under **OpenJDK 21**, download the **Windows x64 ZIP** and its SHA-256 file.
   Choose the current 21.x patch. This is a JDK 21 fallback; the recorded full
   run used Studio's bundled JDK, not every vendor's JDK build.
3. In PowerShell run `Get-FileHash 'C:\path\to\the-downloaded-jdk.zip' -Algorithm SHA256`,
   replacing the example with your ZIP's actual path. Compare the hash to the
   download page's SHA-256 file before extracting.
4. In File Explorer, right-click the ZIP, select **Extract All**, and extract to
   a short writable folder, for example `C:\Users\YOUR_WINDOWS_NAME\tools\jdk21`.
5. Open that folder. There may be another JDK directory inside it. Find the
   directory that directly contains `bin` and `lib`, then copy its address.
6. Set `$env:JAVA_HOME = 'YOUR_ACTUAL_JDK_DIRECTORY'` using that address, then
   repeat the `Test-Path` and Java version checks above. Do not type the placeholder.

These `$env:` assignments affect the **current terminal only**. Once both paths
are correct, save them for your Windows user so future runs find them:

```powershell
[Environment]::SetEnvironmentVariable('ANDROID_HOME', $env:ANDROID_HOME, 'User')
[Environment]::SetEnvironmentVariable('JAVA_HOME', $env:JAVA_HOME, 'User')
```

If you already use `ANDROID_SDK_ROOT`, it must point to the **same** SDK. Correct
that existing setting as well:

```powershell
if ($env:ANDROID_SDK_ROOT) {
    $env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
    [Environment]::SetEnvironmentVariable('ANDROID_SDK_ROOT', $env:ANDROID_HOME, 'User')
}
```

Close and reopen PowerShell (and the IDE if using its terminal), then check:

```powershell
$env:ANDROID_HOME
$env:JAVA_HOME
& "$env:JAVA_HOME\bin\java.exe" -version
```

Expect your saved SDK/JDK directories and Java **21** again. If a company-managed
system variable overrides your user setting, ask IT to align it. There is no need
to add each Android tool directory to PATH: the commands below use full paths.

#### E. Install missing packages and review SDK licenses

The following is an **installation** command for the permanent SDK you selected,
not a test invocation. Run it in normal PowerShell after part D. It is also useful
if the SDK Manager UI did not expose the exact package selection:

```powershell
$vocleSdkManager = "$env:ANDROID_HOME\cmdline-tools\latest\bin\sdkmanager.bat"
Test-Path $vocleSdkManager
```

The path check must be `True`. If you have a version-numbered command-line-tools
folder instead of `latest`, run `Get-ChildItem "$env:ANDROID_HOME\cmdline-tools"`,
then replace `latest` in the assignment with that actual folder name. The launcher
accepts both layouts. If no such folder exists, return to part B and install
Android SDK Command-line Tools.

Once the path check is `True`, install the packages:

```powershell
& $vocleSdkManager --install 'platform-tools' 'emulator' 'platforms;android-35' 'build-tools;35.0.0' 'ndk;27.0.12077973' 'system-images;android-36.1;google_apis_playstore;x86_64'
```

Wait for package installation to finish. If it reports an unknown package, check
the exact spelling, SDK Manager's available packages and network access. Do not
silently substitute an ARM/other image. Review any requested SDK licenses yourself.
Then check remaining licenses:

```powershell
& $vocleSdkManager --licenses
```

Read each agreement and enter `y` followed by Enter **only if you accept it**.
Continue once it reports that all required SDK package licenses are accepted.
The launcher does not accept licenses on your behalf. See the
[official sdkmanager reference](https://developer.android.com/tools/sdkmanager)
for package/license commands.

Gradle may request other licensed SDK components for the app's plugins. Those go
into this existing SDK and remain after cleanup. If a build names another missing
component, install the exact version from its diagnostic through SDK Manager,
then rerun. Do not edit application SDK pins just to suppress a setup error.

#### F. Verify the Android installation before testing

In the **same normal PowerShell terminal**, run:

```powershell
Test-Path "$env:ANDROID_HOME\platform-tools\adb.exe"
Test-Path "$env:ANDROID_HOME\emulator\emulator.exe"
Get-ChildItem "$env:ANDROID_HOME\cmdline-tools\*\bin\avdmanager.bat"
Test-Path "$env:ANDROID_HOME\platforms\android-35\android.jar"
Test-Path "$env:ANDROID_HOME\build-tools\35.0.0\aapt2.exe"
Test-Path "$env:ANDROID_HOME\ndk\27.0.12077973\source.properties"
Test-Path "$env:ANDROID_HOME\system-images\android-36.1\google_apis_playstore\x86_64\package.xml"
& "$env:JAVA_HOME\bin\java.exe" -version
& "$env:ANDROID_HOME\emulator\emulator.exe" -accel-check
```

Every `Test-Path` should be `True`, the command-line-tools listing should include
`avdmanager.bat`, and Java should report **21**. The acceleration check should
report a usable hypervisor, such as **WHPX is installed and usable**, and exit
successfully. If it cannot use acceleration, return to section 4.2 before starting
a long test run.

Check which image the launcher will choose. This lists matching paths in the
same descending order used by the Python launcher:

```powershell
python -c "import os; from pathlib import Path; sdk=Path(os.environ['ANDROID_HOME']); images=sorted(sdk.glob('system-images/*/*/x86_64/package.xml'), reverse=True); print('\n'.join(str(p.relative_to(sdk)) for p in images) or 'NO X86_64 IMAGE INSTALLED')"
```

The **first** line should be
`system-images\android-36.1\google_apis_playstore\x86_64\package.xml`.
If your Python command is `py -V:3.13`, use that at the beginning instead.

Finally, close any running Android emulators and disconnect physical Android
devices, including devices connected through wireless debugging. Check:

```powershell
& "$env:ANDROID_HOME\platform-tools\adb.exe" devices
```

Expected: `List of devices attached` with **no device rows below it**. An `offline`
or `unauthorized` row still needs attention. Close/disconnect it before continuing.
The test script creates its own emulator; starting one manually blocks isolation.

**Done when:** paths exist, Java is 21, licenses are accepted, the selected image
matches, acceleration is usable and the device list is empty.

### 4.4 What the script prepares automatically

| Component | Behavior |
| --- | --- |
| Python venv | Creates and deletes it; `--ci-checks` installs its needed Python packages there |
| Node/npm | Reuses a working Node >=22 with npm, or downloads locked Node 22.20.0 on a supported platform |
| Flutter | Reuses exact Flutter 3.29.3 if found or explicitly provided; otherwise installs a disposable pinned SDK |
| Dart/Flutter packages | Fetches the app's dependencies using the existing runner and checks dependency integrity |
| Backend/sanity packages | Uses locked dependency installation in the isolated test setup |
| Minimal Docker/containerd | Reuses a running local Linux Docker engine, or provisions the pinned Docker 29.9.1 bundle in a private x64 Windows/Linux runtime |
| MongoDB | Prepares test-owned Mongo binaries/databases; no MongoDB service installation or Atlas account needed |
| Gradle | Prepares verified Gradle 8.10.2 in the disposable cache for Android |
| Gitleaks | Prepares checksum-verified 8.30.1 when `--ci-checks` is selected |
| Android AVD | Creates/boots a temporary 4-core/4-GB AVD from the installed image, then removes it |

Runtime pins/checksums are in `scripts/vocle-runtime-lock.json`. Do not upgrade
Flutter or dependency lockfiles just to make a failed case disappear.

**You supply:** Python/Git, the installed Android SDK/JDK/image, accepted licenses,
and usable OS virtualization. **The launcher supplies:** the temporary test
workspace and the runtime/packages in the table. Its automatic setup does not
replace the one-time machine setup above. Installed prerequisites remain on your
computer; temporary resources are cleaned after each run.

### 4.5 Ready to continue?

- [ ] I can run Python 64-bit with venv/pip, and Git, in normal PowerShell.
- [ ] My Windows host has hardware virtualization enabled and emulator acceleration works.
- [ ] WSL 2 is ready, or I have permission for the launcher's setup and restart.
- [ ] The required Android packages/image are installed and licenses accepted.
- [ ] `ANDROID_HOME` and `JAVA_HOME` point to my actual SDK and JDK 21 directories.
- [ ] After reopening the terminal, the saved paths still work.
- [ ] Other Android emulators/devices are disconnected and I have enough free space.

If all of these are true, continue to section 5. You do not need to run `pip
install`, `npm install`, `flutter pub get` or start Docker/MongoDB manually for
the managed path.

## 5. Get the repository and check your setup

### Fresh checkout

Open a **normal Windows PowerShell terminal**, not an Android device shell, Python
interactive prompt or WSL shell. The IDE terminal is fine if it is PowerShell.
Use a short local path that you can write to. Avoid cloud-synced/network folders,
commas and shell characters such as `&`, `%`, `^` or `!` in tool/checkout paths.

1. Open normal PowerShell. You do not need an administrator terminal to clone
   the repository or run tests.
2. Run the block below. It creates a `source` folder inside your Windows user
   folder, downloads the repository, then enters its root folder:

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\source" -Force | Out-Null
Set-Location "$env:USERPROFILE\source"
git clone --branch master https://github.com/Sriram4747/medcollab-beta-workflows.git
Set-Location .\medcollab-beta-workflows
```

3. Wait for cloning to finish before using `Set-Location`. If Git asks you to
   authenticate, use your team's GitHub sign-in method. A `Repository not found`
   or access-denied error needs the correct repository access, not Python packages.
4. Your prompt should now end in `\source\medcollab-beta-workflows>`. Continue
   with **Check the checkout** below. You can keep this PowerShell window open.

If the clone says the destination already exists, do not clone over it. Use the
existing-checkout steps below, or choose a different empty parent folder.

Use your team's approved source checkout when different, while retaining the
current testing scripts. This repository's `origin` is the experimental testing
fork. `upstream` is read-only; do not push test tooling or findings there.

### Existing checkout

Change into the **repository root**, the folder containing `scripts`,
`medcollab-app`, `medcollab-backend` and `.git`. For example:

```powershell
Set-Location 'C:\path\to\medcollab-beta-workflows'
```

Replace the quoted example with your actual checkout path. An easy way to find
it is to open the repository in File Explorer, click the address bar and copy
the full path. Keep the quotes when pasting the path into `Set-Location`.
Do not stop in the `scripts` or `medcollab-app` subfolder.

### Check the checkout

Everyone, including developers using a fresh clone, should run:

```powershell
Get-Location
git status --short
git remote -v
git rev-parse --show-toplevel
Test-Path .\scripts\test_vocle.py
python .\scripts\test_vocle.py --help
```

If you selected Python through `py -V:3.13`, replace `python` on the last line
with `py -V:3.13`.

Expected checks:

| Check | What you should see |
| --- | --- |
| `Get-Location` / `git rev-parse --show-toplevel` | Both identify your repository root |
| `git status --short` | Empty on a clean clone; file rows mean local changes to review before choosing a source commit |
| `git remote -v` | `origin` points to the approved fork, not an unintended repository |
| `Test-Path` | `True` |
| `--help` | The launcher's options, including `--android`, `--ci-checks` and `--commit`; this does not run tests |

For an existing **clean `master` checkout** of this fork, you can get the newest
guide/tooling with:

```powershell
git branch --show-current
git status --short
git pull --ff-only origin master
```

Only run the pull after confirming you are on `master` and status is empty.
If you are on a feature branch or have local edits, use your team's normal
update/merge process instead. Do not discard work with reset/clean just to update
this guide. A pull conflict or authentication problem needs Git help before testing.

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

### Step 1: choose which code to test

For all 187 cases, the app must be in a **local Git commit**. Review your changes
and create a commit through your normal workflow if you want those changes tested.
A local commit does not require a push. The launcher does not create commits.

Run:

```powershell
git status --short
git log -1 --oneline
git rev-parse HEAD
```

If you just cloned the repository and made no edits, its existing latest commit
is enough. You do not need to create an empty commit. If you changed app files,
review and commit the intended changes using your IDE's Git/Commit window or your
normal Git commands first. Select only the files intended for that change.
`git log -1 --oneline` should then show that commit; `git rev-parse HEAD` prints
its full 40-character ID. `HEAD` means your currently checked-out commit.

If you need the command-line steps to create that local commit:

1. Run `git diff --stat` to see changed files, then `git diff` to review unstaged
   content. If your IDE already staged files, review those with `git diff --cached`.
2. Stage each intended file with `git add -- 'relative/path/to/your-file'`.
   Replace that quoted example with an actual path shown by Git, relative to the
   repo root. Repeat for each intended file. Leave reports and private inputs out.
3. Run `git diff --cached --stat` and `git diff --cached`. Check that this is
   exactly the change you want to test.
4. Run `git commit -m 'Describe the change being tested'`, replacing the message
   with your description. This saves locally; it does not push to GitHub.
5. If Git asks for your identity, run `git config user.name 'YOUR NAME'` and
   `git config user.email 'YOUR APPROVED COMMIT EMAIL'` with your real approved
   values, then retry the commit. These commands configure this repository.
6. Repeat `git status --short` and `git log -1 --oneline` to confirm the result.
   If commit hooks fail, read their diagnostic and fix it before retrying.

`--commit (git rev-parse HEAD)` tests committed application code. Uncommitted app
edits are excluded. The harness separately fingerprints the test definitions it
uses; keep test/tooling changes committed for a reviewable shared run. Do not edit
test definitions or dependency files while a run is active.

### Step 2: run this in the repository root

Keep the normal PowerShell window at the root confirmed in section 5. Plug in
power, prevent sleep, close other emulators and run **one** command below.

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks
```

If section 4's Python check worked through `py -V:3.13`, use this equivalent
command **instead**:

```powershell
py -V:3.13 .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks
```

| Part of the command | Meaning |
| --- | --- |
| `python` (or `py -V:3.13`) | Starts the Python you checked during setup |
| `.\scripts\test_vocle.py` | Runs the launcher from this checkout |
| `--source .` | Uses this repository; the dot means the current directory |
| `--commit (git rev-parse HEAD)` | PowerShell supplies the exact current commit ID; you do not type a SHA placeholder |
| `--android` | Includes the eight native cases, making the functional scope 187 instead of 179 |
| `--ci-checks` | Adds existing tooling, analysis and secret-scanning checks |

Nothing else needs to be started: no backend server, Mongo service, emulator,
manual venv or production accounts. Allow setup downloads and any first-time
Windows platform approval. Ordinary 187-case testing does not prompt for provider
keys. After a required restart, reopen PowerShell, use `Set-Location` to return
to this repository, confirm your saved SDK/JDK paths, and repeat this command.

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

As soon as the command finishes and the PowerShell prompt returns, save its exit
code before running another native command:

```powershell
$vocleExitCode = $LASTEXITCODE
Write-Output "Vocle exit code: $vocleExitCode"
```

`0` means the selected session passed. `1` means a test/setup/coverage issue needs
review. `3` means restart requested. A nonzero code is not automatically an
installation problem: the app can have real failures after successful setup.

### Step 4: open this run's dashboard

Use the **new report directory printed by your invocation**. After a finished
full-scope invocation, this convenience command opens its dashboard if present:

```powershell
if (Test-Path -LiteralPath .\test-results\LATEST_FULL_RUN.txt) {
    $vocleLatest = Get-Content .\test-results\LATEST_FULL_RUN.txt
    $vocleLatest
    if ($vocleLatest.Count -ge 2 -and (Test-Path -LiteralPath $vocleLatest[1])) {
        Start-Process -FilePath $vocleLatest[1]
    } else {
        Write-Output 'No dashboard yet. Open the printed report folder and read setup.log and local-session.json.'
    }
} else {
    Write-Output 'No latest-run pointer yet. Open the report folder printed by the launcher.'
}
```

The first printed line is the folder, the second is the dashboard, and the third
is the summary. Confirm it matches the report path from the command you just ran.
If the latest-pointer file does not exist, or the process stopped before updating
it, open the report folder printed by the launcher in File Explorer instead.
An older dashboard is not evidence for the new attempt.

For a completed functional run, check **187 executed**, then review PASS, FAIL
and NEEDS_DECISION separately. See section 9 for all statuses, raw evidence and
the exact folder structure. Keep the report even if the gate is red.

### Next time you test a new change

You do not repeat the installers above. Open normal PowerShell, enter the repo
root, confirm your committed changes and that no devices are connected, then
repeat step 2. The launcher creates a fresh temporary session and a new result
folder each time. It can download disposable tools/packages again, so internet
and free temporary disk space are still needed.

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

Official setup references were checked on 18 October 2026: Python's Windows
installer/runtime guidance, Git for Windows, Microsoft WSL/OpenJDK, Android Studio,
Emulator acceleration, sdkmanager and Flutter manual installation linked above.
Storage/time/hardware budgets in this guide are project planning estimates;
the recorded 28-minute run and retained evidence size are observations from one
machine. SDK availability, downloads and host policy can change.
