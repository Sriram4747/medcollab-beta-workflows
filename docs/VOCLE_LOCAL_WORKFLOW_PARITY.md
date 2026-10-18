# Local execution of the existing GitHub suites

## Current report location

New runs are stored under repository-root `test-results/`, separated by scope:
`full-187/<UTC timestamp>-<id>/`, `functional-179/<timestamp>-<id>/`, `tooling/`,
`security/` or `cloudinary/`. A tooling run cannot replace the full-run location.
`test-results/LATEST_FULL_RUN.txt` points to the latest 187-case invocation.

Each full run has its own top-level `vocle-regression-dashboard.html` containing
only the 187 functional catalog IDs, `functional-summary.json` with actual
execution counts, QA findings, README and session/cleanup details. All supporting
backend, Flutter, Android and optional security output is under the same run's
`evidence/` directory. Android writes directly into that folder; it does not
create a second native report elsewhere. The earlier output locations below
describe historical validation and are not the default for new runs.

The functional catalog contains **187 unique cases: 147 backend, 32 Flutter and
8 Android**. The retained 48 sanity assertions are included in the backend scope.
Security suites and tooling checks have their own counts; they are additional to
the 187. Repeated security catalog IDs across suites retain their original
`catalogId` and use a suite prefix only to distinguish execution records.

## One command for a committed revision

Run the 187 functional cases and CI tooling checks in the testing fork's
repository root, in PowerShell:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks
```

To include the additional isolated security suites as well:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --all
```

`--all` selects the existing Android, isolated security and CI tooling checks.
To also include the approved live Cloudinary suite in the same report, use:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --all --cloudinary --test-cloud YOUR_TEST_CLOUD
```

This prompts privately for provider credentials before running the other lanes.
Cloudinary remains an explicit selection because it uploads synthetic assets to
the approved external test account. Its measured source, definitions, complete
catalog and independent cleanup must validate before evidence can enter the report.

It provisions a private Docker guest/engine, prepares pinned Flutter and package
caches, creates a fresh Android AVD using the installed SDK/system image, starts
it headlessly, invokes the original runners and tears down owned resources. The
Android SDK/system image, Android Studio JDK and existing user AVD remain installed.
No existing user AVD data or snapshots are loaded. Other emulators/physical devices
must be disconnected because the existing runner requires exactly one test device.

The Android SDK must include platform-tools, emulator, command-line tools and an
x86_64 system image. These are installed on the audited developer machine. Missing
SDK/JDK components are reported explicitly; this launcher does not install Android
Studio, accept new SDK licenses or claim camera/FCM/iOS hardware coverage.

The explicit commit selects the same immutable source kind as GitHub. Local
uncommitted application edits are excluded from this command. To test those edits,
run the default source snapshot with the existing security suites:

```powershell
python .\scripts\test_vocle.py --source . --security --ci-checks
```

This runs 179 backend/Flutter catalog cases and records the eight Android cases as
unexecuted. The existing native runner accepts committed archives only. Do not
describe a device result from HEAD as validation of different uncommitted bytes.

## Workflow mapping

| Existing workflow | Local execution reused | Requirement / difference |
| --- | --- | --- |
| Functional regression | `run-backend.mjs`, Flutter catalog/retained tests, catalog and CI/device contracts | All 147 B and 32 F; `--all` adds the original eight-case Android runner |
| Sanity | Original 48-case runner through the existing retained-sanity adapter | Included in backend coverage; not counted a second time |
| Media security | Existing manifest/check/self-test and `security-media/run.js` | Network-none container with synthetic data |
| Data security | Existing manifest/check/self-test and `security-data/run.js` | Same isolation; original observations preserved |
| Backend environment/discovery | Original fixtures, fixture verification, auth smoke, 691-case discovery and coverage report | Started against disposable Express/Mongo; no production credentials |
| Real Cloudinary security | Existing manifest/check/self-test/transport test; explicit local provider launcher below | 34 live cases require the user's isolated test cloud and hidden credential entry |
| Security environment | Existing `pytest`, `requests`, `httpx` package import check | Packages installed in the disposable venv; actual backend Docker execution supplies the runtime check |
| Developer QA integration | Original workflow/process, Python lifecycle/bootstrap, reporting and adapter contracts | `--ci-checks`, included by `--all` |
| Secret Scan | Official Gitleaks 8.30.1, pinned archive checksum, redacted full Git history scan | Local findings retain a failing gate; GitHub action permissions/artifact operations are hosted concerns |
| Visual QA reporting | Existing offline reporting generator, JSON/Markdown/JUnit/ownership reports | Local dashboard and `--previous` comparison; GitHub artifact history remains hosted |

Linux backend dependencies on Windows are copied into the owned WSL Linux
filesystem. Output is retained on Windows. Original assertions still use
`--network none`, read-only sources, the existing provider guard and unchanged
startup deadlines. Windows tools keep `PATHEXT` so Flutter can resolve executables.
Docker arguments are passed through native Python rather than a batch shell.
Mongo restart/persistence data uses a private Linux disk nested under the evidence
mount. It is removed with the private guest. Gradle 8.10.2 is verified by SHA256
and prepared in the disposable wrapper cache before the Android build.

## Real Cloudinary tests

Run this separately for the approved isolated test cloud:

```powershell
python .\scripts\test_vocle_cloudinary.py --test-cloud YOUR_TEST_CLOUD --commit (git rev-parse HEAD)
```

The script prompts for the API key and API secret with hidden input in your own
terminal. Do not put them in chat, command arguments or credential files. It
installs the locked backend packages without credentials, then passes the entered
credentials only to the existing guarded provider processes. Only synthetic
assets are uploaded; the original broker deletes and verifies its exact recorded
resources. Independent cleanup and artifact hygiene run even when tests fail.

The explicit local guard mode records local source/run identity and refuses any
GitHub environment identity. The existing hosted repository/ref/event/workflow
restrictions still apply in hosted mode. The provider assertions, network
allowlist, manifests and resource boundaries are reused.

Standalone reports are under `test-results/cloudinary/<UTC timestamp>-<id>/`.
When selected through the main launcher, they stay inside that invocation's
folder. If cleanup is
unproven, retry the recorded resource journal with the same cloud and source:

```powershell
python .\scripts\test_vocle_cloudinary.py --test-cloud YOUR_TEST_CLOUD --commit EXACT_SOURCE_SHA --resume-cleanup PATH_TO_PREVIOUS_VOCLE_CLOUDINARY_RESULTS
```

`--offline-check` exercises installation and the existing offline safety and
transport tests without credentials or provider calls. This does not count as
execution of the 34 live provider cases.

To rerun only the existing local security suites after a functional run:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --profile security
```

## Reports

Each run prints its new report directory under repository-root `test-results/`.
For all 187 functional cases, open the folder named in
`test-results/LATEST_FULL_RUN.txt`, then open its top-level
`vocle-regression-dashboard.html`. Its `functional-summary.json` records actual
execution counts; `local-session.md` records environment and cleanup. The
`evidence/detailed/` dashboard includes supporting checks as well. Reports bind source/harness
fingerprints, original IDs, outcome classifications and cleanup. Application
failures and undecided requirements remain red; setup completion is not a full
application PASS. GitHub still independently validates submitted commits.

## Validation status

The fresh single invocation
`test-results/full-187/2026-10-18T09-58-50Z-17dfb426/` executed **187/187**:
**135 PASS, 31 FAIL, 21 NEEDS_DECISION, zero ERROR/BLOCKED/SKIP**. Source and
harness: `ef2c295e4dd2181f1d7d233d96faa7cd7093c5f4`. Backend: 119/10/18;
Flutter: 15/14/3; Android: 1/7/0. Retained sanity: 48/48 PASS; retained Flutter:
33/33 PASS. Original assertions were reused. There were no environment errors in
these 187 cases. Original result fidelity, offline browser rendering, provenance
and disposable cleanup all verified PASS. See
`docs/developer-qa-evidence/2026-10-18-local-parity/single-invocation.json`.

Earlier separate security validation completed all 819 media/data/discovery executions; live Cloudinary
completed all 34 cases in the user's isolated test cloud. Original observations
remain observations. Runtime cleanup PASS. Those historical results and the
earlier combined functional review retain their exact report references in
`docs/developer-qa-evidence/2026-10-18-local-parity/local-execution.json`.
The application gate remains FAIL. Read `VOCLE_LOCAL_VALIDATION_RESULTS.md`
for the latest single-invocation result table and dashboard location.
