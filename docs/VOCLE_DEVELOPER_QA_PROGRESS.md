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
