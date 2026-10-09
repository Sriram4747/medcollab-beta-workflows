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
- **Commit hash:** pending checkpoint commit; record in the next progress update.
- **Remaining work:** Batches 2–7; 139 new catalog cases unimplemented; Q1–Q14 undecided.
- **Exact next action:** implement Batch 2 backend cases using the isolated module fixture/process pattern, beginning with authentication and profiles; execute focused cases against the pinned source and preserve genuine failures.

## Batch 2 — identity and community

- **Status:** not started.

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
