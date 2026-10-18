# Vocle user guides

- [Developer guide: install prerequisites, run local tests and read the reports](LOCAL_TESTING_GUIDE.md)

Start with that guide before your first run. It explains the 187 functional
cases, additional security suites, disk space, private inputs and cleanup.

## First-time setup on Windows x64

Follow these in order:

1. [Check hardware, disk space, time and permissions](LOCAL_TESTING_GUIDE.md#3-before-you-start-hardware-storage-time-and-inputs).
2. [See who installs what, then install the prerequisites](LOCAL_TESTING_GUIDE.md#4-install-the-prerequisites-on-windows).
   Includes official download links, versions, installer/SDK selections,
   virtualization and WSL, saved SDK/JDK paths, and expected check results.
3. [Get the repository and check the correct folder](LOCAL_TESTING_GUIDE.md#5-get-the-repository-and-check-your-setup).
4. [Choose a commit, run all 187 cases and open the dashboard](LOCAL_TESTING_GUIDE.md#6-run-all-187-functional-cases).

## After the first run

- [Repeat a run after a code change](LOCAL_TESTING_GUIDE.md#next-time-you-test-a-new-change).
- [Understand results and where they are stored](LOCAL_TESTING_GUIDE.md#9-find-and-read-your-results).
- [Troubleshoot a setup or execution error](LOCAL_TESTING_GUIDE.md#11-troubleshooting).
- [Add isolated security tests](LOCAL_TESTING_GUIDE.md#7-other-useful-commands).
- [Add real Cloudinary tests](LOCAL_TESTING_GUIDE.md#8-run-the-real-cloudinary-tests).

Python/Git and the Android SDK/JDK/image are developer prerequisites. The script
prepares the disposable venv, runtime tools and test packages. WSL platform setup
can require administrator approval and a Windows restart. The guide explains
each of these separately so you can check your machine before starting a long run.
