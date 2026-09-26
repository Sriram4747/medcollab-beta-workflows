# Terra next security phase

Baseline: source `91d237294625288bd7f304871a4df3a9ea50fcdd`, [run 36228675577](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36228675577), 352 executed / 312 passed / 40 observations. Read AGENTS.md and [reviewed findings](SECURITY_FINDINGS_2026-09-26.md) first. **Implement tests and reporting only. Do not patch application vulnerabilities.**

## Coverage inventory

The [current generated map](security-evidence/36228675577/security-api-coverage-report.md) discovers **77** explicit HTTP method/path operations, **46 exercised (59.7%)**, **31 uncovered**. The previous 73 denominator is obsolete: added operations are group DM, handoff notes/reassign and Needl. Exact-route hits count observations as exercised; neither hits nor pass counts establish full authorization coverage. Setup verification/health calls, Socket.IO, static media and implicit HEAD/OPTIONS are outside credited discovery execution.

| Uncovered family | Count | Exact operations |
| --- | ---: | --- |
| Authentication | 5 | POST `/api/auth/request-otp`, `/verify-otp`, `/verify-msg91-token`, `/refresh`, `/logout` |
| Users | 7 | GET `/api/users/:id`, `/lookup`, `/search`, `/me/needl`; PUT `/api/users/me`, `/me/availability`, `/me/fcm-token` |
| Spaces | 5 | POST `/api/spaces`, `/api/spaces/join`, `/api/spaces/:id/invite`, `/api/spaces/:id/leave`; GET `/api/spaces/invite/:code` |
| Group DM | 1 | POST `/api/channels/dm/group` |
| Handoff | 2 | POST `/api/handoffs/:id/notes`, `/api/handoffs/:id/reassign` |
| Reactions | 1 | POST `/api/channels/:channelId/messages/:id/react` |
| Developer tools | 3 | POST `/api/dev/seed-conversation`, `/seed-handoff`, `/seed-notifications` |
| Support | 3 | POST `/api/support/bug`, `/feature`, `/feedback` |
| Platform | 4 | GET `/`, `/api`, `/join/:code`, `/health` |

High-risk breadth gaps on already exercised routes: private pins/unpins and archived detail/member reads; quote replyToId versus threadId binding; mentions/notification recipients; accepted/blocked/inactive DM combinations and group-derived pair eligibility; request concurrency; handoff former-participant access; media reference lifecycle, original suffix/content-type behavior; socket recovery, token expiry/deactivation, stale space rooms and presence. These must not disappear behind the 46-route figure.

## Phase 0 — repair test meaning and evidence (first commit)

1. Keep existing VOCLE IDs and order. Runner assigns IDs by registration order; append new suites after existing registrations (after all 352), never insert cases within old registrations unless explicit stable IDs are introduced first. Add new cases starting at VOCLE-353; choose final ranges only after enumerating the manifest. Preserve old artifacts and reviewed disposition.
2. Update 168 to deny same-institution-only DM, 171 to validate caller-only self notes, 218 to deny same-institution opted-out request. For 171 also exercise/recheck one self channel on replay and outsider isolation. Do not merely widen allowed status sets.
3. Repair 219/220/221 positive preconditions by temporarily opting in target F/E/G respectively, asserting effective permission, and restoring User preferences in cleanup/reset. Retain exact pending/declined IDs, direction, counts and no reciprocal duplicate assertions. Add separate opted-out denials. Make 223/224 blocked tests reach the blocked gate by enabling the relevant target's opt-in; verify denial, no DM and unchanged request state.
4. Format SOCKET observations using invariant/control/event fields and healthStatus, with HTTP expectation/status marked not applicable. Retain measured null HTTP status and raw artifacts. Keep exception/missing-control paths blocking. Add sanitized metadata ID/field evidence to 159/268/272/273. No raw bodies, credentials or tokens in reports.
5. Run syntax + `node scripts/security-api-discovery.js --list`; compare the original 352 IDs/names deliberately changed and exact registration positions. Run existing isolated workflow on origin/master, review artifact before declaring repaired cases pass. Retain all security observations until actual app remediation is separately authorized.

## Phase 1 — authentication and session lifecycle (next implementation batch)

Proposed files: `scripts/security/suites/auth-session.js` plus a narrowly scoped test process supervisor if needed. Trace `auth.routes/controller`, `middleware/auth`, `middleware/validate`, `otp.service`, `otp.model`, `msg91Widget.service`, `rateLimiter` and `User`.

### Isolation prerequisites

- Preserve current 352-case workflow baseline: Node 22, real Express/Mongoose, Docker MongoDB 7 on loopback, `NODE_ENV=test`, exact `vocle_ci`, synthetic phones and test signing keys. No Atlas/Railway, real SMS, FCM or Cloudinary. Assert external credentials absent; outbound traffic must fail closed.
- Current suite uses OTP_BYPASS=true for fixture authentication. **Do not claim OTP expiry/replay/attempt coverage using bypass code 123456:** `otp.service.verifyOtp` returns early without DB checks. Use a separate supervised backend process, started serially on verified loopback, with OTP_BYPASS=false and no provider credentials for normal OTP verification cases. Seed hashed synthetic OTP records via real `OTP.createOtp`/model; test action still goes through HTTP. Never mutate env in the runner expecting the already running backend to change.
- AuthLimiter is shared IP, max 20/15 minutes, and is NOT disabled in test; baseline auth smoke consumes requests. OTP limiter is max 5 per IP+phone; global limiter alone skips test mode. Partition verification cases into explicitly restarted process batches, with readiness/cleanup proofs, rather than silently raising production limits or counting 429 as intended business denials. Dedicated bounded limiter cases run in fresh processes and expect 429/no new OTP/user state.
- Extend snapshots/reset to synthetic User fields and OTP records; redact volatile lastSeenAt intentionally, with documented reason. Track dynamically created user IDs and use reserved phones. Restore fixtures after inactive/deleted-user tests. Never broaden cleanup to unrelated records.

### Required cases and assertions

| Priority / surface | Concrete scenarios | Required evidence |
| --- | --- | --- |
| **P0 `/verify-msg91-token`** | In a separate local process only, dummy non-secret MSG91 key with outbound requests blocked. Submit fabricated JWT-shaped token for a synthetic phone, invalid signature, expired payload, and mismatched body phone; test missing key and malformed/empty input controls. Never allow opaque-token provider fallback to contact MSG91. | Secure invariant: no tokens/user verification from an unverified identity. Source fast path is already a defect; capture only booleans and fixture identity match if HTTP proves token issuance. Do not upload forged/raw tokens. Any need for provider verification remains deferred. A dummy-key exception must be tightly scoped to this supervisor; do not weaken existing suite credential guards. |
| `/request-otp` | Bypass-enabled no-SMS process: valid fixture phone, repeat invalidates old record, malformed/missing/array/object phone, response field minimization, bounded per-phone/IP limit. Bypass-disabled credential-free process: valid request reaches safe 503 before network. | Hash stored (never raw code), correct phone association/expiry, prior isUsed=true, no user creation, no OTP/hash response, exact count effects and no external calls. Provider failure currently may leave hashed OTP: record rather than assume rollback. |
| `/verify-otp` | Bypass-disabled model-seeded records: correct, wrong, third wrong lockout, then correct after lockout, expired, used/deleted/replay, no issued record, superseded record, different phone, onboarding/new versus existing user, inactive user. Include a bounded simultaneous replay later. | Status plus exact token subject verified locally, protected `/users/me` control, no cross-phone issuance, attempts/deletion, no duplicate user. Assert no usable session for inactive account; distinguish token issuance from protect rejection. No sleep for TTL: seed expiresAt in past and verify query filtering. |
| `/refresh` | Valid local refresh; missing/malformed/expired/wrong-key/access-token-as-refresh; absent/inactive user; foreign caller/body userId injection; repeated refresh. | Access token maps only to verified refresh subject and works at `/users/me`; denied responses expose no token and cause no credential/user changes. Current refresh is stateless and nonrotating: replay alone is a documented hardening/design decision, not automatic test failure. |
| `/logout` | Own device removal, absent token, unknown token, replay, another user's FCM token, forged body userId, anonymous/expired access; multi-device tokens. | Only authenticated user's matching token removed; other devices/users unchanged. Existing access/refresh JWTs remain valid by current documented stateless design. Treat revocation policy as hardening/manual contract decision, not invented logout promise. |

Exit: all new cases executed in isolated CI, identities and side effects verified, provider calls proven absent, no ambiguous 429 masking, old suite results preserved and each new observation reviewed against source. No target pass count is promised.

## Phase 2 — profiles, lookup and user-derived authorization

Proposed `scripts/security/suites/users-profiles.js`; extend full User reset before any writes. Use self, same institution only, active shared-space member, DM peer, pending/accepted/blocked request peer, unrelated opted-in/out, inactive and not-onboarded identities.

- GET `/:id`: inventory exact public keys vs self; test inactive/non-onboarded/foreign/absent/malformed IDs and anonymous denial. `toPublicProfile` currently includes notifications and lastSeenAt; establish intended public field policy and flag excessive fields without assuming all authenticated foreign-profile reads must be denied. Phone, fcmTokens and OTP data must never escape.
- GET `/lookup`: reserved phones in supported forms; malformed/absent/self/inactive; request metadata bound to caller-target pair, not a third party; verify canMessage/canRequest distinctions and blocked combinations. Compare lookup vs createRequest rather than trusting advertised flags. No random real-phone enumeration.
- GET `/search`: shared space/DM/institution union, removed membership, archived DM, inactive users, minimum length and escaped regex, `spaceId` intersection and foreign-space membership inference. Pair every exclusion with an authorized canary result.
- GET `/me/needl` **P1**: private root with replies and excluded same-space B; valid member control; revoked/archived/deleted/threadId cross-binding variants. Source `getNeedl` includes all channels in member spaces: urgently test preview confidentiality, independently of message read denial.
- PUT `/me`: allowed fields persist only to caller; reject/ignore `_id`, phone, isActive, isVerified, explicit isOnboarded, fcmTokens and invented admin fields; validate computed onboarding. Medical role selection must not elevate space roles. Notification preference merging, nested injection and false/true opt-in changes must restore exactly after each case.
- PUT availability/FCM: own-only writes, enums/types/lengths, synthetic FCM dedup and five-token cap, sibling preference preservation; tie logout tests to device lifecycle. No push provider activation. Presence recipient checks belong in a later socket batch.

## Phase 3 — membership, invitations and consent

Proposed `scripts/security/suites/space-lifecycle.js`, plus small group-DM/handoff additions. Use owner, independent admin, ordinary member, outsider, pending joiner and removed member; do not confuse medical roles with space roles.

- POST spaces: caller-derived owner/member identity despite injected createdBy/members/settings/inviteCode; exactly three correctly bound default channels, no foreign resource change.
- Invite regeneration: owner/admin succeeds, member/outsider/anonymous denies; old code immediately fails join/preview, new code works. GET invite preview returns only intended summary without private channels, messages, member identities or clinical data. Never follow returned hard-coded Railway joinUrl.
- Join: valid/invalid/malformed code, case normalization, inactive space, duplicate membership, requireApproval pending state/replay, forged owner/admin fields. Pending joiner must not read space/channel/messages. No approval endpoint exists in this inventory: do not invent one or claim model-seeded approval as API execution.
- Leave/removal: member leaves self only; outsider/replay semantics; owner leave/removal denied; independent-admin permissions and owner protection. Verify immediate REST revocation for detail/list/message/search/Needl and private channel references. Channel/space socket eviction is separately assessed against known S9, including existing clients.
- **Group DM consent (P1):** POST `/channels/dm/group` with two eligible peers, duplicates/self, 1/8/9 others, malformed/inactive/absent targets, mixed allowed/forbidden targets and no partial channel on denial. Source accepts request-eligible peers without acceptance; test whether this enables message/read-receipt access before consent, and whether group membership subsequently makes `canMessageUser` approve a 1:1 pair. Confirm product consent policy before conflating group invitation with 1:1 acceptance.
- **Handoff notes/reassign (P1):** draft/submitted/acknowledged matrices for sender/current assignee/former assignee/admin/outsider; same-space/inactive/foreign new assignee, replay, note kind/author injection. Assert assignmentHistory, acknowledgement reset, writeBackNotes identity and notification audience. Removed participants retaining source-authorized access need explicit lifecycle policy review.

## Phase 4 — remaining bounded HTTP and realtime work

Test reactions and private pin/unpin with channel/message binding, positive toggles, duplicate/no-op behavior and removed/archived users. Test mentions using fixture recipient canaries and DB notifications; no FCM. Add support ownership/type/length validation and SupportTicket cleanup. Dev routes need both enabled local auth boundaries and disabled production-configuration guard tests in a separately supervised, entirely local process; `ENABLE_DEV_TOOLS` override is a configuration contract, not permission to use production services. Inspect `/join/:code` for escaping/deep-link construction without following any external URL. Platform status routes are lower priority than identity/consent surfaces.

Realtime next: recovery replay (`skipMiddlewares=true`), established-token expiry/deactivation, stale space rooms, cached typing memberships, presence privacy and multi-device lifecycle. Use fresh client instances and unique canaries; clear or expire test caches via process isolation. Malformed payloads that may crash the process require a dedicated disposable supervisor and restart, never an unsupervised case in the 352-case runner. Live Cloudinary/SMS/widget-provider semantics remain intentionally deferred.

## Completion and continuation contract

Start with Phase 0, then the P0 widget check and Phase 1 auth/session batch; do not combine every phase into one large suite. Use existing origin/master only, never write upstream, and leave unrelated Flutter/Android edits alone. Per batch: verify manifest IDs, syntax, isolation guards and selective cleanup; run isolated hosted workflow; retain sanitized four reports and source/run/artifact hashes; classify every new observation; regenerate route coverage and update SECURITY_AUTOMATION_PROGRESS.md. Infrastructure/control failures block; observations remain non-gating. Application fixes require a separate request.
