# Developer regression and independent QA

## Start here

For a disposable Python session, install **Python 3.10+**, Git, Node 22+/npm,
Flutter **3.29.3**, and Docker with a running Linux engine. Run from the repository:

```sh
python scripts/test_vocle.py --source .
python scripts/test_vocle.py --source . --commit FULL_40_CHARACTER_SHA
python scripts/test_vocle.py --source . --flutter-bin /path/to/flutter/bin/flutter
python scripts/test_vocle.py --source . --previous path/to/previous-python-report
python scripts/test_vocle.py --source . --security
```

On Windows use `python` (or `py -3`); on systems that call Python 3 `python3`,
use `python3`. No manual venv activation or pip install is needed. The launcher
creates a temporary venv, starts its Python interpreter, and calls the existing
Node harness. Flutter/Dart and Node execute the original assertions using their
own runtimes; a Python venv does not install or isolate those runtimes.

The existing harness installs **Flutter packages** using
`flutter pub get --enforce-lockfile`, installs npm dependencies using `npm ci`,
and tests a disposable source copy. The Python session supplies temporary Pub,
npm and Gradle caches, temporary home directories, and temporary build directories.
It does not install the Flutter SDK, Node, Docker or Android SDK globally. These
tools must already be available; `--flutter-bin` selects an existing pinned SDK.
Missing/mismatched Flutter or an unavailable Docker engine stays BLOCKED in the
report while other checks run. Package downloads need internet access; backend
assertions run in the existing network-none Docker containers.

After success, test failure, setup failure or a handled Ctrl+C, temporary source
copies, the venv and session package caches are deleted. Owned containers are
removed by the original harness. The existing Flutter SDK, Docker engine/images,
Android SDK and running emulator are reused and remain installed. Abrupt power
loss or force-killing the launcher can prevent normal cleanup.

Reports are retained under a new ignored
`tests/developer-workflow/output/python-<timestamp>-<id>/` directory, or the new
directory supplied with `--output`. Open `local-session.md` for session/cleanup
status and `evidence/detailed/vocle-regression-dashboard.html` for the offline
dashboard. Original JSON/JUnit/Markdown, QA findings, submission evidence and
comparison reports are under `evidence/`. Both an older Python report root and
an older direct evidence directory work with `--previous`. For submission checks,
use the `evidence/` directory with the existing verifier. Setup failure before
the harness starts produces `local-session.json` and `local-session.md`, with no
PASS evidence. A nonzero exit means the session did not pass; cleanup errors
also make the launcher exit nonzero.

`--profile tooling` is a quick check of the wrapper and existing offline tooling;
the default `full` runs the existing locally supported regression scope. Android,
provider integration, dirty-source evidence and release limitations below apply
equally to Python. The script never commits, pushes or opens a pull request.

### Existing PowerShell and Node entry points

Use Node 22 or later, Git, npm, and a Linux Docker engine (Docker Desktop works on
Windows) for backend runtime isolation. Flutter must be **3.29.3**, the version
already validated by the existing workflow. Package downloads happen before runtime;
backend execution uses the existing pinned Node image in network-none containers.
No application `.env` or provider credentials are copied into test workspaces.
Use synthetic data only. All repository writes target the testing fork.

From the repository root, PowerShell:

```powershell
.\scripts\Test-Vocle.ps1 -Source .
.\scripts\Test-Vocle.ps1 -Source . -Commit (git rev-parse HEAD)
.\scripts\Test-Vocle.ps1 -Source C:\work\vocle -Previous C:\reports\previous
.\scripts\Test-Vocle.ps1 -Commit (git rev-parse HEAD) -Android
.\scripts\Test-Vocle.ps1 -Commit (git rev-parse HEAD) -Security
```

Portable equivalent (a complete 40-character SHA is required):

```sh
node tests/developer-workflow/run.mjs --source .
node tests/developer-workflow/run.mjs --source . --commit FULL_SHA --output reports/new
node tests/developer-workflow/run.mjs --source . --previous reports/old
node tests/developer-workflow/run.mjs --source . --commit FULL_SHA --android --flutter-bin /path/to/flutter
node tests/developer-workflow/run.mjs --source . --security
```

Reports default to a unique ignored `tests/developer-workflow/output/` directory.
An explicit output directory must not already exist. Source/dependency workspaces are
disposable OS temporary directories. The launcher never commits or pushes application
changes. It copies uncommitted application files into the source snapshot; excluded
dependencies, ignored credentials and build output never become source evidence.
Test overlays come from the recorded harness and are explicitly separate from source.
Both application and harness content hashes are recorded, including dirty harness files.
Locked Flutter resolution may regenerate the six tracked Windows/Linux plugin build
outputs. Their changed names and before/after fingerprints are recorded in
`source-integrity.json`; application libraries/configuration/lockfiles must stay unchanged.

`--profile tooling` runs only catalog/contracts/offline security and sanity self-checks.
Its PASS manifest names that scope; it is **not full functional or release evidence**.
`full` is the default. Missing required prerequisites produce non-success reports.
`--profile backend-smoke` also validates Docker preparation, network isolation, real
synthetic authentication and database assertions via the existing smoke runner. The
Ubuntu integration job runs this limited check to verify orchestration without repeating
the full 147-case suite. It cannot supply full submission/release evidence.

## Coverage and requirements

| Category | Local execution | Gate / limitation |
| --- | --- | --- |
| Sanity | Existing 48 assertions through the unchanged backend sanity adapter | Required; included once in the 147 backend IDs |
| Backend functional | Existing run-backend.mjs: all 147, including concurrency, recovery and journeys | Required; Linux Docker/network-none and pinned dependencies |
| Flutter | All 32 catalog cases plus discovered retained top-level unit/widget tests | Required; pinned SDK, locked pub dependencies and existing fakes |
| Catalog / provenance / dependency installs | Existing catalog/contracts; source hashes before/after; lock-enforced npm/pub installs | Required |
| Static analysis | The pinned Flutter SDK's Dart analyzer, using the locked package configuration | Required; issues remain red, no application changes |
| Offline security | Existing frozen manifest and media/data/Cloudinary self-tests | Required; real guard and controller assertions, no provider calls |
| Full media/data/discovery security | `--security`: existing run.js and fixture/auth/discovery scripts | Optional by default; requesting the lane makes runtime execution/infrastructure required. Observations stay visible and existing runner gates apply. No observation is silently promoted to PASS |
| Android 8 | `--android`: existing run-device.mjs, exact committed archive | Optional; one online Android emulator, no physical devices; source commit must exist in the harness checkout |
| Legacy backend Jest files | Explicit BLOCKED entry | Existing package lock has no Jest runtime; npm test is a placeholder. No assertion execution claimed |
| Arbitrary submitted APK | `--apk PATH` records bytes/hash and an explicit BLOCKED entry | APK alone cannot bind source or execute the existing instrumented Flutter assertions. The supported device runner builds and records APK hashes from exact source |

Required FAIL, ERROR, BLOCKED, NEEDS_DECISION and SKIP prevent PASS. Cases keep their
original IDs and outcome statuses; counts are not repaired to make a gate green.
Reports distinguish the local gate from release readiness. Tooling/smoke profiles leave
release readiness NOT_EVALUATED. Even a full local PASS leaves the release gate
NEEDS_DECISION until independent hosted verification and applicable QA approval exist.
An optional lane never supplies a required case's PASS. Missing reports become explicit
errors/blocks. Reports include every functional catalog ID in full mode, even when a
prerequisite is unavailable. The tooling profile deliberately has a different scope.

Android currently reuses the committed-archive interface. Dirty source and arbitrary
external source directories cannot be certified by that interface; their device entries
state the limitation. Import/fetch the authorized source commit read-only into this fork's
object database before using the existing device runner. Never substitute a clean HEAD
device run for dirty source evidence. Use the existing detailed
[device instructions](VOCLE_FUNCTIONAL_REGRESSION_DEVICE_RUNNER.md) for SDK/ADB/Mongo
binary overrides and runtime constraints. iOS and physical device coverage remain gaps.

## Submission and comparisons

Each run writes `results.json`, `manifest.json`, `junit.xml`, `report.md`,
`submission.md`, `qa-defects.json`, `qa-defects.md` and diagnostic logs.
A verified committed PASS also writes `pass-manifest.json`; a dirty-tree PASS remains
identified by its content fingerprint. Neither certifies a later commit.

Paste generated `submission.md` into the PR and attach `results.json` plus `manifest.json`,
or reference a retained CI artifact containing both. Replace REPORT_URL with that link.
The suggested trailers contain the report checksum, source and harness identifiers.
The checksum detects artifact changes; it does not authenticate a developer's claims.
Hosted CI must independently execute the exact PR head SHA. Required gates must be
configured as required branch checks by an authorized repository administrator.
This task does not change repository protection or create issues/notifications.

```sh
node tests/developer-workflow/compare.mjs reports/old reports/new reports/comparison
node tests/developer-workflow/verify-submission.mjs reports/new EXACT_PR_HEAD_SHA
```

Both report/manifest pairs must pass integrity/checksum/result-set validation, even
when their application verdict is red. Comparison joins IDs and reports FIXED,
NEW_REGRESSION, STILL_FAILING, STILL_PASSING, STATUS_CHANGED, NEW_TEST,
REMOVED_TEST and NOT_COMPARABLE. Direct verdict comparison requires identical harness,
definition, environment and requirement fingerprints, executed cases and clean commit
provenance. Dirty evidence, changed expectations/dependencies/platforms or incomplete
execution cannot be called a fix/regression. A harness change conservatively makes
existing cases NOT_COMPARABLE; retest both commits with the same harness to compare them.
Old/new application SHAs and both harness fingerprints appear in JSON and Markdown.

## Independent QA

Reuse [functional CI](https://github.com/Sriram4747/medcollab-beta-workflows/actions/workflows/vocle-functional-regression.yml)
for independently isolated backend and hosted Flutter verification. The added
[developer QA integration check](https://github.com/Sriram4747/medcollab-beta-workflows/actions/workflows/vocle-developer-qa.yml)
tests tooling on Windows/Ubuntu, verifies exact candidate tooling and enforces PR coverage
declarations. It adds no second expensive functional suite. Sanity and all security
workflow definitions remain unchanged.

Full integration, cross-feature journeys, DB lifecycle, realtime/concurrency and local
security are executable locally with their stated prerequisites; they are not QA-only.
Independent CI reruns them for trust. Actual provider account integration is QA-only
because it requires an approved TEST account, credential isolation and provider resource
cleanup. Use the existing
[Cloudinary workflow](https://github.com/Sriram4747/medcollab-beta-workflows/actions/workflows/vocle-cloudinary-security.yml)
and [account checklist](SECURITY_CLOUDINARY_HARDENING_2026-10-06.md).
Native Android is locally executable; hosted emulator provisioning remains an infrastructure
gap. macOS/iOS and physical-device checks require the corresponding platform environment.

QA artifacts identify defect ID, module, testcase IDs, suggested severity, reproducibility,
expected/actual behavior, source revision, reproduction command, logs and verification status.
Reports imported from existing CI use their source provenance and original artifacts.
Convert existing reports directly with:

```sh
node tests/developer-workflow/qa.mjs path/to/results.json path/to/report-directory
```

`tests/developer-workflow/ownership.json` has no invented assignments. Authorized
maintainers may add `modules` entries and approve the map; until then every suggested
owner is **UNASSIGNED** and requests authorized ownership. No automatic issue filing,
assignment or notification occurs. Explicit evidence-backed `rootCause` keys permit
grouping; similar error messages alone do not establish a duplicate defect.
QA must reproduce and determine severity/root cause before routing a report.

## New features and review policy

For any application source change, add `.github/regression-coverage.json`:

```json
{
  "schemaVersion": 1,
  "newFeature": true,
  "reviewReason": "Describe the behavior introduced or changed",
  "testcaseIds": ["NEW_REGISTERED_FUNCTIONAL_ID"],
  "localCommand": "node tests/developer-workflow/run.mjs --source .",
  "ciWorkflow": ".github/workflows/vocle-functional-regression.yml",
  "crossFeatureReview": "Describe journeys and QA validation required",
  "securityRelevant": true,
  "securityTestcaseIds": ["REGISTERED_SECURITY_ID"],
  "securityWorkflow": ".github/workflows/vocle-backend-environment-test.yml"
}
```

If security is unaffected, set `securityRelevant` false and provide `securityReason`.
The PR checker preserves old IDs, requires registered new cases for declared new features,
finds executable test references, and checks declared security references. Existing catalog
validators deliberately freeze counts; expand their reviewed count invariants and catalog
Markdown/JSON together when adding cases. Never rename old IDs or weaken their assertions.
The original functional selection/gates remain authoritative for runtime coverage.

Self-declared exceptions are rejected. Any exception must already have an authorized
approver and unexpired metadata in the trusted base `.github/regression-exceptions.json`.
To waive missing feature coverage, trusted metadata must additionally set
`allowMissingCoverage` true and list every changed application file in `paths`; the PR
declaration references its `exceptionId` and a review reason. Stable IDs and execution
failures remain enforced. No exceptions are currently authorized.

Reviewers must check: complete feature scenarios and negative boundaries; security impact;
actual assertions and relevant local/CI runners; dependency/cross-feature effects; exact
source evidence; test failures/product decisions; owner authorization. The checker cannot
detect every missing scenario or determine whether a change is truly a new feature.
Declare and review that judgment; no automatic completeness claim is made.

## Upstream integration

Examples and measured outcomes are saved in
[`developer-qa-evidence/2026-10-11/`](developer-qa-evidence/2026-10-11/), with the detailed
validation record in [VOCLE_DEVELOPER_QA_PROGRESS.md](VOCLE_DEVELOPER_QA_PROGRESS.md).
The snapshots include a verified tooling pass manifest, a dirty-source blocked report,
pinned Flutter failure evidence, rejected comparison, hosted owner-aware findings and
a real Docker smoke PASS. Every example retains its scope and exact tested revision.

Review the testing-fork commits and artifacts. Sriram will separately approve and handle
upstream integration. Transfer only reviewed workflow/tooling/docs changes, configure
authorized owners and required branch checks, then rerun exact-source hosted gates.
Never carry user worktree edits or historical red evidence into a green release claim.
Upstream remains read-only throughout this task.
