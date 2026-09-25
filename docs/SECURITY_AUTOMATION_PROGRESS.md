# Vocle security automation continuity

Updated 2026-09-25 after the completed 243-case milestone. Read AGENTS.md first.

## Current evidence

Source a0b1f722160b0a8df94780d10ebc3c1dca46d45a; successful backend workflow run 36168079327. **243 executed, 230 passed, 13 observations; infrastructure healthy.** Baseline 139/146, DM 56/61, requests 35/36. Reviewed results are retained in docs/security-evidence/36168079327/results.json, SHA-256 71f82996e27152cac7c0d68e10e62cdcc741d7bfe096f0ec4585b86f1ed3b9fc. This research batch reviewed the hosted execution, not a new API run.

- Confirmed roots: foreign reply binding (094/098 and DM 193/197), foreign handoff channel binding (099), newly confirmed missing DM member-list authorization (159).
- Four text coercion observations (109–112) remain hardening, not proven exploits.
- Three positive fresh-DM failures (168/169/242) return 500; common creation/upsert path is an investigation lead, exact cause UNKNOWN. Keep assertions and observations. Successful request acceptance does not establish successful fresh-DM creation.
- Corrected absent-ID case 137 actually passed with 404. Historical eight-observation review remains preserved.
- Exact-route discovery coverage is 32/73, not comprehensive security coverage. DM and message-request execution is no longer pending. No media or socket security suite has run.

## Read next

1. [Current consolidated evidence review, attack paths and roadmap](SECURITY_RESEARCH_BATCH_2026-09-25.md).
2. [Current route-level coverage map](SECURITY_TEST_COVERAGE.md), including explicitly historical earlier notes.
3. [Media implementation manifest](SECURITY_MEDIA_MANIFEST.md).
4. [Realtime implementation manifest](SECURITY_REALTIME_MANIFEST.md).
5. [Preserved baseline observation analysis](SECURITY_OBSERVATION_REVIEW.md).

Next implementation: improve 159 response identity evidence and sanitized fresh-DM failure diagnostics; then prioritize realtime private-channel fan-out/typing/stale rooms and local media ownership/path containment. Manifests contain payload families, actors, controls, invariants, prerequisites and limits. Do not classify source-only attack chains as executed vulnerabilities.

## Suite quality hardening after the reviewed run

The bounded [suite quality review](SECURITY_SUITE_QUALITY_REVIEW_2026-09-25.md)
keeps 243 cases while adding settled side-effect snapshots, notification cleanup
and mutation tracking, exact reset checks, denial-payload checks, unique case names,
persisted success assertions, replay counts and explicit parent/child binding
checks. Historical run 36168079327 predates these stronger assertions. Do not quote
new pass/observation totals until the hardened suite completes in isolated CI.

## Architecture and safety

- Current branch master, experimental origin Sriram4747/medcollab-beta-workflows only. Never write upstream mathiharan29/medcollab-beta, change its URL, or reuse design/clinical-design-system. Preserve unrelated Flutter/Android worktree changes.
- Single backend pipeline .github/workflows/vocle-backend-environment-test.yml; manual dispatch, Node 22, Docker MongoDB 7 bound to loopback; actual Express/Mongoose. The separate security-environment workflow only checks tool readiness.
- Exact loopback API, NODE_ENV=test, local vocle_ci database. No production/Atlas/Railway, real users, SMS/MSG91/FCM or Cloudinary security traffic. Cloudinary hosted behavior intentionally deferred, not mocked.
- A–I deterministic identities, real test-only verify-otp authentication, target-only inactive I. Suites run sequentially with per-case reset. Never log/upload raw tokens or credentials.
- Four sanitized reports: results.json, summary.md, security-test-report.md, security-api-coverage-report.md; artifact vocle-security-discovery retains seven days. The reviewed JSON is preserved for continuity past expiration.
- Infrastructure/auth/fixture/transport errors block; discovery observations currently do not. Do not weaken assertions, silently convert observations to passes or change application code. Application remediation is separate.
- Existing snapshots do not prove completed asynchronous effects, media state, all user/notification changes or socket delivery. Add precise checks for those new phases and settle effects before fixture reset.
- This workstation's previous baseline had no Docker/mongod/mongosh; use existing isolated Actions when execution is required, never in-memory substitutes. This batch performed only local manifest/report/evidence checks.
