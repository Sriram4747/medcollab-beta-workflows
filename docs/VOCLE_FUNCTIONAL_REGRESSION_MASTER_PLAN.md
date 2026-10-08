# Vocle functional regression master plan

Design-only inspection, 8 October 2026. No application changes, test implementation, provider calls, or workflow changes are part of this deliverable.

## Evidence and baseline

Inspected fork working tree based on `a4340b3da1aa628a9722622bd42a7903c33df45c`, branch `master`, origin `Sriram4747/medcollab-beta-workflows`. Upstream `mathiharan29/medcollab-beta` is read-only. This is a source audit, not a claim about the latest upstream or deployed application. Existing unrelated Flutter/Android modifications and untracked product-understanding documentation are excluded from commits.

The executable registry `tests/sanity/src/scenarios.js` contains **48 scenarios in 13 groups**. The scenario implementations, fixtures, provider preload, runner, reports and `.github/workflows/vocle-sanity.yml` were inspected. The registry's `planned` field is metadata, not proof that implementations are missing. Saved evidence `docs/security-evidence/37361869623/sanity-report.md` records **42 passed, 2 failed, 4 blocked**, against upstream `4638682c0c930fcde3378d7e809612b6c0eab370`, harness `4eb4c2a57bb0f47bb771321a44c2a283e546ef3e`. It is historical evidence, not a new execution.

The failed cases are `message-requests-01` (missing persisted request notification) and `message-requests-02` (DM upsert 500). Blocked cases are `direct-and-group-conversations-01`, `-02`, `-03`, `-05`. Fork fixes must never be copied into an upstream checkout to make these pass. Current sanity YAML has `workflow_dispatch` only; the older sanity plan's proposed daily schedule is not enabled there.

## Feature inventory: 23 modules

Paths below are relative to the repository. `B` = `medcollab-backend/src`; `F` = `medcollab-app/lib`. Actual operations, rather than route counts, define modules. Journeys are additional cases, not an additional feature module.

| # | Module | Implemented operations and limits | Source anchors | Status |
|---|---|---|---|---|
| 1 | Authentication/session | SMS OTP, widget token exchange, returning login, refresh, device logout | B/features/auth; B/services/otp.service.js; F/features/auth | Implemented; external delivery substituted |
| 2 | Profile/preferences | Onboard, update/read profile, notification preferences, avatar reference | B/features/users/user.controller.js/updateMe; user.model.js; F/features/profile | Implemented |
| 3 | Discovery/lookup | Known-user search, phone normalization, relationship/request flags | B/utils/knownUsers.js; B/features/users/user.controller.js/searchUsers,lookupByPhone; F/features/messages/presentation/pages/start_dm_page.dart | Implemented |
| 4 | Spaces/invites/membership | Create/default channels, preview/join/rotate invite, update, list/detail, member roles, leave/remove | B/features/spaces; F/features/spaces; F/features/members | Partial: pending approval stored, no approval or ownership-transfer route |
| 5 | Channels | Public/private create, detail/list/members, rename/description/admin-post setting, archive | B/features/channels; F/features/channels | Partial: no complete private-member administration UI/API |
| 6 | Consent/message requests | Create, incoming collision, list/count, accept with DM, decline | B/features/message-requests; F/features/messages/data/repositories/message_request_repository.dart | Partial: blocked status exists, no block/unblock action |
| 7 | Direct/group conversations | Self notes, pair reopening, exact group membership, alias route, rename, expansion none/today/all | B/features/channels/channel.controller.js/createOrGetDM,createGroupDM,expandDM | Implemented with copying limitations |
| 8 | Root messaging | Text/media metadata, ordered cursor pages, quotes, edit, soft delete, priority | B/features/messages; F/features/messages/presentation/cubit/channel_chat_cubit.dart | Partial: video send validator mismatch |
| 9 | Threads/Needl | Reply, detail/pages, reply count/preview, Needl discovery | B/features/messages/message.controller.js/getThread; B/features/users/user.controller.js/getNeedl; F/features/messages/presentation/cubit/thread_cubit.dart | Implemented; derived-state consistency needs tests |
| 10 | Reactions/pins/receipts | Reaction toggle, five pins, unpin, DM readBy and opt-out | B/features/messages/message.model.js; B/features/channels/channel.controller.js/pinMessage; F/features/messages/presentation/widgets/read_receipt_footer.dart | Implemented; no durable delivery receipt guarantee |
| 11 | Handoffs/patients | Embedded patients/tasks/attachments, draft edit/delete, submit, acknowledge, notes, reassign/history, personal/space filtering | B/features/handoffs; F/features/handoffs | Implemented; no patient registry or independent task-completion/roster model |
| 12 | Media | Local upload/download/delete, image/PDF/video provider branches, avatar replacement reference, picker/open | B/features/media; B/utils/localMediaStorage.js; F/features/media | Partial: local upload-to-message and video/provider deletion gaps |
| 13 | Notification inbox | Per-user persistence, counts, filters/pages, read/unread/channel/all/delete | B/features/notifications; B/services/notification.service.js; F/features/notifications | Implemented; request reference schema mismatch in historical target |
| 14 | Push/device tokens | Token dedup/cap/logout, preference and quiet-hours decisions, stale-token cleanup, local grouping/reply | B/services/notification.service.js; B/features/users/user.model.js/addFcmToken; F/core/notifications | Implemented integration code; real provider delivery unproven |
| 15 | Realtime/presence | Authentication, personal/channel/space rooms, join/leave/sync, typing, availability, multi-device online | B/socket; F/core/socket; F/core/presence; F/core/realtime | Implemented; two-minute Socket.IO connection-state recovery configured, distinct from durable replay |
| 16 | Global search | Messages/doctors/channels/attachments/handoffs, type/limit, matching patient title | B/features/search; F/features/search | Implemented; handoff visibility differs from detail |
| 17 | Support/developer tools | Bug/feature/feedback tickets, help/legal pages; dev notification/conversation/handoff seed | B/features/support; B/features/dev/dev.routes.js; F/features/support; F/features/dev | Implemented; no user ticket-status lifecycle |
| 18 | Startup/navigation/lifecycle | Splash/session routing, onboarding gate, tabs/back, resume socket restoration | F/main.dart; F/core/router; F/core/lifecycle; F/features/auth/presentation/bloc | Implemented |
| 19 | Composer/offline state | Optimistic send/failure, socket reconciliation, root/thread drafts, memory transcript cache | F/features/messages/presentation/cubit; F/core/storage/draft_message_service.dart; F/core/chat | Partial: no durable offline send queue |
| 20 | Saved/recent items | Local message/thread/handoff bookmarks, recent/pinned items, removal | F/core/storage/bookmark_service.dart; recent_items_service.dart; F/features/bookmarks | Local only; cross-device sync planned |
| 21 | Home/dashboard | Widget visibility/order/reset, assigned handoffs/tasks/shift summary, emergency/announcement previews | F/features/home | Implemented derived views; no separate duty roster |
| 22 | Forwarding/invites/deep links | Forward text plus source link/media URL; copy link; invite share/QR; push routing | F/features/messages/presentation/widgets/forward_message_sheet.dart; F/features/spaces; F/core/notifications/push_notification_router.dart | Partial: copied message-link target not implemented |
| 23 | Runtime/error recovery | Health, response envelope, bounded requests, server restart/reload, client failure states | B/app.js; B/server.js; B/middleware/errorHandler.js; F/core/network; F/shared/data/repositories/base_repository.dart | Implemented infrastructure behavior |

Not implemented coverage promises: calls/huddles, scheduled messages/reminders, longitudinal patient records, shift roster management, approval/ownership transfer, server-synced bookmarks/drafts, full offline handoff sync. Do not turn roadmap prose or stale controller comments into passing test expectations.

## Architecture and test tiers

- **Sanity:** retain all 48 IDs and existing assertions unchanged. These remain the fast broad smoke baseline; no proposed case silently replaces one.
- **B — backend regression:** real Express/Mongoose and disposable MongoDB, HTTP plus Socket.IO; test-owned provider transport fakes only. Read database for independent postconditions; never mutate DB to perform the behavior under test. Seed dates, roles, large histories, and fault prerequisites explicitly.
- **F — Flutter:** model/repository/bloc/cubit/widget integration with fake transport, controlled clocks, secure-storage/preferences doubles. Covers UI transitions, reconciliation and device-local persistence, not actual OS delivery.
- **D — device:** emulator/physical device with synthetic local backend and injected notification/picker inputs. Platform permission, lifecycle, file opener, QR and secure storage checks; no real Firebase/MSG91/Cloudinary use. Actual provider delivery remains outside this authorized environment.

Catalog fixture profiles and source anchors are normative. A row plus its shared profile constitutes one complete test specification. B includes retained sanity cases run in the dedicated regression lane; do not add the sanity count twice. Parameter tables exercise one behavioral boundary per case, not one inflated count per input.

## Coverage gaps and expectation policy

The existing suite tests business outcomes in many places, not merely 2xx. Weak spots include channel update checking only the mutation response, private-channel creator detail without list comparison, sparse negative boundaries, unread count without larger pagination/filter interaction, single-device presence, and expansion without today/copy-limit/history-reference checks. Extend with separate IDs rather than changing sanity semantics.

Saved failures are confirmed only for the saved SHA. Static findings below are hypotheses or contract conflicts until reproduced. Verified requirements fail CI even on first adoption; unknown behavior is reported `NEEDS_DECISION`, never silently accepted as passing. A required unresolved case prevents a full-coverage success manifest. An independently versioned verified subset can gate PRs, but must identify excluded cases and cannot claim full catalog validation.

Product decisions to record in the catalog:

| Question | Source conflict / decision needed |
|---|---|
| Q1 | Edit/delete does not update channel.lastMessage, quote snapshots or root reply aggregates consistently. Which views should retain snapshots versus reflect changes? |
| Q2 | Expansion uses server-local midnight, oldest 500 matching records, copies replyTo references, omits threadId, and lastMessage references source ID. Specify intended copy graph, truncation disclosure and timezone. |
| Q3 | Draft handoff visibility differs across received status filter, detail, space history and global search. Define role/view consistency. |
| Q4 | Space handoff cursor uses _id while ordering by shiftDate then _id. Define stable paging for backdated/future handoffs. |
| Q5 | Local media URLs fail message HTTPS/provider-host checks; video enum exists but send validation excludes it; picker offers extra document formats. Define supported end-to-end formats/storage. |
| Q6 | Media deletion does not clear message/avatar/handoff references; handoff-context ownership and video destroy behavior are incomplete. Specify dangling-reference UX and retention. |
| Q7 | Concurrent creates/retries and response-loss sends lack general idempotency. Define guarantees for pair/group/request/space/message creation and partial accept failure. |
| Q8 | Socket availability update persists note/until but broadcast helper is called with status only. Require full-field convergence or explicitly refresh clients. |
| Q9 | Quiet hours use server time, emergency bypass follows preference check. Confirm user timezone and disabled-emergency semantics. |
| Q10 | Removing/leaving space does not directly evict every connected room; sync/reconnect refreshes membership. Specify immediate UI/room convergence. |
| Q11 | Local drafts/bookmarks/recent/cache account switching and logout cleanup are not uniformly scoped. Define persistence across logout on a shared device. |
| Q12 | Handoff acknowledgement means a recorded action, not proven clinical attendance; client overdue labels are derived from local calendar day. Confirm wording/timezone and no automatic backend transition. |
| Q13 | Forwarded message links have no matching message-target router; media forwarding becomes text. Confirm intended supported behavior. |
| Q14 | Approval/admin settings exist without complete management routes; define pending-join UX and unsupported controls. |

## Incremental delivery status

Phase 1 inventory and baseline saved first. Phase 2 catalog, Phase 3 coverage reconciliation, and Phase 4 workflow/handoff are saved separately during this session. Final totals and implementation details are maintained in the companion documents.

