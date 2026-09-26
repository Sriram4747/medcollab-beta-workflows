# Current execution — 2026-09-26

The [expanded implementation and evidence report](SECURITY_EXPANSION_2026-09-26.md) supersedes the historical counts and pending-execution notes below. Final isolated [run 36225164443](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36225164443), source 63bb75df3f05e150ef444e96a186528d0f9a6143: **352/352 executed, 311 passed, 41 observations, infrastructure healthy**. Three observations remain inconclusive fresh-DM failures; none of the 352 is unexecuted.

Added 109 meaningful cases: Extended API 49, Media 31, Realtime 21 and Cross-module 8. The original 243 cases retain 230 passes and 13 observations. Exact-route execution increased from 32/73 to **46/73**; see the [generated coverage map](security-evidence/36225164443/security-api-coverage-report.md). Coverage remains partial, not whole-route assurance.

Six newly confirmed roots: draft handoff visibility, private-channel detail authorization, local-media canonical ownership, typing room authorization, private-message personal-room fan-out and stale channel-room revocation. Existing foreign-thread binding and member-list authorization gained additional evidence; all three previously confirmed roots are preserved. [Reviewed classifications](security-evidence/36225164443/reviewed-observations.json) distinguish security defects, hardening, expected behavior and inconclusive results. No application remediation occurred; no workflow YAML change was required.

Media and realtime manifests below/linked remain broader than implemented coverage. Recovery replay, crash-prone malformed socket payloads, live Cloudinary behavior and other explicit limitations are listed in the current report. Do not treat the historical planned manifests as executed in full.

---

## Historical continuity material
# Current route-level security coverage — 2026-09-25

This section supersedes the historical 146-case map below. Recomputed from current Express mounts/routes and retained run 36168079327 results at source a0b1f72. **73 explicit method/path operations; 32 exercised by discovery (43.8%), 41 without discovery cases.** Static uploads, Socket.IO, implicit HEAD/OPTIONS are outside that denominator. Setup calls are not discovery cases. No route is claimed comprehensively secure.

Execution status and security breadth are separate: IMPLEMENTED + EXECUTED means a real discovery request exists, including observations. PARTIALLY COVERED means limited boundaries or setup-only evidence. IMPLEMENTED BUT EXECUTION EVIDENCE INCOMPLETE applies to implemented cases without completed trustworthy execution; there are **zero unexecuted cases in the current 243 manifest**, although fresh-DM positive semantics remain incomplete. NOT COVERED means no security cases. INTENTIONALLY DEFERRED records an explicit environment boundary, not a pass. Media/realtime manifests are design documents, not implemented tests.

Shared message URLs retain baseline/DM module counts. A DM detail/pin test gives no group/private-channel coverage. Route matching prefers literal /users/me over /users/:id. Case 159 remains an observation, and coverage does not imply successful authorization enforcement.

| Method | Route | Execution status | Exact discovery evidence | Breadth / remaining gap |
| --- | --- | --- | --- | --- |
| POST | `/api/auth/logout` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/auth/refresh` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/auth/request-otp` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/auth/verify-msg91-token` | INTENTIONALLY DEFERRED | NOT YET EXERCISED | External widget verification prohibited in this CI; isolated input/guard tests still unimplemented. |
| POST | `/api/auth/verify-otp` | PARTIALLY COVERED | NOT YET EXERCISED | Real CI setup/health call only, outside 243 discovery results; security permutations absent. |
| GET | `/api/channels/:channelId/messages` | IMPLEMENTED + EXECUTED | EXERCISED — 14 pass (Baseline group, space, and handoff security: 9; Direct Messages: 5) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/channels/:channelId/messages` | IMPLEMENTED + EXECUTED | EXERCISED — 23 pass, 2 observation (Baseline group, space, and handoff security: 20; Direct Messages: 5) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| DELETE | `/api/channels/:channelId/messages/:id` | IMPLEMENTED + EXECUTED | EXERCISED — 16 pass (Baseline group, space, and handoff security: 10; Direct Messages: 6) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| PUT | `/api/channels/:channelId/messages/:id` | IMPLEMENTED + EXECUTED | EXERCISED — 24 pass, 2 observation (Baseline group, space, and handoff security: 20; Direct Messages: 6) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/channels/:channelId/messages/:id/react` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/channels/:channelId/messages/:id/reply` | IMPLEMENTED + EXECUTED | EXERCISED — 2 pass, 4 observation (Baseline group, space, and handoff security: 2; Direct Messages: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| GET | `/api/channels/:channelId/messages/:id/thread` | IMPLEMENTED + EXECUTED | EXERCISED — 9 pass (Baseline group, space, and handoff security: 3; Direct Messages: 6) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/channels/:channelId/messages/read` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Direct Messages: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| DELETE | `/api/channels/:id` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/channels/:id` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Direct Messages: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| PUT | `/api/channels/:id` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/channels/:id/members` | IMPLEMENTED + EXECUTED | EXERCISED — 3 pass, 1 observation (Direct Messages: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| DELETE | `/api/channels/:id/pin/:messageId` | IMPLEMENTED + EXECUTED | EXERCISED — 1 pass (Direct Messages: 1) | PARTIALLY COVERED: one DM outsider denial only; positive unpin untested. |
| POST | `/api/channels/:id/pin/:messageId` | IMPLEMENTED + EXECUTED | EXERCISED — 3 pass (Direct Messages: 3) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| GET | `/api/channels/dm` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Direct Messages: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/channels/dm` | IMPLEMENTED + EXECUTED | EXERCISED — 8 pass, 3 observation (Direct Messages: 9; Message Requests: 2) | PARTIALLY COVERED: fresh-pair positive semantics incomplete (168/169/242 return 500); existing pair and negative cases executed. |
| POST | `/api/dev/seed-conversation` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/dev/seed-handoff` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/dev/seed-notifications` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/handoffs` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/handoffs` | IMPLEMENTED + EXECUTED | EXERCISED — 15 pass, 1 observation (Baseline group, space, and handoff security: 16) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| DELETE | `/api/handoffs/:id` | IMPLEMENTED + EXECUTED | EXERCISED — 8 pass (Baseline group, space, and handoff security: 8) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| GET | `/api/handoffs/:id` | IMPLEMENTED + EXECUTED | EXERCISED — 5 pass (Baseline group, space, and handoff security: 5) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| PUT | `/api/handoffs/:id` | IMPLEMENTED + EXECUTED | EXERCISED — 8 pass (Baseline group, space, and handoff security: 8) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/handoffs/:id/acknowledge` | IMPLEMENTED + EXECUTED | EXERCISED — 5 pass (Baseline group, space, and handoff security: 5) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/handoffs/:id/submit` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| DELETE | `/api/media/:publicId` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/media/upload` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/message-requests` | IMPLEMENTED + EXECUTED | EXERCISED — 6 pass (Message Requests: 6) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/message-requests` | IMPLEMENTED + EXECUTED | EXERCISED — 17 pass (Message Requests: 17) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/message-requests/:id/accept` | IMPLEMENTED + EXECUTED | EXERCISED — 5 pass (Message Requests: 5) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/message-requests/:id/decline` | IMPLEMENTED + EXECUTED | EXERCISED — 3 pass (Message Requests: 3) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| GET | `/api/message-requests/pending-count` | IMPLEMENTED + EXECUTED | EXERCISED — 3 pass (Message Requests: 3) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| GET | `/api/notifications` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| DELETE | `/api/notifications/:id` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| PUT | `/api/notifications/:id/read` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| PUT | `/api/notifications/:id/unread` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| PUT | `/api/notifications/read-all` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| PUT | `/api/notifications/read-by-channel/:channelId` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/notifications/unread-count` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/join/:code` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/health` | PARTIALLY COVERED | NOT YET EXERCISED | Real CI setup/health call only, outside 243 discovery results; security permutations absent. |
| GET | `/api/search` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/spaces/:spaceId/channels` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/spaces/:spaceId/channels` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/spaces/:spaceId/handoffs` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| GET | `/api/spaces` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/spaces` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/spaces/:id` | IMPLEMENTED + EXECUTED | EXERCISED — 6 pass (Baseline group, space, and handoff security: 6) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| PUT | `/api/spaces/:id` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| POST | `/api/spaces/:id/invite` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/spaces/:id/leave` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/spaces/:id/members` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| DELETE | `/api/spaces/:id/members/:userId` | IMPLEMENTED + EXECUTED | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | PARTIALLY COVERED: only the listed case/module contexts; no whole-route assurance. |
| GET | `/api/spaces/invite/:code` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/spaces/join` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/support/bug` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/support/feature` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| POST | `/api/support/feedback` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/users/:id` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/users/lookup` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/users/me` | IMPLEMENTED + EXECUTED | EXERCISED — 6 pass (Baseline group, space, and handoff security: 6) | PARTIALLY COVERED: six invalid-token/header cases; identity success only in setup. |
| PUT | `/api/users/me` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| PUT | `/api/users/me/availability` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| PUT | `/api/users/me/fcm-token` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |
| GET | `/api/users/search` | NOT COVERED | NOT YET EXERCISED | No discovery case; see priority roadmap. |

## Priority gaps after this milestone

1. Realtime private-message user-room fallback, stale membership, typing access and recovery have no execution evidence.
2. Media upload/delete/static serving and URL sinks have no dedicated execution evidence. Test local ownership/canonical path handling first; Cloudinary live behavior is intentionally deferred.
3. Private group channels, independent admin, stale membership, reactions, successful unpin and direct body threadId binding remain untested.
4. Notifications (all seven routes), search, received handoff inbox/draft filtering and profile/lookup privacy need real tests. Existing handoff detail cases do not credit inbox or search.
5. Auth/session endpoints, invitation/leave/create transitions, developer-tool guards, support validation and rate limiting remain gaps. NODE_ENV=test skips the global limiter; unit code is not rate-limit execution proof.

See [review and prioritized roadmap](SECURITY_RESEARCH_BATCH_2026-09-25.md), [media manifest](SECURITY_MEDIA_MANIFEST.md), and [realtime manifest](SECURITY_REALTIME_MANIFEST.md) for fixtures, invariants and observations. Existing 61 DM and 36 request cases have now run; none remains merely pending execution. Their unresolved 500 results are preserved.

---

# Historical 146-case map and implementation notes (superseded)

The following is retained for continuity only. Pending-execution statements and eight-observation counts describe the earlier review, not current evidence.
# Vocle security coverage map

Reviewed 2026-09-19. Evidence is the 146-case executed artifact identified in
[the observation review](SECURITY_OBSERVATION_REVIEW.md), compared with
[app.js mounts](../medcollab-backend/src/app.js), all twelve feature route files,
their controllers/helpers and the Socket.IO handlers. The current inventory has
69 feature HTTP operations plus four app routes (73 total), plus static uploads
and realtime events outside that counter. Routes are identified by method + path.

**Covered** means the stated narrow boundary has positive/negative execution
evidence. **Partially covered** means only some module boundaries are exercised.
**Not covered** means no relevant running-API security test. No whole business
feature is comprehensively covered. Code inspection and unit tests do not count
as API execution. An observation still counts as exercised, not as secured.

## Module map

| Module / important routes | Current execution evidence | Status | Boundaries and missing security tests |
| --- | --- | --- | --- |
| Auth/JWT middleware; `GET /api/users/me` | Six invalid-header/token cases 085–090; A/B/C identity smoke plus anonymous denial; auth runs on selected protected calls | Partially covered | Signature/expiry/active-user lookup and onboarding. Missing expired JWT, wrong signing key/token purpose, deactivated/deleted user, incomplete onboarding, refresh misuse |
| OTP/session API: `POST /api/auth/{request-otp,verify-otp,verify-msg91-token,refresh,logout}` | No auth endpoint in the 146 cases; successful test-bypass verify-otp only in setup | Partially covered (setup only) | OTP expiry/replay/attempt caps/enumeration, widget identity binding, refresh expiry/user state, FCM device ownership at logout. Logout currently removes FCM token, not JWT revocation. Real SMS/widget delivery is out of scope |
| Spaces: `GET/POST /api/spaces`, `GET/PUT /api/spaces/:id` | List/detail/update A/B/C/anonymous; malformed-ID cases; corrected absent-ID case pending rerun | Partially covered | Space membership and owner/admin changes. Missing create validation, settings injection, inactive spaces, private-channel leakage in embedded lists |
| Members/roles/invites: `GET /api/spaces/:id/members`, `DELETE /:id/members/:userId`, `POST /join`, `GET /invite/:code`, `POST /:id/invite`, `POST /:id/leave` under `/api/spaces` | Member list/removal across four actors | Partially covered | Missing owner-removal prevention, admin distinct from owner, stale membership, invite regeneration/old-code invalidity, approval mode, replay, leave/owner rule. No standalone role-transfer API was found; do not invent one |
| Space channels: `GET/POST /api/spaces/:spaceId/channels` | GET across four actors; POST untested | Partially covered | Missing channel creation policy/types, private channel visibility, default/emergency channels, announcements-only posting |
| Channel management: `GET/PUT/DELETE /api/channels/:id`, `GET /:id/members`, `POST/DELETE /:id/pin/:messageId` | No direct requests | Not covered | Detail/member privacy, archive/admin boundary, pin ownership/foreign messages, limits, private/DM context. Pin controller allows space members/DM participants; stale route comments say admins—derive tests from reviewed policy, not comments alone |
| Group/channel messages: `GET/POST /api/channels/:channelId/messages`, `PUT/DELETE /:id`, `POST /:id/react`, `POST /read` | Read/create/edit/delete permutations; text, enums, pagination, ownership-field mutations | Partially covered | Sender ownership/admin deletion, public space membership. Missing reactions, positive foreign-parent containment for direct threadId submission, archived/private channels, mentions/media references, announcement restrictions. DM receipts not tested |
| Threads/replies: `GET .../messages/:id/thread`, `POST .../messages/:id/reply` | Foreign root variants for A/B; malformed root ID | Partially covered | Missing valid same-channel reply/thread paths, anonymous/C positive-resource variants, reply pagination/deleted root, completed async effects. Two confirmed foreign-reply observations remain |
| Direct Messages: `GET/POST /api/channels/dm`, shared channel detail/members/pins and message routes using `type: direct` | 61 deterministic real-API cases are implemented in `scripts/security/suites/direct-messages.js`; fresh execution evidence is pending | Implemented; pending execution | Participant-only read/write/edit/delete/threads/receipts; DM pair uniqueness/idempotence; same-institution vs genuinely unrelated eligibility; self/inactive/absent targets; archived conversations; pin and member metadata isolation |
| Message requests: `GET/POST /api/message-requests`, `GET /pending-count`, `POST /:id/accept`, `POST /:id/decline`; `utils/knownUsers.js` | 36 deterministic real-API cases are implemented in `scripts/security/suites/message-requests.js`; fresh execution evidence is pending | Implemented; pending execution | Recipient-only transitions; pending/accepted/declined/blocked; sender/recipient/outsider listing; replay, reciprocal requests; accepted/declined relationship binding to DM creation |
| Handoffs: `GET/POST /api/handoffs`, `GET/PUT/DELETE /:id`, `POST /:id/submit`, `POST /:id/acknowledge`, `GET /api/spaces/:spaceId/handoffs` | Seven of eight route operations; participant/outsider, lifecycle, replay, foreign references, required fields | Partially covered | Missing personal inbox GET filters, draft visibility to receiver/nonparticipant/admin, third-party member vs participant distinction, patient nested limits, stale membership, concurrent transitions; unchecked channel binding confirmed |
| Media: `POST /api/media/upload`, `DELETE /api/media/:publicId` | Zero | Not covered | MIME/size/content checks, encoded IDs/path containment, file ownership, handoff upload context. Local disk fallback exists; later tests need no Cloudinary credentials |
| Static uploads: `/uploads/*` via `express.static` | Zero; not counted among 73 explicit handlers | Not covered | Read authorization/public URL policy, guessed IDs, traversal, unsafe active content, cache/privacy behavior |
| Notifications: `GET /api/notifications`, `GET /unread-count`, `PUT /read-all`, `PUT /read-by-channel/:channelId`, `PUT /:id/read`, `PUT /:id/unread`, `DELETE /:id` | Side effects may create notifications; no endpoint cases or notification assertions | Not covered | Recipient-only read/write/count/bulk update; metadata leakage; foreign channel IDs; future FCM tests must remain local/disabled |
| Users/profiles: `GET/PUT /api/users/me`, `PUT /me/availability`, `PUT /me/fcm-token`, `GET /search`, `GET /lookup`, `GET /:id` | Only GET /me exercised; no GET /:id | Partially covered | Profile field allowlist, medical role vs space privilege, privacy/preferences, lookup/discovery known-user boundary, device token isolation |
| Search: `GET /api/search` | Zero | Not covered | Caller-accessible channels/DMs, private resources, handoff draft visibility, deleted messages, query limits/types and field minimization |
| Support: `POST /api/support/{bug,feature,feedback}` | Zero | Not covered | Authenticated attribution, field limits/types, stored data minimization; no ticket read/admin API found |
| Dev tools: `POST /api/dev/{seed-notifications,seed-conversation,seed-handoff}` | Zero; fixture scripts do not call these | Not covered | Environment enablement and authenticated scope. Guards permit non-production or explicit ENABLE_DEV_TOOLS; do not test production |
| Socket.IO: handshake; join_channel, leave_channel, typing_start/stop, sync_space_rooms, update_availability, disconnect/recovery; server broadcasts | Zero client socket security cases | Not covered | `authenticateSocket`, personal/space/channel rooms, canAccessChannel, typing authorization, stale room membership, reconnection middleware/replay and presence privacy |
| Platform: `GET /`, `/api`, `/health`, `/join/:code`; CORS, Helmet, global limiter/error handler | /health checked during boot/discovery, outside 146-case list | Partially covered | Boot/database safety check is covered; missing invite landing output, disclosure/header/CORS and error handling tests. Global limiter skips NODE_ENV=test, so current runs cannot establish production rate-limit effectiveness |

## What is narrowly covered

The selected public-space A/B/C/anonymous access and message-owner permutations
have real execution evidence, as do submitted-handoff mutation rejection and
receiver/replay acknowledgement rules. These narrow checks are Covered within
their exact fixture context. That does not make private channels, DMs, independent
admin roles or all handoff visibility paths covered.

Distinct route coverage in the artifact is **20 of 73**, after correcting the
reporter's overlap: `/api/users/me` must not also count as `/api/users/:id`.
Breakdown: spaces/membership 5/10; space channels 1/2; group message routes 6/8;
handoffs 6/7 plus space handoff list 1/1; users 1/7; all other explicit route groups
0 in the discovery results. The health/auth setup calls are outside that count.
The old generated report showed 21 due to double-crediting `/users/me`.

**Direct Messages were not covered by the 146-case suite.** Both scratch channels
default to GENERAL, have a space ID and exercise public-space membership rules.
The DIRECT branch in `resolveChannelAccess`, `getMessages` and `markAsRead` never
runs in these fixtures. Shared URL patterns do not imply shared security coverage.
The fixture users share an institution, so C being a space outsider is not enough
to expect that C cannot create a DM through `canMessageUser`.

The manifest now extends that historical baseline to 243 planned cases (61 DM,
36 message-request cases), but these new cases must not be described as executed
until a fresh disposable-run artifact is reviewed. Module labels on every result
distinguish executions of shared message routes in group versus direct contexts.

## DM and message-request phase implementation specification

Implemented in the current worktree; fresh execution confirmation remains pending:

1. Read AGENTS.md, SECURITY_AUTOMATION_PROGRESS.md, this map and the reviewed
   observations. Preserve one workflow and the current demonstration cases.
2. Extract reusable local safety/auth/request/report helpers only as needed; add
   modular `security/suites/direct-messages` and `message-requests` code beneath
   backend test support. Do not split into new workflow YAML files.
3. Introduce deterministic relationship fixtures: shared-space peers, same-
   institution peers without shared space, truly unrelated peers (different
   institution, no DM/request), and an accepted-request pair. Keep A/B/C baseline
   unchanged. Model existing-DM and pending/declined/blocked states explicitly.
4. First matrix: participants, third controlled user and anonymous across DM
   create/list/detail/members and message read/create/edit/delete. Assert response
   identity/resource data and DB containment, not only status. Repeated creation
   must yield the same two-member DM. Medical role must not grant DM access.
5. Add recipient-only request accept/decline; list/count isolation; replay and
   pending/accepted/declined cases; verify which transitions allow createOrGetDM.
   Bounded schema mutations come from messageRequest.routes and channel.routes.
6. Include receipts and foreign message IDs in direct-channel context; document
   why ordinary group-message passes do not substitute. No FCM/SMS delivery.
7. Report findings without fixes; append module/context labels to every result so
   coverage distinguishes group and direct executions of the same route.
8. Acceptance: loopback-only checks pass, deterministic fresh fixtures, real HTTP
   plus real middleware/database, positive/negative identity assertions, no token
   output, all four reports uploaded, infrastructure failures blocking, discovery
   observations non-blocking. Review actual run evidence before claiming passes.

Start sequentially: current scratch IDs/reset and global state are not safe for
parallel suites sharing a database. Parallelism requires separate fixture
namespaces/databases and report merging. Defer broad media, Socket.IO, randomized
fuzzing, performance, SMS/widget integration and production behavior changes.
Prioritize explicit review/remediation decisions for the two existing defects
alongside planning; do not silently bundle fixes into the next feature suite.

## Inventory limitations and inspection leads

The automatic inventory parses the current literal Express registration syntax;
it is not a general JavaScript parser or a branch-coverage instrument. Static
middleware, implicit HEAD/OPTIONS and Socket.IO are tracked here separately.
New dynamic route-registration styles need an inventory update. Runtime route
attribution prefers the literal route over parameter routes for current patterns.

Code inspection also found high-value untested areas: channel member-list access,
handoff draft exposure through inbox/search, and typing/recovery authorization.
These are investigation leads, not additional confirmed findings from the eight
observations. Controllers sometimes differ from route comments; trace both and
resolve intended policy before writing a strict gate.
