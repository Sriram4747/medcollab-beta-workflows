# Vocle regression implementation handoff

This session delivered documentation only. **Do not interpret this document as authorization to implement application fixes.** A later implementation session should build the test harness and dedicated workflow, preserve sanity/security suites, and report defects separately. Read AGENTS.md, the master plan, catalog and matrix first.

## Exact batch order and acceptance

| Batch | New/extended files in later implementation | Cases / acceptance |
|---|---|---|
| 0. Freeze evidence/oracles | `tests/functional-regression/catalog.json`, `contracts/decisions.md`, `scripts/validate-catalog.mjs` | Import all 187 stable IDs, module/tier/priority/coverage/source/question/dependencies. Validate unique IDs/counts and preserve all 48 sanity IDs. Pin target SHA, record fork/upstream differences. Resolve Q questions or visibly mark NEEDS_DECISION. No silent expectation changes. |
| 1. Isolated harness | `tests/functional-regression/package.json`, lockfile, `src/config.mjs`, `src/http.mjs`, `src/db.mjs`, `src/socket.mjs`, `src/fixtures.mjs`, `src/runner.mjs`, `src/reporting.mjs`, `providers/preload.cjs`, `providers/fixtures/` | Disposable loopback Mongo/backend; real app unchanged; synthetic identities. Deliberate assertion failure, setup failure, timeout, blocked dependency and missing ID produce distinct non-green reports. Sanity can be invoked unchanged in its own DB/process with original IDs; never copy repaired app files. |
| 2. Identity/community | `suites/auth.mjs`, `profile.mjs`, `discovery.mjs`, `spaces.mjs`, `channels.mjs`, `requests.mjs`, `conversations.mjs` | B cases AUTH/PRO/DISC/SPC/CH/REQ/DM. Verify mutation+read and boundary tables. Independent component fixture setup survives failed request journey without masking failure. Record Q2/Q7/Q10/Q14. |
| 3. Communication/attention | `suites/messages.mjs`, `threads.mjs`, `social.mjs`, `notifications.mjs`, `push-contracts.mjs`, `realtime.mjs`, `search.mjs` | B MSG/THR/SOC/NOT/PUSH/RT/SRCH. Listener-before-action checks, absence positive controls, exact IDs, deterministic paging, fake provider capture. Fresh and recovered Socket.IO sessions both tested; inspect missing recovered handlers. |
| 4. Handoffs/media/recovery | `suites/handoffs.mjs`, `media.mjs`, `support.mjs`, `runtime.mjs`, `journeys.mjs`; `fixtures/media/` | B HOF/MED/SUP/RUN/JRN. Concurrent submit/ack gates, patient/history persistence, exact media bytes, process restart. Document media pipeline limitations as unresolved/failed, not cloud-success substitutions. |
| 5. Dedicated CI | `.github/workflows/vocle-functional-regression.yml`; `scripts/resolve-target.mjs`, `find-baseline.mjs`, `fingerprint.mjs`, `verify-target.mjs`, `manifest.mjs`, `ci-contracts.mjs` under new harness | Implement workflow design below. Manual, changed-SHA, unchanged-success, changed-harness, expired evidence, cancelled/failed attempt, API error and artifact failure contracts verified. Existing `.github/workflows/vocle-sanity.yml` unchanged. |
| 6. Flutter | `medcollab-app/test/functional_regression/{auth_navigation,chat_reconciliation,threads,handoffs,notifications,home,storage,links,error_recovery}_test.dart`, `test/functional_regression/fakes/` | All 32 F cases; preserve existing 8 test files. Use current lockfile-compatible Flutter SDK. Fake repository, storage/platform channels and clocks; no cosmetic snapshot-only substitute for business assertions. |
| 7. Device/release | `medcollab-app/integration_test/functional_regression/{lifecycle,media,notifications,invites,journeys}_test.dart`, documented local device runner | All 8 D cases on Android; add iOS runner for claimed iOS support. Use injected provider inputs and local backend. Record platform limitations; no real providers/credentials. Full release report identifies B/F/D results separately. |

Every batch ends with count/source-reference validation, focused execution of its cases, structured report, updated decision ledger and documentation checkpoint commit to the fork. If interrupted, record completed IDs, failing/blocked IDs, tested target/harness SHAs, reproduction command, next batch and pending product decisions. Never label a partially implemented registry complete.

## Fixtures and dependency isolation

Use the catalog U/C/H/N/M/F0/D0 profiles. API-create onboarding/membership/resources in actual journeys. Component modules can model-seed accepted requests, roles, large histories, timestamps and provider failure prerequisites; report seeded prerequisites as setup, never as passed business operations.

Allocate a unique database and backend process per module worker because presence maps, rate limiters and socket singleton state are process-local. A shared Mongo container can host separate DBs, but worker ports/processes/uploads/inbox directories remain separate. Sanity runs untouched with its exact configured DB name in a separate isolated namespace. Do not reuse cached identities across fresh databases; include DB/run identity in cache metadata. Cap backend workers initially at two to avoid resource contention and duplicated OTP setup. Reuse U within a module, but create independent S2/channels for destructive cases.

Create only synthetic names, markers and patient aliases. Build bounded large fixtures directly for paging/copy-limit cases; verify indexes ready before concurrency checks. Specify createdAt/_id ordering deliberately; use an ObjectId sequence for message cursors and separate shift dates for handoff pagination. Fix `TZ=UTC` for backend baseline and run targeted timezone cases with explicit process TZ; Flutter clock cases include Asia/Kolkata calendar boundaries. Clock injection must not replace business services. Expiry prerequisites may be model-seeded; the endpoint performs verification.

Reuse patterns from sanity HTTP/socket/provider helpers after review, not imports that depend on mutable sanity output. Retained sanity execution can be wrapped by an adapter mapping its JSON to the new report without changing its code. New modules must not import security discovery results or status classification.

## Dedicated workflow design (no YAML created in this phase)

Filename: `.github/workflows/vocle-functional-regression.yml`; display name: **Vocle Functional Regression**. Independent of Functional Sanity and all security workflows.

### Triggers and source selection

1. `workflow_dispatch`: inputs `force` (false), `scope` (backend-all default, backend-p0 for diagnostics), optional full 40-character `upstream_sha`. Empty SHA resolves explicit upstream `refs/heads/master`, never upstream HEAD. Validate input before use; never interpolate unvalidated input into shell. Manual selected subsets do not advance full-suite history.
2. Daily schedule at 02:43 UTC (08:13 India time). Resolve the latest upstream master SHA read-only; execute only when it lacks valid full-backend success evidence for the current harness fingerprint, or force is set. Failed/blocked revisions retry on later schedules because they still require validation. Schedule can be delayed and operates from default branch; confirm fork default branch is master before enabling. See [GitHub event documentation](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#schedule).
3. Fork `pull_request`/`push` on relevant backend/harness/workflow paths: run all verified B/P0 plus affected B/P1/P2 feature modules. Common middleware/constants/models/socket/provider changes select all backend modules. Unknown dependency mapping defaults to all. Source for these runs is the exact fork event revision, distinctly recorded as `targetKind=fork-change`; do not claim it is upstream validation and never use it as upstream skip evidence. Avoid `pull_request_target`. Documentation-only changes may run catalog validation only, not generate application-success evidence.
4. Relevant Flutter changes run existing Flutter tests and affected F cases in a separate job/lane; device cases remain manual/pre-release infrastructure. This workflow's backend schedule must not imply mobile completion.

Schedule/manual trusted validation is restricted to `Sriram4747/medcollab-beta-workflows` on master. PR reports remain untrusted and cannot supply trusted skip state. Use separate concurrency groups for trusted upstream validation and fork PR revisions, cancel-in-progress=false for trusted runs. Resolve the current SHA once inside the serialized trusted run; a later upstream commit waits for the next scheduled/manual detection. No upstream webhook/write access required.

### Jobs and provenance

**Detect:** checkout exact harness SHA with credentials not persisted; compute fingerprint over regression code, catalog, provider fixtures, workflow and retained sanity adapter/input files. Credential-free `git ls-remote --exit-code https://github.com/mathiharan29/medcollab-beta.git refs/heads/master` must return exactly one expected ref/SHA. Detection API errors fail ERROR, never SKIP. No Mongo/image provisioning for a skipped run.

**Prepare/execute:** check fork harness into `harness/`; fetch captured upstream SHA into independent `target/`, detach, assert HEAD and tree/lockfile hashes. Use target's own npm lockfile. Do not merge, checkout a moving ref after resolution, overlay fork fixes or alter target tracked files. If captured SHA cannot be fetched, ERROR; no fallback tip. For fork-change mode label source and install its own lockfile similarly.

Prepare pinned runtime image/dependencies before application starts. Initial runner design: Ubuntu 24.04, Node 22, MongoDB 7, Docker and npm, following existing sanity baseline; implementation must pin tested image/action revisions and measure compatibility with the captured target's package engines. No promise of future compatibility with arbitrary upstream dependency changes.

Run disposable Mongo with network none and backend/test-driver containers sharing its network namespace; loopback communication only, no published production-connected ports. Separate workers use separate namespaces or isolated ports. Runtime gets minimal explicit environment: NODE_ENV=test, local MONGODB_URI/API origin, test JWT secrets, OTP_BYPASS=false, dummy provider settings. No `.env`, real secrets, home credentials, Actions token, Docker socket or cloud config inside application containers. Target tracked source read-only; writable uploads/temp/report mounts separate. Preflight provider-fake lane proves every provider request is intercepted and all other outbound traffic denied. Standard lane keeps Firebase/Cloudinary unconfigured; provider-contract lane uses only fake adapter responses and is labeled separately.

Order: preflight/provenance → DB health → app health → retained sanity lane → independent feature modules (continue despite other feature failures) → journey chains → report/diagnostics → cleanup/provenance → artifact upload → success manifest. A failing sanity case does not suppress independent regression evidence, but prevents combined backend PASS. Within a chain report dependent steps BLOCKED, not false failures or omitted IDs.

**Summary:** always run. Inspect upstream detection, execution, reporting, provenance, cleanup and artifact results. Distinguish PASS/FAIL/ERROR/BLOCKED/NEEDS_DECISION/SKIP; detection failure must never enter a generic `needs_run != true => SKIP` branch. Statuses are report-level distinctions; all unresolved required outcomes are non-success CI. No `continue-on-error` on regression gates.

### Skip/history algorithm

Permissions only `contents: read`, `actions: read`; default GitHub artifact upload mechanism, no repo-write permission, PAT, upstream credentials, issue/PR posting or writable state branch.

Evidence key: upstream repository + explicit ref + exact tested SHA + suite fingerprint + `backend-all` scope + environment contract version. Equality, not commit date/ancestry, decides whether a new revision requires testing; rollbacks/rebases require their own evidence. Never confuse workflow `head_sha` (fork harness revision) with target upstream SHA.

Paginate this workflow's trusted fork scheduled/manual run history. Accept only completed successful matching run/attempt and successful execute/report/cleanup jobs. Download the matching attempt's validated success manifest and confirm expected testcase ID set, zero failed/blocked/undecided/missing, provenance and artifact digests. Fingerprint includes assertion decisions; changed assertions force retest at same app SHA. Different workflows, PR artifacts, previous attempt artifacts of failed reruns and subset results cannot advance history. Reject duplicate/missing testcase IDs. No full backend success marker until all 147 backend cases have verified expectations and pass; before then version a verified subset with a different scope key, never falsely satisfy backend-all.

Persist reports per run/attempt and request 90-day retention subject to repository limits. Missing/expired/deleted success artifact causes conservative retest. API outages cause ERROR. Artifacts provide retained history, not permanent archival; export evidence through a separately authorized process if longer retention is needed. GitHub supports artifact retention and cross-run downloads; see [artifact documentation](https://docs.github.com/en/actions/tutorials/store-and-share-data).

### Results, failure classification and artifacts

Proposed artifact directory:

```text
functional-regression/<run-id>/<attempt>/
  manifest.json                 # source/harness/fingerprint/environment and selected ID set
  results.json                  # case IDs, outcome, steps, expected/actual, duration, dependency
  junit.xml                     # CI/test UI consumption
  report.md                     # module totals, regressions, gaps, product questions
  coverage.json                 # planned/selected/executed/blocked by tier and priority
  diagnostics/backend-<worker>.log
  diagnostics/events-<case>.json # correlated event trace, no tokens
  diagnostics/db-diff-<case>.json
  provenance.json               # HEAD/tree/lockfile hashes and source-change checks
  cleanup.json
  success-manifest.json         # only after verified complete success
```

JSON case record includes ID/title/module/tier/priority, prerequisite seed/API origin, expected behavior version, start/duration, observed HTTP state/DB delta/event IDs, target SHA, error category and dependency failure IDs. Keep response bodies synthetic; redact JWTs/device tokens/fake inbox codes anyway to reduce log noise. Include artifact links in job summary; do not auto-message people.

- **FAIL / application behavior:** healthy app/environment, verified expected business assertion false. A reproducible 500 on an ordinary valid application operation is a failure, not infrastructure merely because HTTP=500. Keep evidence and avoid automatically rerunning until green.
- **ERROR / infrastructure:** dependency install failure, unavailable Docker/DB before app readiness, harness crash/schema mismatch, inability to fetch exact source, provider interception/isolation failure, missing required artifacts or cleanup/provenance failure. A DB-outage testcase deliberately induces failure and asserts recovery; that expected injection itself is not infrastructure failure.
- **BLOCKED:** prerequisite operation failed; report linked root failure. Independent suites still run. Blocks preclude full success.
- **NEEDS_DECISION:** disputed expectation Q; report exact source/current observations and verified subassertions. Must resolve or explicitly scope out under separately named coverage before enforcement; never turn into full-suite PASS.
- **SKIP:** only valid unchanged-success key, or explicitly unselected tier/scope with clear reason. Not a passed testcase.

No flaky-test quarantine that hides a verified product failure. Register listeners first; await explicit ready/join/sync, correlate resource IDs, tolerate transport duplicate fan-out while asserting one business record. Poll async DB state under a measured deadline. Capture event and DB snapshots on timeout. Test negative events after a positive control and settled relevant operation. Set request/socket/module/workflow deadlines separately; initial proposals 10s read/side effect, provider-failure 20s, feature module 120s, backend job 30min. Review measured p95 and diagnose bottlenecks before adjusting. Use explicit barriers for race tests, not sleep-based overlap.

Teardown always closes sockets/drivers, stops app, captures logs before removal, removes only run-owned containers/volumes/uploads and checks target unchanged. Do not emit success before cleanup and diagnostic upload succeed. A cancelled run never becomes a successful baseline. Bound cleanup itself.

## Frequency, runtime and infrastructure estimates

These are planning estimates, **not measured benchmarks**. Existing sanity workflow has a 15-minute job timeout and 60-second module process cap; those limits are not observed runtime.

| Lane | Frequency | Initial runtime budget / needs |
|---|---|---|
| Existing sanity | Preserve current manual workflow; invoke unchanged adapter in backend regression | 2–5min warm runtime estimate; independent DB/process |
| Verified B/P0 plus affected modules | Every relevant fork application/harness change | 5–10min warm runtime, 2–5min cold dependency/image overhead |
| Backend-all (147 cases) | Daily only changed/unvalidated exact upstream revision; manual force | 10–20min warm budget, 30min job timeout; Ubuntu/Docker/Node/Mongo, two workers initially |
| Flutter 32 plus existing tests | Relevant mobile changes, before release | 3–8min tests after SDK/cache/build preparation; no Mongo for fake-transport cases |
| Device 8 | Before release and when lifecycle/media/push/navigation changes | 15–30min per platform plus build/boot; Android emulator and optional macOS/iOS runner |

Release readiness requires verified relevant B/F/D results on the same application revision or explicitly documented corresponding build hashes. Backend-only daily evidence cannot certify mobile release behavior. Keep Functional Sanity and security workflows/results independent; no security observation status can excuse a functional failure.

## Fresh Terra/Sol session instructions

1. Read these four docs and AGENTS.md; inspect git status/remotes. Preserve unrelated work. Work only in the fork; upstream read-only.
2. Confirm user now authorizes implementation. Start Batch 0, recount registry IDs, pin fetched target and inspect source drift against the documented fork baseline. Update source/decision evidence before changing expectations.
3. Resolve Q1–Q14 with developer evidence where required; implement verified cases without waiting on unrelated undecided cases. Keep IDs and exclusion reasons explicit.
4. Implement batches sequentially with incremental documentation commits. Do not expand or replace the existing sanity/security workflows. Batch 5 creates the new YAML only during implementation authorization.
5. Report completed case IDs, passing/failing/blocked/undecided counts, exact target/harness SHAs and remaining batches. If limits interrupt work, save and push completed documentation/harness within then-authorized scope; never imply unfinished test coverage passed.

## This design session: remaining work

All four requested design documents are complete. Tests and workflows are intentionally unimplemented. Next session starts Batch 0; remaining work is product decisions, pinned-upstream drift review, all seven implementation batches after the baseline batch, execution/timing measurement and device infrastructure setup. No current runtime or deployment claims are made.
