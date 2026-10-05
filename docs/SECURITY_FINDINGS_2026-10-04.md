# Real-provider findings addendum — 2026-10-05

[Final run 37355451614](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37355451614): 34/34,25 passes/nine observations, healthy; 13/13 recorded origins absent in finally/post-job cleanup. [Reviewed exact expected/actual cases](security-evidence/37355451614/reviewed-observations.json), [full provider findings/controls/limits](SECURITY_CLOUDINARY_INTEGRATION_2026-10-05.md). Existing video deletion736→762, octet MIME dispatch724/725→782/783 and handoff deletion740→784 are confirmed without duplicate roots. **770/771 newly confirm app PDF delivery contracts captured by offline731:** named raw attachment400 with plain attachment200 control; raw→image preview404 with image-PDF WebP200 control. These are app/provider URL compatibility failures; no account-wide raw/PDF restriction inferred.

765/773/776 characterize cached video/raw/image bytes available200 immediately after origins disappear; eventual invalidation/private-delivery policy remains unverified. No new provider-defect or production-configuration root claimed. First run781 filename-dot observation was a harness false positive; exact namespace/segments pass in final run and history remains unchanged. No vulnerability fix/strict gate or generic-suite rerun. Approved synthetic-only TEST cloud, independent positive allowlisting, no production/upstream access.

---

# Executed offline media/storage findings — 2026-10-04

Hosted [run 37181051425](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37181051425), source `dca95d019fddf792adae7fcd4c21b5bc649c2b30`: **97/97, 62 passes, 35 observations; infrastructure healthy**. Nine existing media observations retain their prior dispositions; 26 new observations consist of **one confirmed local S6 avatar variant, three exact call-contract defects, 22 hardening/compatibility/lifecycle/policy observations**. Read [expected/actual findings with source paths](SECURITY_MEDIA_OFFLINE_2026-10-04.md), [all reviewed cases](security-evidence/37181051425/reviewed-observations.json) and [execution/hashes](security-evidence/37181051425/execution.json).

S6/704 deletes the exact synthetic foreign avatar via canonical traversal. 724–725 verify valid octet-PDF/video bytes are sent as image. 736 verifies deletion dispatches image/raw and never video. Shared handoff folder/403 deletion (721/740 and local705), omitted overwrite/invalidation, inherited context function, foreign namespace SDK dispatch, partial-failure orphans, video-message rejection, untrusted references/metadata and stale lifecycle references remain scoped observations. **739 demonstrates application namespace validation, not actual Cloudinary cross-user deletion**; the reviewed hardening label narrows its raw automatic label. Provider responses/assets are simulated. Retention/sharing cases require policy, not automatic vulnerability claims.

No application fix, new active gate, Cloudinary account, credentials or request. General 691 was not rerun; its historical 80 dispositions and gate registry remain intact. Combined catalog 751 does not imply 751 fresh execution. Stage 3 remains deferred, including real decoding/ID normalization/deletion/delivery/permissions/CDN verification.

---

# Historical media/storage design review — 2026-10-04

See [Cloudinary integration, threat analysis and scenario design](SECURITY_CLOUDINARY_MEDIA_DESIGN_2026-10-04.md), especially its existing-findings disposition table. S6/VOCLE-313–314 proves cross-user deletion of synthetic **local** files, not a Cloudinary exploit. H2/301–304 is backend error mapping; H3/306–307 is local byte-validation hardening; U1/323 remains the local upload→message contract mismatch. These outcomes are retained, with no remediation or strict gate activation.

Source inspection additionally identifies no video destroy path, shared handoff uploads without normal deletion ownership, URL-only records without asset provenance, and absent explicit overwrite prevention/CDN invalidation/lifecycle reconciliation. These are **source-derived gaps**, not newly executed provider findings. Actual production presets, permissions, delivery policies and folder settings remain unknown. The documentation-only design phase leaves all 691 results and 80 observation dispositions unchanged and accesses no production service.

---

# Current reviewed findings — defensive expansion 2026-10-04

[run 37175207493](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37175207493), executed source `e89f8848fee4c21f3de91e31469ae61837f13bd8`: **691/691 executed, 611 passes, 80 observations; infrastructure healthy.** Exact HTTP operations exercised: **77/77 (100%)**. These are bounded route contexts, not complete security assurance.

Added **65 cases (VOCLE-627–691)**: 22 developer/platform HTTP, 32 realtime lifecycle, six cross-module lifecycle and five optional auth hardening cases. All previous 626 IDs/expectations/results remain intact (566 passes, 60 observations); the 626 manifest is pinned. See [expansion details](SECURITY_DEFENSIVE_REGRESSION_2026-10-04.md), [actual route map](security-evidence/37175207493/security-api-coverage-report.md), [reviewed observations](security-evidence/37175207493/reviewed-observations.json) and [execution/hashes](security-evidence/37175207493/execution.json).

51 confirmed-case gate candidates and 29 excluded observations are mapped in [the registry](SECURITY_REGRESSION_GATES.md); zero strict gates are active. No application vulnerability was fixed. Six new confirmed roots cover established deactivation, revoked presence, stale DM typing cache, null synchronous handler crashes, recovery replay and concurrent OTP consumption. Existing stale channel-room and mention-preview findings gain realtime/cross-module evidence. Mid-session expiry remains policy; async null rejections and developer notification reference omissions remain hardening/reliability.

New observations: 1 hardening / developer helper contract; 1 session expiry policy review; 16 confirmed security defect; 2 hardening / socket input handling. Read [the detailed new observation table](SECURITY_DEFENSIVE_REGRESSION_2026-10-04.md) and [current reviewed JSON](security-evidence/37175207493/reviewed-observations.json). All 60 previous dispositions are retained without redoing their analysis. Null socket HTTP status is intentional; confirmed packet findings require positive controls and matched events, and crash findings require explicit exit code evidence. Current findings are non-gating; do not change them to PASS to obtain a green workflow.

---

# Security expansion findings — 2026-10-04

Final reviewed evidence: [run 37144805902](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37144805902), source `f559332b82783b7fee4341434e15c49ec25dc728`: **626/626 executed, 566 passes, 60 observations, infrastructure healthy**. The four [raw reports](security-evidence/37144805902/summary.md), [reviewed JSON](security-evidence/37144805902/reviewed-observations.json), [coverage](security-evidence/37144805902/security-api-coverage-report.md) and [execution/hash metadata](security-evidence/37144805902/execution.json) are retained. Artifact `11281218939`, archive SHA-256 `98f03261eba5528433f088747d3252975bd7dc812db141a19f7d56c6bd12cbe0`.

All original 386 retain 348 passes / 38 observations; all 579 previous pass/observation outcomes match the healthy Phase 2/3 [run 37144068281](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37144068281). Application code is unchanged. The **22 new observations** comprise **eight confirmed security cases across three roots**, **ten hardening/lifecycle cases**, and **four consent/audit policy cases**. These reviewed dispositions supersede provisional automatic labels without rewriting raw reports. Confirmed scope is only the stated synthetic HTTP/database evidence.

## New confidentiality findings

| Root | Cases | Expected vs actual and source |
| --- | --- | --- |
| N1 — Needl access and revocation | VOCLE-429, 434, 503, 509 | Private roots/previews must remain invisible to excluded or revoked callers. Needl returns 200 with the private root. 429/434 record a matching preview, owner canary and 403 message-read control. After actual space leave/removal, 503/509 still receive the root through retained channel membership; the final run records post-revocation message denial, owner canary and returned private-root flags. `users/user.controller.js:getNeedl` selects every channel in member spaces and independently every channel containing the caller, without `resolveChannelAccess` or an equivalent private/current-space guard. |
| N2 — Private pin/unpin authorization | VOCLE-594/595 | Expected 403/no mutation; actual 200/snapshot change when excluded ordinary B pins or unpins a private message. 595 starts with an independently persisted owner pin canary. Owner pin/unpin and replay controls pass. `channels/channel.controller.js:pinMessage/unpinMessage` check parent-space membership but omit private membership/admin access. |
| N3 — Mention notification audience | VOCLE-603/604 | Sending a valid message should create no preview notification for a foreign outsider or excluded private member. HTTP 201 is expected, but the DB contains the matching preview for the unauthorized fixture recipient. Each case first observes an authorized recipient mention canary. `notification.service.js:notifyMention` filters sender/viewers, without checking recipient channel/space access. |

Executed impact is limited to synthetic Needl previews and root/channel identifiers. Full thread downloads, attachments, provider delivery and arbitrary real identities are not claimed. This is independent of the already known stale socket-room revocation finding.

## Hardening and policy questions

| Cases | Disposition | Expected vs actual, source and limit |
| --- | --- | --- |
| VOCLE-398 | Public field minimization | Foreign public-profile reads are supported and phone/FCM minimization passes. The response nevertheless includes notification preference keys and `lastSeenAt` from `User.toPublicProfile`. Product should decide whether this is intended public metadata. No blanket foreign-profile denial is invented. |
| VOCLE-421 | Known-user membership inference | The foreign space detail control denies 403, but `/users/search?spaceId=...` returns a known user from that space. `searchUsers` loads arbitrary space member IDs then intersects known users without checking caller space membership. This proves narrow membership inference, not complete member enumeration or message disclosure. |
| VOCLE-527/528 | Group target lifecycle | Expected 404 unavailable-target denial; actual HTTP 200 and exact unavailable target membership persisted for opted-in inactive/incomplete identities. `createGroupDM` selects only `_id/name` and does not validate active/onboarded state. This is an integrity/availability issue; no inactive authentication is proved. |
| VOCLE-572 | Handoff assignee lifecycle | Expected 400 inactive-assignee denial; actual 200, inactive assignee/history/notification persisted. `reassignHandoff` checks only `space.isMember(toUserId)`. No inactive user receipt/authentication is claimed. |
| VOCLE-529/530 | Consent policy | Source explicitly accepts request-eligible peers in group DMs. Actual group send/read succeeds without request acceptance; `canMessageUser` then treats the shared group as eligibility for a one-to-one DM. Product must decide whether group invitation deliberately grants this consent. The request remains pending. |
| VOCLE-574/575 | Removed-party audit continuity | The source authorizes current participant IDs for notes/reassignment even after space removal. Writes succeed despite REST space revocation. Audit continuity may be intentional; keep as lifecycle policy review rather than an outsider/admin authorization defect. |
| VOCLE-599 | Archived pin mutation policy | Expected 403 under the archive access contract; actual 200/mutation. Reaction archive denial passes. Pin handler omits the archived guard. This is a policy consistency/hardening issue. |
| VOCLE-605 | Inactive mention lifecycle | The inactive recipient also receives a persisted preview notification. Its authentication remains disabled, so stored data is proved, rather than readable disclosure or provider delivery to an inactive account. |
| VOCLE-611/618/625 | Support input handling | Expected 400; actual 500 for object titles on bug/feature/feedback. The controlled state remains unchanged and backend health remains good. Each support controller calls optional `.trim()` without validating string type. Ownership, missing/whitespace fields, truncation and anonymous controls pass. |

## Baseline continuity

All 38 baseline observations remain reportable. The previous nine reviewed roots and Phase 1 widget-token finding remain separate from this expansion. VOCLE-171 and VOCLE-355 still fail existing semantic checks despite expected HTTP statuses; they are retained baseline ambiguities, not newly introduced defects, and their expectations were not changed. VOCLE-323 remains the unresolved local-media integration contract. Original raw reports and reviewed classifications remain intact.

## Execution, infrastructure and limits

Both hosted runs succeeded without setup, process startup, fixture/reset, authentication or execution failures. Infrastructure changes extend settled snapshots to synthetic-owned spaces and their default channels and add user-scoped SupportTicket cleanup/snapshots/reset counts. The existing workflow now checks syntax and the canonical original 386-case manifest before backend execution. Follow-up evidence strengthens existing new-case assertions without changing statuses, names or IDs; application observations are not weakened to obtain success.

The final batch independently exercises reaction toggles/identity/binding, quote `replyToId` containment (distinct from the known `threadId` defect), support attribution/truncation, and positive/negative controls. Coverage is **70/77 (90.9%) exact HTTP operations**, not complete security assurance. No fixture phones, identities, tickets, media or tokens belong to production. Raw tokens/bodies/provider credentials are not retained. Model changes establish setup only; actions use real HTTP and real Mongoose/database behavior.

No application remediation is included. Provider integrations, socket recovery/token expiry/deactivation/cache and crash-prone payloads, developer-tool configuration supervision and platform/deep-link pages remain deliberately deferred.
