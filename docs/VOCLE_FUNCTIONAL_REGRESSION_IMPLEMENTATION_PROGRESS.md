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

- **Status:** in progress; 25 new backend cases implemented and executed. Do not treat this as completed Batch 2 or backend-all coverage.
- **Implemented new testcase IDs:** `FR-AUTH-01` through `FR-AUTH-07`, `FR-PRO-01`, `FR-PRO-02`, `FR-PRO-03`, `FR-DISC-01`, `FR-DISC-02`, `FR-SPC-01`, `FR-SPC-02`, `FR-SPC-03`, `FR-SPC-04`, `FR-SPC-05`, `FR-CH-01`, `FR-CH-02`, `FR-CH-03`, `FR-CH-04`, `FR-REQ-01`, `FR-REQ-02`, `FR-DM-01`, `FR-DM-02`. Each has executable behavioral assertions. `FR-SPC-03` verifies safe pending-join subassertions, then reports Q14 `NEEDS_DECISION`. `FR-REQ-02` and the pair branch of `FR-DM-01` explicitly model-seed accepted-request prerequisites; neither credits the broken accept endpoint.
- **Execution on pinned upstream SHA:** these 25 new cases PASS 23, FAIL 1, NEEDS_DECISION 1, ERROR 0, BLOCKED 0. Original unchanged 48 sanity cases: PASS 42, FAIL 2, BLOCKED 4, ERROR 0. Combined selected 73: PASS 65, FAIL 3, BLOCKED 4, NEEDS_DECISION 1. Remaining 114 catalog cases have not been implemented and are not counted as SKIP/pass evidence. Source tree remained clean after test execution.
- **Genuine application failures:** `message-requests-01` lacks the recipient notification because `MessageRequest` is invalid for the notification `referenceType` enum; `message-requests-02` returns HTTP 500 when accepting because MongoDB cannot infer the twice-matched `members` path in the DM upsert. This blocks `direct-and-group-conversations-01/-02/-03/-05`. `FR-DM-01` consistently times out on the one-peer `/api/channels/dm/group` delegation path after its accepted prerequisite is seeded. These are failures on the pinned upstream SHA and remain gates. No application source or oracle was changed.
- **Infrastructure issues/fixes:** corrected the local harness's MongoDB name to meet its 63-character limit; corrected expected response paths/statuses for independent space and group-DM assertions; kept seeded component prerequisites explicit. Request/conversation cases now compare their own records and baseline counts so another case's setup cannot create a false failure. The first local FR-REQ-02 attempt exposed the upstream accept defect and was replaced with an independent component fixture, with the defect retained in unchanged sanity results. New authentication boundary cases are run in separate disposable backend/MongoDB instances because the application's shared auth limiter otherwise lets earlier cases consume a later case's quota. The test-owned MSG91 fake now supports synthetic timeout, rejection, invalid widget token, mismatch and provider-failure paths; the original sanity lane was rerun after this change.
- **Source SHA tested:** upstream master `da2baff621fe03b21e614965bdb77510f32a62b9`, fetched read-only and executed from an ignored detached local checkout. The fork checkout was also used for focused harness development; it is not upstream validation.
- **Harness SHA at execution:** committed base `6b14df1df69642015b2948cacd6e4de7e421e6b3` plus uncommitted Batch 2 additions; exact content SHA-256 is in the 25-case checkpoint JSON. After committing, rerun if a strictly committed harness SHA is required.
- **GitHub Actions run links:** none; dedicated workflow is Batch 5.
- **Structured evidence:** latest [JSON](functional-regression-evidence/upstream-da2baff-batch2-checkpoint-25.json) and [summary](functional-regression-evidence/upstream-da2baff-batch2-checkpoint-25.md); the previous [20-case JSON](functional-regression-evidence/upstream-da2baff-batch2-checkpoint.json) is retained. Detailed local JSON/JUnit/Markdown/coverage/provenance/cleanup outputs remain under ignored `tests/functional-regression/output/`.
- **Files changed:** `tests/functional-regression/src/{config,db,fixtures,runner,module-runner,run-batch2-subset}.mjs`, `suites/{auth,profile,discovery,spaces,channels,requests,conversations}.mjs`, `providers/preload.cjs`, `scripts/aggregate-checkpoint.mjs`, `package.json`, evidence files, decision ledger and this progress document.
- **Commit hashes:** partial checkpoints `b6734f5`, `61bf06e`, `c371890`, `a0b9a01`, documentation checkpoint `6b14df1`, and 25-case checkpoint `8496eb1` pushed to `origin/master`.
- **Remaining work:** complete the other Batch 2 catalog cases before Batches 3–7. Q1–Q14 remain unresolved. No dedicated workflow, Flutter cases, or device cases have been implemented.
- **Exact next action:** add the remaining Batch 2 AUTH/PRO/DISC/SPC/CH/REQ/DM behavioral cases, starting with request acceptance and recovery, while preserving the confirmed upstream failures; rerun the expanded module subset on the pinned SHA.

## Batch 3 — communication and realtime

- **Status:** not started.

## Batch 4 — handoffs, media and recovery

- **Status:** not started.

## Batch 5 — dedicated GitHub Actions workflow

- **Status:** not started.

## Batch 6 — Flutter functional regression

- **Status:** not started.

## Batch 7 — device and release

- **Status:** not started.
