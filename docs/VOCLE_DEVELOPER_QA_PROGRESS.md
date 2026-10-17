# Developer to QA workflow progress

## Phase 1: audit (2026-10-11)

Repository: Sriram4747/medcollab-beta-workflows; upstream is read-only.
Baseline HEAD: c7331ec. Existing user application/Android/lockfile edits remain unstaged.

Read AGENTS.md, functional master plan/catalog/matrix/progress/handoff/device instructions,
security plans/checklists, runner contracts, all existing workflow definitions and retained
functional/security evidence. No CODEOWNERS or authorized feature ownership metadata exists.

| Requirement | Existing implementation | Action |
| --- | --- | --- |
| Sanity | 48 original IDs; live runner and functional adapter | Reuse unchanged |
| Backend | 147 IDs; run-backend.mjs, disposable Mongo per module, provider doubles, JSON/JUnit/Markdown | Reuse unchanged |
| Flutter | 32 catalog IDs plus retained tests; pinned 3.29.3 SDK, NDJSON aggregator | Reuse unchanged |
| Android | 8 IDs; run-device.mjs, isolated archive, emulator validation, source/cleanup/APK hashes | Reuse and expose supported invocation |
| Security | Separate frozen manifests, offline self-tests, Docker runtime and isolated provider account workflows | Reuse unchanged |
| Hosted verification | Exact candidate checkout, network-none backend, lockfiles, provenance, complete result gates and artifacts | Extend integration only |
| Evidence/history | Existing success manifests and skip history are for hosted backend scope | Add developer submission evidence and explicit comparisons |
| Local orchestration | Individual runners exist; no combined portable developer command | Add wrapper and prerequisite reporting |
| Ownership/feature policy | No authorized owners, no developer coverage declaration checks | Add UNASSIGNED reporting and PR checks |

Historical results are red, not absent coverage: latest documented hosted #15 has backend
118 PASS/13 FAIL/16 NEEDS_DECISION; Flutter 15 PASS/14 FAIL/3 NEEDS_DECISION.
Final Android execution has 1 PASS/7 FAIL with provenance and cleanup PASS.
Application fixes and Q1–Q14 decisions remain outside this task.

Current host: Node 24.14.1, Flutter installed; Docker CLI unavailable on PATH and standard
Docker Desktop location absent. Network access in the sandbox failed during origin read.
Backend execution must retain OS network isolation; missing Docker must produce BLOCKED.

Next: validate reused contracts/offline security probes; implement only missing wrapper,
submission/comparison/ownership and PR integration; test deliberate red/green/tamper fixtures.

## Phases 2–5: implementation and integration

- Audit checkpoint `efe43c88a5bf85df2630d3dc47d6e09e10fe30cb` pushed to origin/master.
- Tooling/integration `f5bcc29244d624b2445fbdf7d78b038b1806c966` pushed: portable launcher,
  PowerShell entry point, disposable source snapshots, locked dependencies, reused backend/
  Flutter/security runners, JSON/JUnit/Markdown evidence, report checksums and trailers,
  comparison and UNASSIGNED QA reports. Original sanity/security workflows unchanged.
- Submission/policy `ac2fecb47cac1a7e4b0460e248d4bf02f3c01418` pushed: exact clean candidate
  verification, required catalog coverage and trusted-base, scoped expiring exception checks.
- Existing functional workflow extended only with QA artifact generation and tooling paths.
  New Windows/Ubuntu workflow verifies tooling independently, without duplicating backend
  or Flutter functional execution. PR template and onboarding document provided.

## Phase 6: actual validation (2026-10-11)

- Catalog unchanged: 187 IDs, B147/F32/D8 and all 48 sanity IDs preserved. Existing
  fourteen CI/device contracts, sanity/classification self-checks, 691-case security manifest
  validation and offline media/data/Cloudinary probes passed.
- Eight new workflow contracts passed, including all comparison classifications, actual
  deliberate assertion failure and success, report/manifest tampering, dirty provenance,
  changed environment/harness/scope, missing coverage, unknown ownership and scoped exceptions.
  Combined supporting contract run: **22/22 PASS**. Fixtures are synthetic tooling tests;
  they do not establish application correctness.
- Real clean local tooling profile on source/harness `f5bcc29244d624b2445fbdf7d78b038b1806c966`:
  **PASS**, verified checksummed manifest. Scope is tooling, not full release coverage.
  See `developer-qa-evidence/2026-10-11/committed-tooling/`.
- Actual dirty checkout: default full scope **BLOCKED**, every functional ID accounted for;
  Docker unavailable and installed Flutter 3.47.2 mismatched. Dirty source fingerprint
  preserved; no clean commit PASS certificate. A comparison with the clean tooling profile
  rejects all 205 joined records as NOT_COMPARABLE due to scope/source differences.
- Located the previously installed Flutter 3.29.3 SDK. PowerShell full launcher executed
  all 32 catalog IDs on exact clean source `ac2fecb47cac1a7e4b0460e248d4bf02f3c01418`:
  **15 PASS / 14 FAIL / 3 NEEDS_DECISION**, plus **33/33 retained tests PASS**.
  Static analysis remains FAIL. Backend 147 remains explicitly BLOCKED without Docker.
  Overall **FAIL**, final source/harness/cleanup integrity PASS. See `pinned-flutter/`.
- First pinned attempt exposed Flutter wrapper traversal of broken SDK Windows examples
  and six regenerated plugin build files. Original failed diagnostic retained in ignored
  output; tooling now invokes the pinned Dart analyzer and records the six allowlisted
  generated outputs. Libraries/configuration/lockfiles remain immutable. No assertions or
  application behavior changed. Final run verifies cleanup and source integrity.
- Independent hosted tooling run [38115868267](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38115868267)
  on f5bcc29: **Windows and Ubuntu PASS**, both evidence artifacts uploaded. Next submitted
  tooling run [38116059909](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38116059909)
  on ac2fecb also has **Windows and Ubuntu PASS**.
- Existing independent functional run [38115868308](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38115868308)
  on f5bcc29 completed red with **B118 PASS/13 FAIL/16 NEEDS_DECISION**, **F15 PASS/14 FAIL/3
  NEEDS_DECISION**, zero ERROR/BLOCKED/SKIP in those executed scopes. Both original diagnostic
  artifacts preserved. Added QA artifacts verified: backend 29 findings, Flutter 17 findings;
  all source/harness SHAs match f5bcc29 and every suggested owner is **UNASSIGNED**.
  No success marker, assignments, messages or issues created. See `hosted/`.

## Phase 7 and remaining limits

Final runtime verification: [38116541443](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38116541443)
on `4ed68d863ce3e63182fe2c4e519c3bc9bf8947d2` completed **SUCCESS**, Windows/Ubuntu
tooling PASS, Ubuntu portable `backend-smoke` **17 required checks PASS**. The existing
smoke asserted real backend health, synthetic OTP/auth identity and persisted MongoDB state
inside network-none Docker. Provider/network preflight, immutable source/harness and full
disposable workspace cleanup PASS. Saved under `runtime-smoke/`. The initial smoke on
`ec456d409641ab7d9253d259b6f4e0aa1cb2003d` had real assertions PASS but cleanup ERROR
because root-owned Docker dependency files could not be removed; the host UID/GID fix was
verified in the subsequent run. Initial error evidence remains in CI; it was not promoted.

Final reporting explicitly separates local PASS from release readiness. A full local PASS
requires independent CI/QA approval and remains release NEEDS_DECISION; tooling/smoke
release status is NOT_EVALUATED. Original evidence snapshots retain their original schemas
and checksums. Derived QA findings now reference compact source revision records, preserving
all testcase outcomes and avoiding repeated full hash maps per finding.

Onboarding and QA operations are in VOCLE_DEVELOPER_QA_WORKFLOW.md. Implementation is
complete for the missing workflow layer; current application/release gates remain red.
Full local Docker backend/security runtime could not be executed on this Windows host;
portable Docker orchestration was verified with real assertions in the hosted smoke check,
and all reused backend regression runners were independently executed in CI. The security Docker orchestrator
still needs an available Linux Docker host for end-to-end execution. Android's existing
committed-archive runner was contract-validated and historical complete native evidence
reused; no expensive duplicate native run was needed for this wrapper task. Arbitrary APK
and dirty/external-checkout Android certification remain explicitly unavailable. Provider
accounts, hosted emulator provisioning, iOS/physical devices and branch-protection setup
remain infrastructure/authorization gaps. Authorized owner mapping is still pending.

Exact next action: review saved evidence and the latest pushed tooling integration run;
on a Linux Docker host run `node tests/developer-workflow/run.mjs --source . --commit EXACT_SHA
--security` with Flutter 3.29.3. Resolve existing application failures and Q decisions through
the separate developer process, approve ownership and required branch checks, then rerun
exact candidate full gates. Sriram handles upstream integration after approval. No upstream
or production writes occurred, and all original unrelated user work remains unstaged.

## Disposable Python launcher (2026-10-17)

Added `python scripts/test_vocle.py --source .` as a portable local entry point.
It creates a temporary Python venv without pip dependencies, executes the original
Node harness with isolated Pub/npm/Gradle caches and home directories, retains
reports locally, then removes the session. The existing harness performs locked
Flutter package resolution and npm installation inside disposable source copies.
No test assertions or application code were changed. Git/Node/npm, Flutter 3.29.3
and a local Linux Docker engine remain installed prerequisites; the venv does not
contain those runtimes. Existing SDKs, emulator and Docker images are reused.

The existing Windows/Ubuntu tooling integration now runs through Python and
includes five Python lifecycle contracts and three process-lifecycle contracts.
The original full functional CI jobs and existing sanity/security suites are reused.
Python 3.12 is selected using the official immutable setup-python v5 action revision.
The Python entry point is included in the recorded harness fingerprint. Android
ADB discovery honors the original Android SDK path when temporary HOME is used.

Measured local validation on application `23c3efd40529fd8b8e25b22964339e9d71cb9e61`:

- Five Python contracts PASS. The combined Node run passed 51 contracts across
  process/workflow, existing CI/device and report adapters/escaping.
- Actual Python tooling session: PASS, all 13 checks executed, venv/caches and
  nested source workspaces removed. Dirty source remains labeled working-tree.
- Actual Python full session with the installed pinned SDK: locked Flutter package
  download PASS; all 32 catalog cases executed with 15 PASS / 14 FAIL /
  3 NEEDS_DECISION; all 33 retained tests PASS; static analysis FAIL. All 147
  backend IDs remain BLOCKED because Docker is unavailable on this Windows host.
  Overall FAIL is preserved. Source/harness integrity and both cleanup layers PASS.
- Actual whole-launcher interruption during npm setup: exit 130, ERROR test gate,
  INTERRUPTED session, no pass manifest; both disposable workspace layers removed.
  This exposed a Windows infinite process-wait issue: Python signal delivery was
  delayed until child exit. Bounded waits now let the launcher forward cancellation
  promptly; the real interrupted rerun and signal contract both pass. Child
  termination removes the entire owned process tree on timeout/cancellation.
- First sandboxed run correctly produced ERROR when temporary Git configuration
  writes were denied. Retried real execution with the required local test access;
  original error evidence remains in ignored output.

Local evidence is under `tests/developer-workflow/output/python-tooling-verified/`,
`python-full-validation/`, and `python-cancel-verified/`. Each contains session
JSON/Markdown; `evidence/` contains the original checksummed reports and offline
HTML dashboard. Setup failures still retain session reports. `--previous` accepts
the Python report root or the previous direct evidence directory. Existing source,
coverage and release evidence restrictions remain in force. Optional Android
execution was not rerun for this launcher change; SDK path integration and existing
device contracts were validated. Abrupt termination can prevent cleanup.

Next: validate the exact submitted Python tooling candidate on Windows/Ubuntu in
the existing integration workflow. Full local backend/security execution still
requires a working Linux Docker engine. Existing application failures/product
decisions are unchanged and must be resolved through the developer process.

Committed local tooling validation on `78b9dd7d3e6ee439e01c8c516f33bccdd48f9203`
passed with 13 checks, verified committed pass manifest, previous-Python-root
comparison and cleanup PASS. The full/tooling scope difference correctly makes
the previous report NOT_COMPARABLE. First hosted integration
[39019569817](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/39019569817)
passed Python execution on Ubuntu but found a Windows-only fixture path mismatch:
the hosted temp directory uses the `RUNNER~1` short alias, while the launcher
correctly resolves its full path. The fixture now resolves its expected path too;
no runner behavior or assertion coverage changed. Hosted rerun remains required.

Hosted rerun [39019681073](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/39019681073)
on `3054cb68c9d0cba49a5ab7dd8ed86c5b70dddf73` completed **SUCCESS**: Windows
and Ubuntu Python contracts and actual tooling execution PASS, original Ubuntu
Docker runtime smoke PASS, artifact uploads and the shared visual QA report PASS.
This verifies both platforms without a second full functional CI suite. Measured
local session summaries/checksums are saved in
`developer-qa-evidence/2026-10-17-python/validation.json`; the original local
checksummed evidence and dashboard paths remain listed above. Current application
failures and missing local Docker still prevent a full local release claim.
Next action: developers use the documented Python command with Flutter 3.29.3
and a running local Linux Docker engine, then review the retained gate, diagnostics,
QA findings and independent exact-commit CI results.

Downloaded both hosted matrix artifacts and read their JSON ZIP members without
extracting or executing contents. Verified report checksums, exact candidate and
harness SHAs, all required outcomes, and source/workspace/session cleanup:
Windows tooling 13/13 PASS; Ubuntu tooling 13/13 PASS and Docker smoke 17/17 PASS.
Archive hashes and report details are saved in
`developer-qa-evidence/2026-10-17-python/hosted-validation.json`.

## Automatic runtime setup correction (2026-10-17)

The previous Python wrapper still required developers to configure Flutter and
Docker. Added automatic runtime setup: Node 22.20.0 download when needed, automatic
pinned Flutter discovery/download, and minimal private Docker Engine provisioning
on x64 Windows/WSL 2 and Linux. Bootstrap reuses the existing suites and original
network-none assertion commands. The guest/daemon, its images and downloaded tools
are disposable. Existing local engines can be reused; unrelated resources are never
pruned. Runtimes have committed archive checksums or an exact Flutter commit pin.

Windows WSL is an OS prerequisite outside a Python venv. The launcher automates its
installation with a fixed elevated helper, reports RESTART_REQUIRED rather than
test success, and never reboots the computer. One-time OS permission/restart and
hardware virtualization cannot be hidden by a venv. Current machine inspection:
Windows 11 Pro, firmware virtualization enabled, WSL not installed. Windows guest
execution needs that OS setup completed before it can be validated locally.

Measured so far: 14 Python bootstrap/lifecycle contracts PASS, 11 Node workflow/
process contracts PASS. Actual fresh Windows Node 22.20.0 archive download, checksum,
extraction and execution PASS; automatic Flutter 3.29.3 discovery PASS even though
PATH points to 3.47.2. Disposable validation files removed. Existing CI's Ubuntu
smoke step now uses the Python launcher with `--runtime managed`, to exercise a
real fresh engine and teardown without adding a second functional regression suite.
Next: validate the managed engine in CI and run the automated Windows platform
setup; preserve setup/restart limitations and existing application failures.
