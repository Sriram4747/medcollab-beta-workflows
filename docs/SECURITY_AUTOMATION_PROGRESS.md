# Current phase: initial hardening closure and remediation handoff — 2026-10-06

Focused disposable MongoDB [run 37359326520](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37359326520), source `15691c18149f93337f7b73a0835a952d29dc8d37`: **31/31 executed,22 passes/nine observations, healthy infrastructure;31/31 exact synthetic cleanups, zero residue**. New **VOCLE-786–816**, combined registered catalog816. [Source review/findings/Atlas checklist](SECURITY_MONGODB_HARDENING_2026-10-06.md), [raw execution/hashes](security-evidence/37359326520/execution.json). App source fingerprint unchanged. No general691/offline97/live34 rerun or new HTTP coverage credit.

One new confirmed deletion-integrity root: **VOCLE-805**, editing a deleted message repopulates persisted text while deletion flags remain. Eight other model/validation/retention/lifecycle observations remain non-gating; no new route credential leak, HTTP request race, foreign-key exploit or provider push is claimed. Actual strict persistence, mass assignment, projections, operator-shaped input, ObjectId handling, unique indexes, atomic DM upserts, OTP hashing/expiry/sequential lifecycle, TTL configuration, owner binding and live HTTP account state controls pass.

[Final Cloudinary hardening](SECURITY_CLOUDINARY_HARDENING_2026-10-06.md) closes deterministic review without new provider requests: immediate cached delivery already byte-proven by37355451614 matches provider documentation. Global invalidation deadline, signed/derived cache configuration, access policy and backup erasure require owner attestation; no destructive/account tests or elevated credentials. Approved TEST allowlist/broker/janitor remain unchanged.

[Consolidated registry](SECURITY_REGRESSION_GATES.md): **124 reviewed unique observed IDs;62 after-remediation candidates (53 security/nine functional-provider contracts),62 excluded;zero active application gates**. Every entry states requirement, actual behavior, expected secure behavior, fix/eligibility and evidence sources. [Practical release checklist](RELEASE_SECURITY_CHECKLIST.md) separates relevant-change automation, periodic/pre-release work and account controls; it accurately notes manual workflows, upstream-targeted functional sanity and absent dependency/strict application gating. Next: developer fixes and policy/account attestation, then audited focused rerun and explicit gate promotion. Do not restart completed discovery or automatically block all observations.

Only origin/master written; no application fixes, production services/Atlas/Cloudinary/real users/upstream access or writes, and no unrelated Flutter/Android changes included. Remaining mobile/provider/deployment, long-duration/multi-instance/concurrency/partial-failure and policy limits are documented in the data review.

---

# Previous phase: real Cloudinary integration validated — 2026-10-05

[Final run 37355451614](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37355451614), source `a3432300d3827bb0f5eca1a1a2033ec48929707b`: **34/34 executed, 25 passes/nine observations, healthy infrastructure**. New **VOCLE-752–785**, combined registered catalog 785. Approved separate TEST cloud only; positive independent variable match before SDK/provider operations; synthetic image/video/raw uploads and scoped exact cleanup. **13/13 recorded origins absent** in finally AND post-job cleanup, zero pending intents, secret hygiene/artifact upload passed. [Raw evidence/review/hashes](security-evidence/37355451614/execution.json), [full findings and limits](SECURITY_CLOUDINARY_INTEGRATION_2026-10-05.md).

Real image/video delivery/transforms and raw PDF originals work. Plain raw attachment and correctly typed image-PDF preview controls work; app named raw attachment400 and raw→image preview404. Video/handoff deletion and octet MIME dispatch limitations confirmed; image/video/raw original CDN bytes can survive non-invalidating origin deletion. Duplicate/generated IDs, different-byte overwrite false/true, typed ID separation and exact namespace checks pass. No app fix or gate activation; account roles/retention, confidential retrieval policy and eventual invalidation remain unverified. General 691/offline 97 not rerun; historical77/77 HTTP evidence retained, no new route credit.

First healthy run 37354536880: 34/34, 24/10,12/12 origins absent; all raw evidence preserved. Only781 changes status in final run after correcting a filename-dot substring false positive; all nine genuine observations persist. Final harness also strengthens byte-level overwrite/PDF controls. No production Cloudinary, other production service, upstream write or unrelated Flutter/Android change.

---

# Historical enablement blocker (resolved) — 2026-10-05

Source `14eb050e2a6af98569ea1b8fd34d75fdfabc03fc` pushed to origin/master; manual workflow registered. Post-push GitHub checks confirm **`CLOUDINARY_TEST_CLOUD_NAME` missing (zero repository variables)** and all three required secret names present. Stopped before dispatch: **no hosted run, zero Cloudinary requests/resources/live cases, no cleanup needed**. Configure the independent variable using [exact instructions](SECURITY_CLOUDINARY_INTEGRATION_2026-10-05.md), then resume hosted execution/review. [Blocked-execution metadata](security-evidence/cloudinary-blocked-2026-10-05/execution.json). Upstream/app source/Flutter-Android untouched.

Separately manual, fail-closed real-provider lane implemented: **34 registered cases, VOCLE-752–785; combined catalog 785**. No live execution credited yet. Independent `CLOUDINARY_TEST_CLOUD_NAME` equality is mandatory before SDK/provider use; missing/mismatched config blocks. Synthetic run namespace, broker egress/identity checks, durable exact-resource manifest, finally plus post-job image/video/raw cleanup, origin verification and sanitized artifacts. Local syntax/frozen manifests, 49 offline safety checks and real-SDK/controller offline roundtrip (77 intercepted requests; zero I/O) pass. No general suite rerun/application fix. Read [implementation/safety/enablement](SECURITY_CLOUDINARY_INTEGRATION_2026-10-05.md). Post-push allowlist check confirms the variable is missing; hosted evidence blocked; do not infer provider behavior from offline checks.

---

# Previous phase: offline media/storage and SDK contracts — 2026-10-04

Stages 1 and 2 complete in hosted [run 37181051425](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37181051425), source `dca95d019fddf792adae7fcd4c21b5bc649c2b30`: **97/97 executed, 62 passes, 35 observations; healthy infrastructure**. Dedicated suite selects 37 existing media/cross-module cases and appends **26 local cases (692–717)** plus **34 offline SDK contracts (718–751)**. Existing 37 expectations/status/outcomes match baseline. Combined catalog **751**; the general 691-case suite was not rerun and its 611/80, 77/77 HTTP evidence remains historical. New 60: **34 passes / 26 observations**. Historical baseline plus new cases: 645/106, explicitly not a single 751-case fresh run.

Read [implementation, reviewed findings, limits and Stage 3 handoff](SECURITY_MEDIA_OFFLINE_2026-10-04.md), [final raw evidence](security-evidence/37181051425/results.json), [reviewed observations](security-evidence/37181051425/reviewed-observations.json) and [execution/hash metadata](security-evidence/37181051425/execution.json). Both healthy runs and the initial pre-case FFmpeg failure are documented; original historical evidence is retained. Avatar traversal confirms an existing local S6 variant. Octet-PDF/video request image, deletion never dispatches video, handoff uploads fail owner deletion, and reference/lifecycle/metadata gaps are recorded. No application fix or strict gate activation.

Zero real Cloudinary account/credentials/requests: SDK replaced before app imports, exact calls recorded, predicate override confined to harness; hosted Docker network-none, loopback-only guards and credential rejection. All 97 safety/cleanup records and identical source fingerprints verified. Stage 3 remains unimplemented. Next separately authorized integration must independently clean returned image/raw/video/handoff assets and verify real decoding, IDs, PDF previews, delivery/cache/account policy. Upstream, production and unrelated Flutter/Android changes untouched.

---

# Previous phase: Cloudinary and media/storage design — 2026-10-04

Inspection/design complete in [the implementation handoff](SECURITY_CLOUDINARY_MEDIA_DESIGN_2026-10-04.md). Next implement the offline media safety/SDK-contract harness and focused local lifecycle cases; do not repeat generic API discovery or request provider credentials yet. The plan separates local boundary evidence, simulated SDK call contracts, dedicated non-production provider behavior and configuration attestations, with scenario oracles, future gate eligibility, production isolation and failure cleanup.

Verified baseline remains **691/691 executed, 611 passes, 80 observations, healthy infrastructure; 77/77 HTTP operations exercised**. Existing Media module: **31 cases, 22 passes, nine observations**, plus six passing adjacent cross-module cases. Production Cloudinary remains disabled/untouched by security testing. This documentation-only phase adds no executed cases and fixes no application vulnerability. Actual production Cloudinary configuration remains unknown. Preserve the historical evidence below and unrelated Flutter/Android worktree changes.

---

# Current defensive regression expansion — 2026-10-04

[run 37175207493](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37175207493), executed source `e89f8848fee4c21f3de91e31469ae61837f13bd8`: **691/691 executed, 611 passes, 80 observations; infrastructure healthy.** Exact HTTP operations exercised: **77/77 (100%)**. These are bounded route contexts, not complete security assurance.

Added **65 cases (VOCLE-627–691)**: 22 developer/platform HTTP, 32 realtime lifecycle, six cross-module lifecycle and five optional auth hardening cases. All previous 626 IDs/expectations/results remain intact (566 passes, 60 observations); the 626 manifest is pinned. See [expansion details](SECURITY_DEFENSIVE_REGRESSION_2026-10-04.md), [actual route map](security-evidence/37175207493/security-api-coverage-report.md), [reviewed observations](security-evidence/37175207493/reviewed-observations.json) and [execution/hashes](security-evidence/37175207493/execution.json).

51 confirmed-case gate candidates and 29 excluded observations are mapped in [the registry](SECURITY_REGRESSION_GATES.md); zero strict gates are active. No application vulnerability was fixed. Six new confirmed roots cover established deactivation, revoked presence, stale DM typing cache, null synchronous handler crashes, recovery replay and concurrent OTP consumption. Existing stale channel-room and mention-preview findings gain realtime/cross-module evidence. Mid-session expiry remains policy; async null rejections and developer notification reference omissions remain hardening/reliability.

The remaining seven explicit HTTP operations now have meaningful coverage; none is intentionally uncovered. All 691 cases executed with healthy infrastructure. First expansion run 37174533620 is retained (610/81); the final run repairs the typing_stop name-field assumption, strengthens personal-room cache controls and records native platform response contracts accurately. Remaining provider/deployment, long-duration/adapter/load, richer socket metadata and recovery-listener/duplicate semantics are explicitly deferred. Application fixes and strict gate activation remain separate work. Only origin/master was written; upstream and application source were untouched.

---

# Current security expansion — 2026-10-04

Phase 2, Phase 3 and the bounded HTTP part of Phase 4 completed in hosted [run 37144805902](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37144805902), executed source `f559332b82783b7fee4341434e15c49ec25dc728`: **626/626 executed, 566 passed, 60 observations; infrastructure healthy**. Added **240 append-only cases**: 75 user/profile, 53 space lifecycle, 65 consent/handoff and 47 bounded HTTP. All original 386 retain 348 passes / 38 observations and their IDs/expectations; all 579 previous pass/observation outcomes match the first expansion run.

Exact HTTP operations exercised: **70/77 (90.9%)**, reflecting Phase 1 auth/session, all user/space operations, group DM, handoff notes/reassign, reactions and all support writes. Route hits are partial security coverage, and observations count as exercised. Seven explicit operations remain: three developer tools and GET /, /api, /join/:code, /health (health setup is intentionally outside credited discovery).

Read [reviewed findings](SECURITY_FINDINGS_2026-10-04.md), [per-observation reviewed JSON](security-evidence/37144805902/reviewed-observations.json), [generated route coverage](security-evidence/37144805902/security-api-coverage-report.md), [batch/module details](SECURITY_PHASES_2_3_2026-10-03.md), and [execution metadata/report hashes](security-evidence/37144805902/execution.json). The four raw reports are retained in `docs/security-evidence/37144805902/`. Artifact `11281218939`, archive SHA-256 `98f03261eba5528433f088747d3252975bd7dc812db141a19f7d56c6bd12cbe0`.

The **22 new observations** are eight confirmed confidentiality/authorization cases across three roots (Needl access/revocation, private pin/unpin, outsider/private mention previews), ten hardening/lifecycle cases (public preferences, search inference, unavailable targets, archive pins, inactive mention storage, malformed support input), and four consent/audit policy questions. Existing 38 observations, including two baseline semantic ambiguities, remain intact. No application vulnerability was fixed.

Both hosted runs had no setup, fixture/reset, startup, authentication or execution failure. Added synthetic-owned space/default-resource snapshot coverage, exact user-scoped SupportTicket cleanup/reset/snapshots, authorized/denied canary and identity persistence evidence, and CI syntax/append-only manifest checks. Local syntax/manifest checks and hosted checks pass. Phase 4 was added only after healthy Phase 2/3 execution. Raw historical report headings retain their legacy trailing-space names; evidence files are not rewritten for whitespace checks.

First expansion: [run 37144068281](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37144068281), source `afd22893cc581509f4775b112b4cc6d5fc4e7b17`, **579/579, 528 passes, 51 observations**, routes **66/77**. Its reports and review remain in `docs/security-evidence/37144068281/`; artifact `11281003418`, archive SHA-256 `588e40a9bb98a2904c2ef3cfba44876a6d1feb068e79aee47bafe87d81d4843a`.

Next: separately supervised developer-tool configuration guards, platform/deep-link cases, realtime recovery/revocation/expiry/deactivation/cache and crash supervision. Provider integrations remain disabled; approval/owner-transfer endpoints are not invented. Continue with real loopback Express/Mongoose and disposable local vocle_ci MongoDB only. Preserve all 626 VOCLE positions. Only origin/master was written; upstream and unrelated Flutter/Android changes were untouched. The final evidence commit changes documentation/reports only relative to the executed source above.

---

# Current security analysis — 2026-09-28

## Phase 1 authentication/session coverage complete

Phase 0 test/evidence repairs completed in isolated [run 36444887952](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36444887952), source `f46c91b2a3b51f8fa892d4c1259a34f231b39247`: **355/355 executed, 319 passed, 36 observations, infrastructure healthy**. The retained artifact was `vocle-security-discovery`, SHA-256 `8174f4a5699ace55fc8ac6bcf5c4e274ca4c5086c157cd6c683c57a7f7fb7bd3`. Observations remain non-gating and require separate source review; no application remediation was performed.

Phase 1 adds append-only authentication/session cases from VOCLE-356. A narrowly supervised secondary loopback backend uses `OTP_BYPASS=false`, the same disposable `vocle_ci` MongoDB, no external credentials, and explicit process readiness/termination checks. The final isolated [run 36664384991](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36664384991), source `06c5f5f8421724ebf2eb70d1a5d15e1de84904a1`, completed **386/386 cases, 348 passed, 38 observations, infrastructure healthy**. Its `vocle-security-discovery` artifact is 49.7 KB with SHA-256 `e26c334f1790c81aec8675309141ff3d671cdb37a46797fa11b71f5bb3dc1d9f`. The 31 Phase 1 cases cover widget-token trust boundaries, request-OTP storage/provider/validation/rate-limit guards, model-seeded OTP lifecycle, refresh subject/injection/replay checks, and logout device ownership/replay controls. The two P0 widget cases (VOCLE-356/357) confirm the source fast-path accepts fabricated unsigned/expired token shapes when the dummy key is present; they remain non-gating observations pending separately authorized remediation.

The original 352 registrations remain in order; appended Phase 0 opt-out denial controls are VOCLE-353 through VOCLE-355. Corrected legacy semantics are 168 (same-institution-only DM denied), 171 (caller-only self notes with replay and outsider isolation), and 218 (same-institution opted-out request denied). Cases 219–221 and 223–224 now explicitly opt in their target, assert effective `canRequestMessage` eligibility, and restore the fixture preference in cleanup; 219–221 retain lifecycle IDs/direction/count expectations and 223–224 assert the blocked gate without creating a DM.

Fixture snapshots/resets cover synthetic User records (excluding intentionally volatile `lastSeenAt`), reserved Phase 1 auth users, and controlled OTP records. Socket output declares HTTP status not applicable while retaining raw `null`, health, invariant/control/event evidence. Cases 159/268/272/273 record sanitized returned IDs and field names only. Syntax and manifest checks pass locally: **386 cases**, with all original case positions unchanged. The required loopback MongoDB/Express run and regenerated reports are retained by the successful Phase 1 workflow above.

---

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
