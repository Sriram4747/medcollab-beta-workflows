> Historical review. The [current 352/312/40 observation analysis](SECURITY_FINDINGS_2026-09-26.md) and [Terra continuation plan](SECURITY_TERRA_NEXT_PHASE.md) supersede current-status claims below. Original evidence remains unchanged.

# Expanded isolated security execution — 2026-09-26

Starting repository: c115fa89a9106f4f12736ed4017eba50ed1219fb on master. The hardened baseline had 243 cases, 230 passes and 13 observations (successful run 36210983563; repository quality review). Existing confirmed roots and historical evidence remain preserved.

Implementation adds 109 cases, for 352 total: Extended API 49, Media 31, Realtime 21, Cross-module 8, alongside baseline 146, Direct Messages 61 and Message Requests 36. Final hosted execution: 352 executed, 311 passed, 41 observations, zero unexecuted, infrastructure healthy. The original 243 retained 230 passes and 13 observations; the new 109 produced 81 passes and 28 observations.

The runner uses the existing real Express/Mongoose backend, MongoDB 7 container, test-only OTP identities and exact loopback guards. Socket.IO uses pinned socket.io-client 4.8.3. Local media uses real multipart requests, exact byte checks and disposable files. No hosted media URLs are fetched. Every file deletion target is an uploaded synthetic file under the verified uploads root; traversal tests only normalize into another fixture user's upload subtree.

No workflow YAML change is necessary: the existing runner now registers all new suites and npm ci installs the client. Application source files are unchanged. Unrelated Flutter/Android changes are excluded from commits.

## New executable coverage

- Channel update/archive admin boundaries and create membership; ownership/space/member field injection; private group detail, member list and messages.
- All seven notification operations: recipient-specific inbox/count, individual read/unread/delete and bulk/channel-scoped updates with independent database checks.
- REST expired/wrong-key/inactive/refresh-token rejection; private/public/foreign-space/DM search with positive controls; draft handoff inbox, explicit draft filter, detail and search privacy.
- Media contexts (message/avatar/handoff/fallback), owner-derived folder, exact PNG/PDF bytes, octet-stream extension exception, missing/wrong/multiple files, forbidden MIME/suffix, size limit, empty bytes and inert MIME/extension mismatch.
- Media deletion owner/foreign/anonymous/replay, single/double-encoded canonical ownership containment, anonymous static access and post-delete revocation; trusted-host/lookalike/malformed/protocol-relative/HTTP/FTP URL validation, local-upload message integration.
- Realtime handshake rejection and identity forgery; denied joins for private/foreign-space/foreign-DM channels paired with REST denial and real authorized edit delivery; typing start/stop after denied joins, private new-message personal-room delivery, stale rooms after membership removal before/after sync, explicit leave, server-event injection and fresh reconnect.
- Cross-module direct body threadId group-to-foreign-group/DM binding with persisted child and parent-counter evidence; upload URL to foreign group/DM; draft handoff attachment sender ownership.

Realtime silence is evaluated only after an authorized event control and a 1500 ms observation window. Missing controls are infrastructure failures. Actual socket evidence is distinguished from the separate HTTP health check. Files and sockets are cleaned in finally blocks; database resets retain the original settled-state and denial-payload protections.

## Infrastructure history

- Run 36224683017 at f67552a: npm ci failed before backend start; zero security cases executed. Local npm 11 had removed optional peer lock entries expected by CI npm 10.9.8. Regenerated lockfile using npm 10.9.8, without changing workflow configuration or application logic.
- Run 36224837627 at ab89191: 336 executed, 299 passed, 37 observations; infrastructure healthy. Run 36225029324 at ffb3a21: expanded 352-case workflow successful. Final run 36225164443 at 63bb75d: 352 executed, 311 passed, 41 observations; infrastructure healthy. Realtime actor labels were corrected before this final run.

## Deliberate limits and remaining surfaces

This is focused coverage, not comprehensive coverage of all 73 routes. Cloudinary live upload/decoding/deletion/CDN ownership remains deferred because no disposable credentials or external adversarial traffic are authorized. Public static access is expected local behavior, not itself a confidentiality finding. URL storage is not evidence of SSRF or executable content.

Still uncovered: full OTP/session refresh/logout/device-token behavior; invitation/join/leave/create-space state machines; profile and lookup privacy; support and dev-tool guards; production-like rate limiting; independent-admin permutations; broader receipt/reaction/unpin transitions; media avatar/profile URL sinks, shared handoff upload cleanup, file-reference reuse lifecycle and exact at-limit upload; realtime recovery replay, token expiry/deactivation during established sessions, presence/availability and multi-device state, space-room revocation, handoff notification audience. Destructive malformed socket payload families that may terminate the backend require separate disposable-process supervision/restart before they can safely coexist with the full runner; they were not executed or credited. Fresh reconnect coverage does not establish connection-state recovery safety. There is no invented receipt event or media update route.


## Final evidence and module breakdown

Authoritative [CI run 36225164443](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36225164443), executed source `63bb75df3f05e150ef444e96a186528d0f9a6143`.
Artifact 10900417063, archive digest `sha256:408a117d069becfba5ce6cccf48ee399678925548b07168c69a8b7aa82f4c22d`.
Preserved [results.json](security-evidence/36225164443/results.json) SHA-256: `61570c8e274f255af1ad2b31ac71520dba8a24fe308f581772f2b80e1192915e`.
[Executed route coverage](security-evidence/36225164443/security-api-coverage-report.md): **46/73 routes**, up from 32/73. Socket events and static media reads are outside this route count. [Reviewed observation classifications](security-evidence/36225164443/reviewed-observations.json) cover every unexpected case exactly once; raw runner classifications are provisional and preserved unchanged.

| Module | Executed | Passed | Observations |
| --- | ---: | ---: | ---: |
| Baseline group/space/handoff | 146 | 139 | 7 |
| Direct Messages | 61 | 56 | 5 |
| Message Requests | 36 | 35 | 1 |
| Extended API | 49 | 43 | 6 |
| Media | 31 | 20 | 11 |
| Realtime | 21 | 12 | 9 |
| Cross-module | 8 | 6 | 2 |
| **Total** | **352** | **311** | **41** |

Counts are not vulnerability counts. The 41 observations comprise **25 cases confirming nine security roots**, **12 validation/hardening cases**, **one source-expected functional integration mismatch**, and **three inconclusive cases**. Inconclusive is a subset of observations, not an additional count. No likely-but-unconfirmed new security root or unresolved test infrastructure failure remains in the final run.

## Newly confirmed security roots

1. **Draft handoff visibility** — 267/268/270/271. Explicit received status=draft, direct detail and search expose drafts to the receiver; search also exposes the draft summary to unrelated ordinary space member D. This contradicts sender-only draft privacy documented in handoff.model.js. These paths are grouped under one draft-visibility root. Search proves summary disclosure, not attachment download.
2. **Private channel detail authorization** — 272. Excluded same-space member B receives private-channel detail even though messages and socket join deny access. Detail checks space membership without private-channel membership. No arbitrary-ID discovery claim.
3. **Local media canonical ownership** — 313/314. Single and double encoded paths pass substring ownership but normalize into C's synthetic upload; the exact preverified foreign file is deleted. Both variants share one root. Tests never target application/configuration files or real users.
4. **Typing room authorization** — 339/340/342/343/345/346. Attacker-attributed start/stop reaches authorized victims in foreign-space, foreign-DM and private-group rooms after failed attacker join and REST denial. This is event authorization failure, not identity impersonation.
5. **Private message personal-room fan-out** — 347. Excluded B receives the exact private message ID and full canary text through its personal socket despite REST denial. Authorized recipient control delivered.
6. **Stale channel rooms after membership removal** — 348/349. Removed B continues receiving edits before and after sync_space_rooms while fresh REST access is denied. Explicit leave and fresh reconnect controls pass; recovery replay remains untested.

## Existing roots and non-security observations

- Foreign reply binding: old 094/098/193/197 preserved; new 275/276 submit foreign group/DM roots directly in threadId, independently proving persisted foreign binding and victim parent replyCount=1. Same existing root, not two new findings.
- Channel member-list authorization: old DM 159 preserved; private-group 273 extends the same unguarded member-list controller.
- Foreign handoff channel binding: old 099 preserved, without claiming untested downstream delivery.
- Hardening: existing text coercion 109–112; malformed multipart/type errors returning 500 with no files added (301–304); empty/inert MIME-mismatched bytes accepted (306/307); FTP/HTTP trusted-host references accepted (321/322). No active-content, SSRF or client execution claim.
- Expected current behavior with functional mismatch: 323 uploads locally, then message host allowlisting rejects that local URL. The positive integration assertion is retained; this is not an authorization bypass.
- Inconclusive security significance: 168/169/242 still return 500 for fresh DM creation. They remain unresolved functional errors and are not reclassified as vulnerabilities or passes.

## Newly exercised API operations and events

New exact operations: POST /api/spaces/:spaceId/channels; PUT/DELETE /api/channels/:id; all seven notification operations; POST /api/media/upload; DELETE /api/media/:publicId; GET /api/search; GET /api/handoffs. Previously exercised routes receive new private-channel, session, thread-binding, attachment and URL-validation coverage.

Actual socket operations: authenticated handshake/connect_error, join_channel, typing_start, typing_stop, leave_channel, sync_space_rooms, disconnect/fresh reconnect; observed message_updated/new_message and user_typing/user_stopped_typing. Inbound new_message and unhandled send_message are tested as no-op injection attempts, not invented supported operations. REST membership removal and message writes are real producers. No workflow YAML changes were needed.

## Files and publication

Created suites: scripts/security/suites/extended-api.js, media.js and realtime.js under medcollab-backend. Modified runner scripts/security-api-discovery.js and package.json/package-lock.json for registration, cleanup, scenario evidence and the pinned test client. npm 10 lock regeneration also refreshed an optional nested gaxios resolution; application source was not edited.

Created this report and three retained evidence files. Updated SECURITY_AUTOMATION_PROGRESS.md, SECURITY_TEST_COVERAGE.md, SECURITY_MEDIA_MANIFEST.md and SECURITY_REALTIME_MANIFEST.md with current execution pointers while retaining historical plans/evidence.

Test implementation commits: f67552a, ab89191, ffb3a21, and final executed source 63bb75df3f05e150ef444e96a186528d0f9a6143. Pushed branch: **origin/master**, experimental Sriram4747/medcollab-beta-workflows only. The final documentation/evidence commit follows the executed source; it makes no executable changes. Upstream and unrelated Flutter/Android work remain untouched.
