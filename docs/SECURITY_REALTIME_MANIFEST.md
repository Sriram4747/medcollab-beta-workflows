> Execution update, 2026-09-26: The focused subset documented in [the expansion report](SECURITY_EXPANSION_2026-09-26.md) has now run in real isolated CI, run 36225164443. The broader original plan below is retained; unimplemented variants are not credited as executed. See the report for exact cases, confirmed roots and explicit deferrals.
# Socket.IO security implementation manifest

Planned, not implemented or executed. Source a0b1f72, reviewed 2026-09-25. Use actual registered handlers, not constant names alone.

## Event and identity inventory

`socket/index.js` authenticates handshake.auth.token using authenticateSocket: signed-token expiry and active DB user. userId/name are attached from that user, not client identity fields. No requireOnboarding check. Initial connection queries active space memberships; presence registration joins user:<id>; join_channel uses canAccessChannel (DM members, space members, private member/admin, nonarchived channel). Space IDs come from DB. Leave operates on the caller's socket.

| Direction | Event / payload | Source and behavior |
| --- | --- | --- |
| client -> server | join_channel {channelId}; leave_channel {channelId} | message.handler; join checks access and emits join_channel success or error; leave has no acknowledgement |
| client -> server | typing_start/typing_stop {channelId} | message.handler; broadcasts user_typing/user_stopped_typing with server user identity; no access check |
| client -> server | sync_space_rooms (no required payload) | space.handler -> spaceRooms; queries DB, joins current spaces, presence snapshot and success; does not remove obsolete room memberships |
| client -> server | update_availability {status,until,note} | presence.handler; status enum then current-user DB update; no REST note-length validator; broadcast through socket.spaceIds |
| lifecycle | disconnect(reason) | presence map tracks multiple sockets, emits offline only after last socket, updates lastSeenAt |
| server -> client | authenticated {userId,connectedAt,spaceCount}; error {message} | connection/handler responses; invalid handshake yields connect_error, not an implemented auth_error exchange |
| server -> client | new_message; message_updated; message_deleted | REST persistence triggers socket emission. new_message targets channel room plus user rooms; group recipient fallback uses all space members |
| server -> client | user_typing; user_stopped_typing; presence_update | Handler outputs, not client-authorized input operations |
| server -> client | new_notification; handoff_submitted; handoff_acknowledged; space_member_joined | Notification/handoff/space REST producers; audience must be checked independently |

`send_message`, `authenticate`, `auth_error` constants have no inbound handlers here. No inbound socket receipt/read event found; receipts are POST `/api/channels/:channelId/messages/read` and persisted readBy, with no direct receipt emit in that controller. Test attempts to inject existing server event names as no-ops, not as invented supported APIs.

Recovery configured for 120 seconds with skipMiddlewares=true. Identity is stored on socket.userId/userName, not socket.data; recovered connections skip handler registration. Whether identity/listeners survive, setup disconnects, or buffered packets leak is UNKNOWN pending runtime testing; do not assert that recovery bypass necessarily works. Established connections do not periodically reverify account/token. Sync adds rooms without leaving old ones.

## Execution contract

Same real CI backend and disposable Docker DB. Add pinned compatible socket.io-client test dependency and one serial suite inside existing workflow. A owner, B member, separate admin J, C other space, D same-institution nonparticipant, E/F independent seeded DM, unonboarded K, inactive I. Add private channel excluding B/D, archived channel and separate public channel. Authenticate via real test-only OTP; generate only test-key malformed/expired/wrong-purpose variants. No production credentials or traffic.

Start listeners before triggers; require authenticated and join success where supported. Label unique canaries, correlate resource IDs and actor IDs, wait for allowed-recipient control and bounded quiet window (e.g. 1500 ms, report duration), then REST/DB readback. Repeat missing control as infrastructure failure, never count silence as a pass. Keep socket/async side effects settled before per-case reset. Record event counts and sanitized membership relations, never handshake tokens, recovery credentials or raw packets. Close every socket and clear collectors per case.

| ID | Trigger / permutations | Required invariant and evidence |
| --- | --- | --- |
| RT-01 | Connect missing/malformed/expired/wrong-key/refresh token, deleted/inactive user; valid A control | Rejected connections receive no canary events and establish no usable identity. Active control authenticates as A; CORS rejection alone is not auth evidence |
| RT-02 | Valid A token plus forged userId/name/spaceIds in handshake and event bodies; unonboarded K | Server identity stays A. Measure onboarding REST/socket difference; a connection alone is not proven unauthorized resource access |
| RT-03 | join_channel as member/admin/private outsider/foreign-space/foreign-DM/anonymous; archived/absent/malformed channel IDs | Authorized positive receives canary, excluded observers do not; compare identical REST GET messages. Medical role alone grants no DM access |
| RT-04 | leave_channel own room, arbitrary room-prefixed string, replay join/leave | Only caller socket membership changes. Account user-room fallback may still legitimately deliver messages after leave; test channel-only message_updated as separate control |
| RT-05 | typing_start/stop into allowed/foreign/private/DM without join and after denied join, forged userId | Victim must not receive unauthorized typing; if observed attribute to actual attacker identity, not forged identity. Strong source lead, unexecuted |
| RT-06 | REST POST/PUT/DELETE/react messages with allowed/excluded watchers in channel and personal rooms | Payload resource/audience matches authorized REST visibility. Specifically excluded same-space member must not see private new_message fallback. Authorized duplicate delivery is not itself disclosure |
| RT-07 | Emit existing server-only new_message/message_updated/message_deleted/presence_update/new_notification/handoff events from client, plus unhandled send_message | No persistence or relay to victims. Confirm control REST event delivers; constants do not create inbound authorization paths |
| RT-08 | POST DM messages/read with own/foreign/mixed/repeated messageIds and privacy-disabled actor; then GET messages | Only permitted channel receipts for real caller persist; no spoofed reader IDs. 200 ignoring foreign IDs and disabled receipts is expected if unchanged. Do not wait for nonexistent receipt event |
| RT-09 | update_availability status enum, long/non-string note, malformed until, forged target; compare PUT /api/users/me/availability | Only caller changes; compare validation/serialization. Overlength metadata alone is hardening unless impact shown; bounded payloads, no load test |
| RT-10 | Connect multiple A sockets, disconnect one then last; sync_space_rooms with forged space list | No false offline while another device lives; presence snapshot only current authorized spaces; supplied IDs cannot select another user's room. Presence scope/privacy needs product policy |
| RT-11 | Join then REST leave/remove member/archive channel; send canaries before and after sync | Removed user receives no new protected content through stale space/channel/personal room; independent fresh REST denial controls revocation |
| RT-12 | Temporary transport loss eligible for recovery vs explicit disconnect/fresh reconnect; revoke membership/deactivate/expire token while away; produce canary during gap | Record recovered flag, identity, handler readiness and any replay. No post-revocation protected delivery. Setup failure is reliability evidence; absence of handlers does not prove safe recovery |
| RT-13 | Repeated authenticated reconnect and sync; repeat typing/availability at bounded count | No identity migration, unintended room expansion or duplicate listeners. At-least-once delivery/replay within still-authorized audience is not automatically a vulnerability |
| RT-14 | Actual inbound events with null, missing argument, string, array, missing ID, invalid ObjectId/object, bounded oversized note | Server remains healthy and other authorized socket still works; no unauthorized write/emit. Destructuring before try is a source lead; unexpected error alone is not proven broad DoS |
| RT-15 | REST handoff submit/acknowledge, space join and notification trigger with participant/nonparticipant sockets | Event audience and disclosed fields match reviewed space/participant policy. Space-level announcement is not presumed participant-only; full sensitive payload requires explicit review |

Prioritize RT-03/05/06/11 before broad payload variation. Pair every denial with a real authorized control. Include rejected sockets, unauthorized recipient events and DB state in report, beyond current snapshot coverage. Recovery and malformed-payload cases may disrupt the disposable process: run separately at suite end with health check/restart and fresh fixtures. No realtime assertion may be marked executed from static inspection or a REST pass alone.
