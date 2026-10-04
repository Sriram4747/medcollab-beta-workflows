# Defensive security regression expansion — 2026-10-04

[run 37175207493](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37175207493), executed source `e89f8848fee4c21f3de91e31469ae61837f13bd8`: **691/691 executed, 611 passes, 80 observations; infrastructure healthy.** Exact HTTP operations exercised: **77/77 (100%)**. These are bounded route contexts, not complete security assurance.

Added **65 append-only cases, VOCLE-627–691**: developer/platform HTTP 22, realtime lifecycle 32, cross-module lifecycle six and optional authentication hardening five. All 626 previous positions/expectations and pass/observation/status outcomes remain unchanged (566 passes, 60 observations). Original 386 manifest pin remains; the full 626-case pin is now enforced. Application source and dependencies were not changed.

## Remaining HTTP decisions and execution

| Previously uncovered operation | Actual security boundary tested |
| --- | --- |
| POST /api/dev/seed-conversation | Production disabled guard; enabled anonymous/inactive denial; authenticated body identity/resource injection cannot redirect the synthetic write |
| POST /api/dev/seed-handoff | Same configuration/auth guards; generated draft binds caller, caller space and its general channel |
| POST /api/dev/seed-notifications | Same configuration/auth guards; expected authenticated caller-only seed remains an observation because generated records omit required reference fields |
| GET / | Exact public field allowlist and security headers; no user or secret data |
| GET /api | Public metadata field allowlist, relative API hints and security headers |
| GET /join/:code | Synthetic valid/short codes; canonical A-Z0-9 sanitization in HTML, script and URL contexts; no membership side effects |
| GET /health | Dedicated metadata minimization and disabled-provider/database controls; now credited as an actual discovery case |

**No explicit HTTP inventory operation is intentionally uncovered.** Socket.IO, static media and implicit HEAD/OPTIONS are outside the 77-operation denominator. Prior support, message/reaction/pin/mention and space lifecycle cases are preserved, not duplicated. Observations count as exercised.

Production configuration tests use unchanged Express routes, real Mongoose and Socket.IO in a narrowly guarded loopback configuration entrypoint. The ordinary production server entrypoint requires configured Cloudinary; it is not booted with dummy credentials. This verifies middleware configuration/auth boundaries, not a full production deployment. Normal realtime and crash probes start the actual src/server.js with NODE_ENV=test and OTP_BYPASS=false. All child services share only the disposable local vocle_ci DB.

## Realtime and cross-module coverage

VOCLE-649–680: signed token subject/not-before/class rejection; expiry versus fresh connection; live deactivation; documented FCM-only logout; multi-device final-disconnect presence; shared-space presence/snapshot privacy; removed space recipients before/after sync; fresh reconnect isolation; private membership revocation; isolated typing cache revocation; public-channel/DM full-message audiences; message-request notification recipient devices; server-attributed typing/availability identities; enum rejection and bounded presence replay; five null-payload robustness cases; malformed channel ID; three transport recovery/replay lifecycle cases.

VOCLE-681–686: invite→join→leave→existing channel delivery; space revocation versus independent DM entitlement; accepted request→DM audience isolation; handoff reassignment→new-assignee notification and former-party denial; private mentions→outsider/excluded-member realtime preview delivery.

VOCLE-687–691: two overlapping OTP verification requests through actual HTTP, deleted-account refresh, omitted/unknown FCM logout and expired access-token logout. OTP verification uses a real hashed model record, OTP_BYPASS=false, no SMS/provider delivery. Each successful credential response is independently checked at protected profiles and only booleans/counts are retained; distinct token values or sessions are not asserted.

Predicate-matched listeners precede triggers. Successful auth/REST/delivery controls are required, normally bounded at five seconds; exclusion windows are explicitly one second. Missing controls fail execution prerequisites. Expiry uses a controlled signed exp and bounded deadline, not arbitrary sleeps. Recovery asserts private protocol session/offset availability, distinguishes recovered from fresh clients, and correlates one protected edit produced while disconnected. Raw tokens, recovery credentials, packets and child logs are not written to artifacts.

The cache probe uses a fresh child and a personal-room-only warmup before channel join, proving the lookup completed. Null-payload probes each use a fresh real backend child, positive pre-trigger controls and explicit exception/rejection/exit diagnostics. Confirmed exit code 1 is an application observation; the main server remains healthy. Async rejection cases verify child health and a subsequent real edit delivery, so they are not claimed as proven production crashes.

## Reviewed new observations

1 hardening / developer helper contract; 1 session expiry policy review; 16 confirmed security defect; 2 hardening / socket input handling.

| Testcase | Classification / root | Review and limit |
| --- | --- | --- |
| VOCLE-641 | hardening / developer helper contract / DEV_NOTIFICATION_REFERENCES | Developer notification seed omits required referenceId/referenceType in generated samples. Mongoose rejects the route with 400 before any notification persists; the success expectation and ownership check remain intact. Functional helper failure, not a confirmed data-isolation defect; authentication/configuration denial guards pass. |
| VOCLE-653 | session expiry policy review / SOCKET_EXPIRY_POLICY | Expired tokens reject REST and fresh sockets. Existing socket availability writes continue under documented handshake-only authentication. Automatic mid-session expiry enforcement needs a policy decision. Not a confirmed access-control defect; tokens and the controlled subject are synthetic. |
| VOCLE-654 | confirmed security defect / R1_ACTIVE_SOCKET | REST and new connections reject the deactivated user, but the established socket can persist availability or acknowledge a protected channel join. Event handlers lack active-user revalidation. Availability and room-join actions only; no application remediation. |
| VOCLE-655 | confirmed security defect / R1_ACTIVE_SOCKET | REST and new connections reject the deactivated user, but the established socket can persist availability or acknowledge a protected channel join. Event handlers lack active-user revalidation. Availability and room-join actions only; no application remediation. |
| VOCLE-659 | confirmed security defect / R2_SPACE_PRESENCE | Removed space member receives a subsequent matched presence update. Explicit sync returns zero spaces but only adds rooms and does not leave the old space room. Canary presence privacy is proven; no unrelated medical data inference asserted. |
| VOCLE-660 | confirmed security defect / R2_SPACE_PRESENCE | Removed space member receives a subsequent matched presence update. Explicit sync returns zero spaces but only adds rooms and does not leave the old space room. Canary presence privacy is proven; no unrelated medical data inference asserted. |
| VOCLE-662 | confirmed security defect / S9 | REST denies revoked private-channel or invite/leave membership, yet the existing socket receives a matched protected message edit. Extends the established stale channel-room root. Private-channel membership removal is a controlled model transition because there is no dedicated member-removal API; invite/leave uses real REST. |
| VOCLE-663 | confirmed security defect / R3_TYPING_CACHE | After DM participant removal and channel leave, typing_stop still reaches the removed peer through a cached personal-room recipient list. Independent REST denial and active viewer delivery controls hold. Fresh supervised server isolates the 60-second cache; final control warms via personal room before channel join. |
| VOCLE-672 | hardening / socket input handling / SOCKET_ASYNC_PAYLOAD | Null payload destructuring happens outside the async handler try/catch and produces a logged unhandled rejection. Test-mode child remains healthy and continues a real edit delivery. Production shutdown behavior is source-only; no production runtime or denial of service is claimed for these async cases. |
| VOCLE-673 | confirmed security defect / R4_SOCKET_CRASH | An authenticated null leave/typing payload causes an uncaught exception and exit code 1 in the real backend child. Positive pre-trigger controls and explicit exit evidence prove availability loss. Crash probes are isolated secondary test-mode servers; the main discovery backend stays healthy and later cases use fresh child processes. |
| VOCLE-674 | confirmed security defect / R4_SOCKET_CRASH | An authenticated null leave/typing payload causes an uncaught exception and exit code 1 in the real backend child. Positive pre-trigger controls and explicit exit evidence prove availability loss. Crash probes are isolated secondary test-mode servers; the main discovery backend stays healthy and later cases use fresh child processes. |
| VOCLE-675 | confirmed security defect / R4_SOCKET_CRASH | An authenticated null leave/typing payload causes an uncaught exception and exit code 1 in the real backend child. Positive pre-trigger controls and explicit exit evidence prove availability loss. Crash probes are isolated secondary test-mode servers; the main discovery backend stays healthy and later cases use fresh child processes. |
| VOCLE-676 | hardening / socket input handling / SOCKET_ASYNC_PAYLOAD | Null payload destructuring happens outside the async handler try/catch and produces a logged unhandled rejection. Test-mode child remains healthy and continues a real edit delivery. Production shutdown behavior is source-only; no production runtime or denial of service is claimed for these async cases. |
| VOCLE-678 | confirmed security defect / R5_RECOVERY_AUTH | A transport recovery session replays a protected message edit after membership removal, deactivation or token expiry while independent fresh connection/REST checks deny access. skipMiddlewares restores rooms without revalidating auth. Recovery protocol session and packet offsets are asserted privately. Restored identity is missing in captured ack; future listener restoration is not exhaustively tested. |
| VOCLE-679 | confirmed security defect / R5_RECOVERY_AUTH | A transport recovery session replays a protected message edit after membership removal, deactivation or token expiry while independent fresh connection/REST checks deny access. skipMiddlewares restores rooms without revalidating auth. Recovery protocol session and packet offsets are asserted privately. Restored identity is missing in captured ack; future listener restoration is not exhaustively tested. |
| VOCLE-680 | confirmed security defect / R5_RECOVERY_AUTH | A transport recovery session replays a protected message edit after membership removal, deactivation or token expiry while independent fresh connection/REST checks deny access. skipMiddlewares restores rooms without revalidating auth. Recovery protocol session and packet offsets are asserted privately. Restored identity is missing in captured ack; future listener restoration is not exhaustively tested. |
| VOCLE-681 | confirmed security defect / S9 | REST denies revoked private-channel or invite/leave membership, yet the existing socket receives a matched protected message edit. Extends the established stale channel-room root. Private-channel membership removal is a controlled model transition because there is no dedicated member-removal API; invite/leave uses real REST. |
| VOCLE-685 | confirmed security defect / N3_MENTION_AUDIENCE | A private message mention delivers its matched preview and message reference as new_notification to an unauthorized outsider or excluded space member. Extends the established mention audience root with realtime evidence. No external push provider is enabled; only local socket disclosure is proven. |
| VOCLE-686 | confirmed security defect / N3_MENTION_AUDIENCE | A private message mention delivers its matched preview and message reference as new_notification to an unauthorized outsider or excluded space member. Extends the established mention audience root with realtime evidence. No external push provider is enabled; only local socket disclosure is proven. |
| VOCLE-687 | confirmed security defect / A1_OTP_CONSUMPTION | Two overlapping real verification requests accept the same hashed OTP and each return usable credentials for its synthetic subject; later sequential replay is rejected. OTP verify reads/deletes non-atomically. No provider delivery, handler monkeypatching or raw tokens retained; each successful credential response is independently checked at protected profile. Distinct token values or sessions are not asserted. |

Six newly exercised confirmed roots: established deactivated socket actions (R1); revoked space presence (R2); stale DM typing recipient cache (R3); null synchronous payload process exit (R4); authorization-skipping transport recovery replay (R5); non-atomic simultaneous OTP consumption (A1). Existing S9 stale channel rooms and N3 private mention audiences gain two cases each. No application remediation occurred.

The 60 baseline observations retain their reviewed dispositions. Mid-session expiry remains a policy question because source documents handshake-only auth. Logout token survival is supported current behavior and its ownership checks pass. Async payload rejections and the broken developer sample notification helper remain non-gating hardening/reliability observations. Existing public-field, search inference, consent, audit continuity, media and semantic ambiguities remain visible.

## Regression gate registry

The [registry](SECURITY_REGRESSION_GATES.md) and [JSON](SECURITY_REGRESSION_GATES.json) map all 80 observations to requirement, current status, fix status and activation rule: **51 confirmed-case candidates, 29 excluded observations, zero active strict gates**. All confirmed defects remain unfixed in the executed source. Activation requires an identified fix commit, audited/versioned secure assertions, healthy isolated controls and explicit developer activation. A passing run alone never activates a gate. Some legacy disclosure callbacks require a separately versioned secure denial assertion after fixes; do not silently rewrite frozen IDs or enable those callbacks unchanged.

## Harness repairs and hosted execution

First [run 37174533620](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37174533620), source 24364d03155add089dca5cdbe1fbabdc37a05d9a: 691/691, 610 passes, 81 observations, healthy, 77/77 routes. Its reports/review are preserved. VOCLE-668 incorrectly required userName on typing_stop, whose source contract emits channelId/userId only. The repaired assertion still requires the authenticated userId and requires the forged name to be absent. It is an assertion-contract repair, not an application fix or weakened identity rule.

Final [run 37175207493](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37175207493) retests corrected source. Additional harness refinements: personal-room cache warmup proof; developer validation-field capture; truthful native platform JSON/HTML versus normalized harness envelopes; socket semantic descriptions explicitly say HTTP not applicable. Workflow syntax validation includes new helper scripts; timeout raised from 15 to 20 minutes for bounded secondary process runs. No fixture/reset, startup, auth, transport, unexecuted-case or flakiness failure occurred in either hosted run. No app behavior was changed to pass tests.

## Deliberately deferred / excluded

- Provider/production integration testing is outside scope and remains disabled: no Railway, Atlas, Cloudinary, MSG91 or Firebase traffic; no real users/credentials.
- Full production startup cannot be exercised in this credential-free architecture because it requires configured Cloudinary. Configuration route guards are covered separately as described above.
- Socket metadata type/length parity, recovery future-handler restoration and duplicate/missed-event semantics, >60-second cache expiry, >120-second recovery expiry, multiple server instances/adapters, long-running concurrency/load and full archive/media reference combinations are not exhaustively covered by this bounded expansion.
- Browser/OS execution of deep links is excluded; the response sanitization/metadata contract is covered. No approval or ownership-transfer API is invented.
- Source fixes, unresolved policy decisions and activation of strict regression gates require separate developer work; current findings remain observations.

## Actual module counts

| Module | Executed | Pass | Observation |
| --- | --- | --- | --- |
| Baseline group, space, and handoff security | 146 | 141 | 5 |
| Cross-module | 8 | 6 | 2 |
| Developer and Platform HTTP | 22 | 21 | 1 |
| Direct Messages | 61 | 57 | 4 |
| Extended API | 49 | 43 | 6 |
| Lifecycle Cross-module Regression | 6 | 3 | 3 |
| Media | 31 | 22 | 9 |
| Message Requests | 36 | 36 | 0 |
| Optional Authentication Hardening | 5 | 4 | 1 |
| Phase 0 Repair Controls | 3 | 2 | 1 |
| Phase 1 Authentication and Session Lifecycle | 31 | 29 | 2 |
| Phase 2 Users and Profiles | 75 | 71 | 4 |
| Phase 3 Consent and Handoffs | 65 | 58 | 7 |
| Phase 3 Space Lifecycle | 53 | 51 | 2 |
| Phase 4 Bounded HTTP | 47 | 38 | 9 |
| Realtime | 21 | 12 | 9 |
| Realtime Lifecycle Regression | 32 | 17 | 15 |

## Files changed

- medcollab-backend/scripts/security/suites/: platform-http.js, realtime-lifecycle.js, lifecycle-chains.js, auth-hardening.js (new).
- medcollab-backend/scripts/security/: configuration-server.js, local-supervisor.js, socket-controls.js (new test helpers).
- medcollab-backend/scripts/: security-api-discovery.js and security-manifest-check.js updated; security-regression-registry.js added.
- .github/workflows/vocle-backend-environment-test.yml: helper syntax checks and bounded 20-minute timeout.
- docs/: SECURITY_AUTOMATION_PROGRESS.md, SECURITY_TEST_COVERAGE.md, SECURITY_TERRA_NEXT_PHASE.md, SECURITY_FINDINGS_2026-10-04.md, SECURITY_REALTIME_MANIFEST.md updated; this expansion report and SECURITY_REGRESSION_GATES.md/.json added.
- docs/security-evidence/37174533620/ and 37175207493/: four raw reports, execution.json and reviewed-observations.json retained per run. Temporary coordinator/report files and downloaded ZIPs are removed before completion.

## Evidence and safety

Artifact 11293500957, ZIP SHA-256 `b2ca8eb7d94cfd09cbd3c7f385d13dfad438e82eac55e1840826e7230f8208af`. Four unmodified generated reports, reviewed JSON and execution/hash metadata live under [37175207493](security-evidence/37175207493/execution.json). Previous evidence directories are preserved. Synthetic state and known disposable signing keys only; selective cleanup and bounded child termination retain the existing architecture. Only experimental origin/master was pushed; upstream is read-only and unrelated Flutter/Android worktree changes were untouched.
