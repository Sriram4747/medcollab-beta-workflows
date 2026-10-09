# Vocle functional regression implementation progress

This file records implementation and execution separately. The 187 catalog rows are specifications; registry validation is not case execution. Upstream is read-only. Unrelated Flutter/Android working-tree modifications and `docs/VOCLE_PRODUCT_UNDERSTANDING.md` are excluded from commits.

## Batch 0 — freeze evidence and expected behavior

- **Status:** complete; catalog registry and validator implemented, source drift and Q1–Q14 recorded.
- **Implemented testcase IDs:** no new executable test cases in this batch. The 48 retained sanity cases remain implemented in `tests/sanity` unchanged; none was rerun here.
- **Catalog validation:** 187 unique IDs, 48 retained, 139 new; B/F/D = 147/32/8; P0/P1/P2 = 96/81/10. Module assignments and dependency/reference IDs validated. `catalog-validation.json` records PASS for registry integrity only.
- **Functional execution:** PASS 0, FAIL 0, BLOCKED 0, NEEDS_DECISION 0, ERROR 0, SKIP 187 (not selected for Batch 0). This is not a functional result and is not full-suite success.
- **Infrastructure issues/fixes:** sandbox DNS/thread failure on the first read-only upstream fetch; escalated read-only fetch succeeded. No production or provider infrastructure accessed.
- **Source SHA tested/reviewed:** upstream master `da2baff621fe03b21e614965bdb77510f32a62b9`, fetched 9 October 2026. Planning source baseline `a4340b3da1aa628a9722622bd42a7903c33df45c` differs; drift documented in the decision ledger.
- **Harness SHA:** pending Batch 0 commit; previous fork HEAD `7218d29300ab7f5fe455f88b0683565e4544fe0d`.
- **GitHub Actions run links:** none; dedicated workflow is Batch 5.
- **Files changed:** `tests/functional-regression/catalog.json`, `catalog-validation.json`, `scripts/catalog-source.mjs`, `scripts/write-catalog.mjs`, `scripts/validate-catalog.mjs`, `contracts/decisions.md`, this progress document.
- **Commit hash:** `0c64a9b22ddea028ecee4cd31b6a76586473a293` (pushed to `origin/master`).
- **Remaining work:** Batches 1–7. All Q1–Q14 remain open pending an authorized product decision. Historical sanity failures are only evidence for the older SHA and require rerun.
- **Exact next action:** implement and deliberately validate the isolated harness status classifier and report writer, then execute the unchanged sanity lane against an isolated target.

## Batch 1 — isolated harness

- **Status:** complete for local isolated execution and original sanity adapter. CI container isolation remains Batch 5 work.
- **Implemented testcase IDs:** no new catalog cases; all 48 original sanity implementations were invoked unchanged. Harness-only classification and smoke IDs are not added to the 187-case catalog.
- **Execution:** original sanity lane on the fork checkout: PASS 48, FAIL 0, BLOCKED 0, NEEDS_DECISION 0, ERROR 0, SKIP 0. This is **retained-sanity-48** evidence only, not backend-all or upstream validation. Real backend/Mongo smoke: PASS 1 harness case. Classification self-check deliberately produced PASS, FAIL, ERROR, BLOCKED, NEEDS_DECISION and SKIP outcomes; its report is deliberately non-success.
- **Infrastructure issues/fixes:** no Docker/system MongoDB on this machine; `mongodb-memory-server` downloaded MongoDB 7.0.14 into ignored workspace output after network escalation. Sandbox execution caused MongoDB startup failure; unrestricted local execution succeeded. Original sanity adapter initially omitted `API_BASE_URL`, causing media-01 to fail and media-02/-03 to block; adding the existing workflow's loopback API origin restored 48/48. No assertion or application source was changed. Unchanged sanity dependencies installed from its lockfile.
- **Source SHA tested:** local fork `0c64a9b22ddea028ecee4cd31b6a76586473a293`. The latest fetched upstream `da2baff621fe03b21e614965bdb77510f32a62b9` has **not** been exercised by this local run.
- **Harness SHA:** pre-Batch-1 checkout `0c64a9b22ddea028ecee4cd31b6a76586473a293`; Batch 1 changes were uncommitted during execution.
- **GitHub Actions run links:** none; dedicated workflow is Batch 5.
- **Files changed:** `tests/functional-regression/package.json`, `package-lock.json`, `.gitignore`, `src/{config,http,db,socket,fixtures,runner,reporting,sanity-adapter}.mjs`, `providers/preload.cjs`, this progress document.
- **Structured evidence:** ignored local output at `tests/functional-regression/output/sanity-adapted-12d824df-2af7-4f2a-817e-be233a273725/` contains JSON, JUnit, Markdown, coverage, provenance and cleanup. The unmodified runner's original report is at the matching `sanity-original-...` directory. These local paths are not durable hosted artifacts.
- **Commit hash:** `4591ee5ba229ae53f4941cf8e4e7cdb00ab85171` (pushed to `origin/master`).
- **Remaining work:** Batches 2–7; 139 new catalog cases unimplemented; Q1–Q14 undecided.
- **Exact next action:** implement Batch 2 backend cases using the isolated module fixture/process pattern, beginning with authentication and profiles; execute focused cases against the pinned source and preserve genuine failures.

## Batch 2 — identity and community

- **Status:** implementation complete for the exact 40 new Batch 2 backend IDs. Execution is complete on the pinned upstream SHA and remains red/undecided; this is not backend-all coverage or success.
- **Implemented new testcase IDs:** `FR-AUTH-01`–`07`, `FR-PRO-01`–`04`, `FR-DISC-01`–`04`, `FR-SPC-01`–`06`, `FR-CH-01`–`05`, `FR-REQ-01`–`05`, `FR-DM-01`–`09`. The aggregate validator requires this exact set. All 48 original sanity IDs remain unchanged. Every new case has executable behavioral assertions. Seeded prerequisites are disclosed per case and do not credit broken journey steps.
- **Execution on pinned upstream SHA:** 40 new cases PASS 31, FAIL 4, NEEDS_DECISION 5, ERROR 0, BLOCKED 0. Original unchanged 48 sanity cases: PASS 42, FAIL 2, BLOCKED 4, ERROR 0. Combined selected 88: PASS 73, FAIL 6, BLOCKED 4, NEEDS_DECISION 5, ERROR 0. Remaining 99 catalog cases have not been implemented and are not counted as SKIP/pass evidence. All module cleanup and provenance records passed; source tree remained clean.
- **Genuine application failures:** `message-requests-01` lacks its recipient notification because `MessageRequest` is invalid for the notification `referenceType` enum. `message-requests-02` and `FR-REQ-04` return HTTP 500 during acceptance because MongoDB cannot infer the twice-matched `members` path; `FR-REQ-04` verifies the persisted accepted-without-DM split. Four retained direct-conversation sanity cases are blocked by that failure. `FR-DM-01` times out on one-peer group delegation; live `POST /api/channels/dm` also returns HTTP 500. `FR-SPC-06` proves explicit room sync leaves two removed users receiving a correlated space event, although reconnect revokes access. `FR-DM-09` records two duplicate exact-membership group channels under concurrent requests and HTTP 500 on concurrent pair intents. These remain failures on the pinned upstream SHA; no application source or oracle was changed.
- **Infrastructure issues/fixes:** corrected the local harness's MongoDB name to meet its 63-character limit; corrected expected response paths/statuses for independent space and group-DM assertions; kept seeded component prerequisites explicit. Authentication, request, space and conversation cases use separate disposable backends/databases where limiter, relationship or membership state would interfere. The test-owned MSG91 fake supports synthetic timeout, rejection, invalid widget token, mismatch and provider-failure paths; the original sanity lane was rerun after that change. The profile fixture was shortened to its schema limit and its space-member assertion uses the actual API projection. Discovery limit fixtures are synthetic users inserted only into disposable MongoDB. Socket.IO clients now load from the retained sanity test dependency. `FR-REQ-05` uses a one-shot MongoDB `findAndModify` failpoint in its disposable process; no fault configuration is shared with other cases. Initial fixture/response-shape failures were repaired without weakening application oracles.
- **Source SHA tested:** upstream master `da2baff621fe03b21e614965bdb77510f32a62b9`, fetched read-only and executed from an ignored detached local checkout. The fork checkout was used only for focused harness development.
- **Harness SHA at execution:** both retained sanity and new-case modules used committed base `52307b5d9e02a3c024a5252d10c1a15cb3c33a1f` plus uncommitted Batch 2 additions. The exact current harness content SHA-256 is in the 40-case checkpoint JSON. The committed code may be rerun if a strictly committed harness SHA is required.
- **GitHub Actions run links:** none; dedicated workflow is Batch 5.
- **Structured evidence:** latest [JSON](functional-regression-evidence/upstream-da2baff-batch2-checkpoint-40.json) and [summary](functional-regression-evidence/upstream-da2baff-batch2-checkpoint-40.md); previous partial checkpoints retained. Local module JSON/JUnit/Markdown/coverage/provenance/cleanup outputs remain under ignored `tests/functional-regression/output/`.
- **Files changed:** `tests/functional-regression/src/{config,db,fixtures,runner,module-runner,run-batch2-subset,socket}.mjs`, `suites/{auth,profile,discovery,spaces,channels,requests,conversations}.mjs`, `providers/preload.cjs`, `scripts/aggregate-checkpoint.mjs`, `package.json`, evidence files, decision ledger and this progress document.
- **Commit hashes:** earlier partial checkpoints through `55f1c6c`, documentation checkpoint `52307b5`, and full Batch 2 implementation checkpoint `e3419f3` pushed to `origin/master`.
- **Remaining work:** Batches 3–7; 99 catalog cases unimplemented, including 59 backend, 32 Flutter and 8 device. Q1–Q14 remain unresolved; Q2/Q7/Q10/Q14 have observed subassertions or defects but no product approval. No dedicated workflow, Flutter cases, or device cases have been implemented.
- **Exact next action:** implement Batch 3 backend communication/realtime cases beginning with root messaging, threads and lifecycle assertions on the pinned upstream SHA; preserve all Batch 2 failures and undecided results.

## Batch 3 — communication and realtime

- **Status:** in progress. Root messaging submodule implemented and executed; the other 25 new Batch 3 backend cases have not been implemented. Batch 3 is **not complete**.
- **Implemented testcase IDs this checkpoint:** `FR-MSG-01`–`FR-MSG-08` with executable assertions. Combined implementation so far is 96 backend cases: 48 unchanged sanity, 40 new Batch 2 and 8 new Batch 3. Flutter 0; device 0. Registry remains 187 unique, 48 retained, 139 new, and 147/32/8 by tier.
- **Focused execution:** pinned upstream message subset of 8: PASS 5 (`FR-MSG-02`, `03`, `04`, `06`, `07`), FAIL 1 (`FR-MSG-01`), NEEDS_DECISION 2 (`FR-MSG-05`, `08`), BLOCKED 0, ERROR 0, SKIP 0. This subset is separate from prior Batch 2 evidence and does not claim that all 96 implemented cases were rerun at this checkpoint.
- **Genuine application failure:** `FR-MSG-01` returns HTTP 400 for whitespace-padded 4,000-character text after the route checks the trimmed length; the model validates the untrimmed 4,004 characters. Valid exact 4,000-character and Unicode/newline messages passed before this final boundary assertion. No application source or expected outcome was changed.
- **Pending decisions:** Q1 for edit/delete propagation to quote snapshots and channel previews; Q7 for duplicate prevention after a committed send loses its client response. `FR-MSG-05` and `08` record safe, independently verified persistence and recovery behavior while these assertions remain undecided. Q2–Q14 otherwise retain their ledger status.
- **Infrastructure issues/fixes:** initial `FR-MSG-06` harness assertion incorrectly expected soft-deleted messages in root GET pages. Source contracts filter them out; the case now verifies omission from pages and the deletion placeholder/media/reaction clearing in MongoDB, without changing an application oracle. Local reverse proxy for `FR-MSG-08` consumes backend HTTP 201 and deliberately drops only the synthetic client response. No external service was called.
- **Source SHA tested:** read-only detached upstream `da2baff621fe03b21e614965bdb77510f32a62b9`.
- **Harness SHA at execution:** committed base `555cb8db250ee6a1c62dd66990bc09fe18856c71` plus this checkpoint's source changes. Exact checkpoint harness content SHA-256 `5314e43176787b200c3d142358757dee47f871f1f753a89b73d191cd993d8683` is in the structured report.
- **GitHub Actions run links:** none; dedicated workflow remains Batch 5 work.
- **Structured evidence:** [JSON](functional-regression-evidence/upstream-da2baff-batch3-messages-checkpoint-8.json) and [summary](functional-regression-evidence/upstream-da2baff-batch3-messages-checkpoint-8.md); per-case JSON/JUnit/Markdown/coverage/provenance/cleanup under ignored local output. The aggregate checks exact eight IDs, target SHA, cleanup and provenance; it cannot be used as full backend success.
- **Files changed:** `tests/functional-regression/suites/messages.mjs`, `scripts/aggregate-batch3-messages.mjs`, decision ledger, two evidence files and this progress document.
- **Commit hash:** `31866cc` (root messaging checkpoint; pushed to `origin/master` with this documentation update).
- **Remaining work:** 91 catalog cases unimplemented: 51 backend (25 remaining Batch 3 plus Batch 4), 32 Flutter and 8 device. Batches 4–7 remain not started. Batch 2 and Batch 3 red/undecided outcomes remain open.
- **Exact next action:** implement `FR-THR-01`–`04` thread/Needl behavior against the pinned upstream, then the social, notification, push, realtime and search cases in Batch 3; run focused modules and update the aggregate checkpoint.

## Batch 4 — handoffs, media and recovery

- **Status:** not started.

## Batch 5 — dedicated GitHub Actions workflow

- **Status:** not started.

## Batch 6 — Flutter functional regression

- **Status:** not started.

## Batch 7 — device and release

- **Status:** not started.
