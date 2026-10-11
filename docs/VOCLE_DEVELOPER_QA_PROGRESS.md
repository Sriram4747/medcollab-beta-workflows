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

Onboarding and QA operations are in VOCLE_DEVELOPER_QA_WORKFLOW.md. Implementation is
complete for the missing workflow layer; current application/release gates remain red.
Local Docker backend/security runtime could not be executed on this host; their reused
backend runners were independently executed in CI. The new security Docker orchestrator
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
