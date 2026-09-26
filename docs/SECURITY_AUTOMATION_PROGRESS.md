# Current security analysis — 2026-09-26

Authoritative reviewed evidence: [run 36228675577](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36228675577), executed source `91d237294625288bd7f304871a4df3a9ea50fcdd`: **352/352 executed, 312 passed, 40 observations, infrastructure healthy**. This supersedes the execution summaries below.

Read [prioritized findings and every observation disposition](SECURITY_FINDINGS_2026-09-26.md), [per-case reviewed JSON](security-evidence/36228675577/reviewed-observations.json), [current generated API coverage](security-evidence/36228675577/security-api-coverage-report.md), then [Terra next-phase plan](SECURITY_TERRA_NEXT_PHASE.md).

- All 40 classified: **25 confirmed-security cases / nine roots; eight hardening; three incorrect expectations (168/171/218); three fixture/test defects (219/220/221); one unresolved local-media integration contract (323)**. All IDs retain VOCLE prefix. Raw reports are preserved unchanged.
- Nine roots: foreign thread binding, foreign handoff channel binding, channel member metadata access, draft handoff visibility, private-channel detail, local media deletion ownership, unauthorized typing, private-message personal-room fan-out and stale channel rooms after membership removal. Null socket HTTP status is intentional; all nine socket observations have successful controls and unauthorized packets.
- Separate **P0 source finding**: public verify-msg91-token flow trusts locally decoded JWT phone without signature verification when MSG91 key is present. No HTTP exploit executed here; prioritize isolated dummy-key/outbound-blocked route confirmation, never provider/production traffic.
- Fresh accepted-request DMs 169/242 now pass. 168 is current privacy denial, not an unresolved 500; 171 is intentional self notes. Request lifecycle fixtures 219–221 lack target opt-in and never reach their intended branches. Old 109/111 and 321/322 observations now pass; 110/112 remain PUT coercion hardening.
- **46/77 exact HTTP operations exercised (59.7%); 31 uncovered**, not old 46/73. New higher-risk uncovered surfaces include widget authentication, Needl private previews, group-DM consent, handoff notes/reassign, plus profile/lookup and membership lifecycle.

## Exact next step for a fresh chat / Terra

On origin/master, read AGENTS.md and the linked review/plan. Implement **Phase 0 test meaning/evidence repairs first**, preserving all 352 registration positions and historical artifacts; strengthen opt-in setup/restoration and socket reporting. Then implement the bounded **Phase 1 authentication/session batch**, prioritizing the source widget bypass, request-otp/verify-otp, refresh and logout. Append new IDs after VOCLE-352. Use a separately supervised local process with OTP_BYPASS=false for real OTP model lifecycle and explicit rate-limiter isolation. Do not claim bypass-code tests cover expiry/replay.

Next batches: user/profile/lookup + Needl, space create/invite/preview/join/leave + consent, then remaining HTTP/realtime breadth. No large new suite, application remediation or workflow modification was performed in this analysis. No new backend execution is claimed. Static review reconciled every observation and route count; original suite remains unchanged.

## Evidence and isolation

Latest artifact 10902250861; archive SHA-256 `426f3b07591df5322af245112ef7930e4755d8060be4cb3b2f097941953b4fe3`; preserved results SHA-256 `83e127476cc94a4ac538ec23216b04b7665f6cf03a7b0249053490ec22250037`. Four original reports and reviewed JSON live in `docs/security-evidence/36228675577/`.

Only experimental origin Sriram4747/medcollab-beta-workflows master; never write upstream. Preserve unrelated Flutter/Android changes. Real Express/Mongoose + loopback MongoDB 7 vocle_ci, test identities/signing keys; no production/Atlas/Railway, SMS/MSG91/FCM/Cloudinary calls. Tokens/raw bodies never enter artifacts. Missing controls, isolation/fixture/auth/transport failures block; observations remain non-gating. Manual work uses only local fixture accounts and inert media. Detailed manual priorities and source-versus-executed limits are in findings.

---

## Historical execution and continuity (superseded)

# Current execution — 2026-09-26

The [expanded implementation and evidence report](SECURITY_EXPANSION_2026-09-26.md) supersedes the historical counts and pending-execution notes below. Final isolated [run 36225164443](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36225164443), source 63bb75df3f05e150ef444e96a186528d0f9a6143: **352/352 executed, 311 passed, 41 observations, infrastructure healthy**. Three observations remain inconclusive fresh-DM failures; none of the 352 is unexecuted.

Added 109 meaningful cases: Extended API 49, Media 31, Realtime 21 and Cross-module 8. The original 243 cases retain 230 passes and 13 observations. Exact-route execution increased from 32/73 to **46/73**; see the [generated coverage map](security-evidence/36225164443/security-api-coverage-report.md). Coverage remains partial, not whole-route assurance.

Six newly confirmed roots: draft handoff visibility, private-channel detail authorization, local-media canonical ownership, typing room authorization, private-message personal-room fan-out and stale channel-room revocation. Existing foreign-thread binding and member-list authorization gained additional evidence; all three previously confirmed roots are preserved. [Reviewed classifications](security-evidence/36225164443/reviewed-observations.json) distinguish security defects, hardening, expected behavior and inconclusive results. No application remediation occurred; no workflow YAML change was required.

Media and realtime manifests below/linked remain broader than implemented coverage. Recovery replay, crash-prone malformed socket payloads, live Cloudinary behavior and other explicit limitations are listed in the current report. Do not treat the historical planned manifests as executed in full.

---

## Historical continuity material
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
