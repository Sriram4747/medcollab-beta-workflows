# Functional regression decision ledger

Status at Batch 0, tested source target `da2baff` (full SHA in progress document). No developer approval is inferred from source behavior. Affected cases retain executable safe subassertions where implemented; disputed assertions report `NEEDS_DECISION` until an authorized product decision is recorded here and included in the harness fingerprint.

## Reproduced application defects on `da2baff621fe03b21e614965bdb77510f32a62b9`

The unchanged sanity suite failed `message-requests-01` because the request notification was not persisted: backend logging reports `MessageRequest` rejected by the notification `referenceType` enum. `message-requests-02` returned HTTP 500 on acceptance because MongoDB could not infer the twice-matched `members` query path in `findAndModify`. Four dependent direct-conversation sanity cases were blocked. These are observed defects, not product decisions or accepted contracts. `FR-REQ-02` uses a directly seeded accepted-request prerequisite to test independent rejection boundaries while the original acceptance failure remains visible in the sanity lane.

`FR-DM-01` also fails on this target: the single-other-user `/api/channels/dm/group` call never responds within the measured 10-second request deadline after an accepted A/B prerequisite is model-seeded. The same module's 9-member group cap case passes, so the failure is specific to the one-peer delegation path. The timeout is an application FAIL, not Q7 approval and not an environmental ERROR.

While preparing `FR-PRO-04`, a live `POST /api/channels/dm` also returned HTTP 500 after an accepted A/B request was seeded. The backend logged the same twice-matched `members` path inference error as request acceptance. The profile projection case now explicitly seeds an existing direct channel and verifies updated public, DM, channel-member and space-member views; it does not credit direct-DM creation. This observed failure remains an application defect for the direct conversation catalog cases.

`FR-REQ-04` now executes a real decline and verifies that repeat decline and opposite accept are rejected. Its real accept branch returns HTTP 500. The request's stored status becomes `accepted`, pending count drops to zero, repeat accept/opposite decline reject, and no direct channel exists. This is observed partial state under Q7, not an approved atomicity or recovery contract. The case remains FAIL.

`FR-SPC-06` proves a post-revocation room defect: after B leaves and C is removed, database membership, lists and search exclude both. Explicit `sync_space_rooms` acknowledges zero spaces, but the still-connected B and C sockets both receive A's correlated space presence event. Reconnected sockets do not receive that event. The post-sync leak is a FAIL; Q10 remains open only for the intended *immediate* eviction guarantee before sync.

`FR-DM-09` issues simultaneous group reopen requests and observes two persisted exact-membership group channels on this run. Concurrent pair intents both return HTTP 500 from the direct upsert path. The case remains FAIL. Group creation's required idempotency policy is still Q7; this observed duplication must not be described as successful or approved behavior.

`FR-REQ-05` uses a one-shot `findAndModify` failpoint on disposable MongoDB to interrupt acceptance after the request status write. The request persists as accepted with no DM; reloading shows that split state, and a retry returns 400 without recovery. This is a Q7 `NEEDS_DECISION` case with verified subassertions, while the independently reproduced natural acceptance failure remains a FAIL in `FR-REQ-04` and retained sanity.

`FR-DM-05` through `FR-DM-07` document Q2 copy behavior under a fixed UTC server timezone: today selection starts at server midnight; all-history selects the oldest 500 non-deleted roots from 501 eligible records; the destination preview points to a source message ID. A copied thread reply has no `threadId`, and a copied quote retains the source root ID, so the copied thread and quote target cannot open as a connected graph in the destination. These cases remain `NEEDS_DECISION` for the intended copy, cap and timezone contract. `FR-DM-08` independently confirms an existing destination is reused without importing later source history.

| Question | Decision needed | Status | Safe verified scope pending decision |
|---|---|---|---|
| Q1 | Whether edit/delete changes channel preview, quote snapshots and thread aggregates | NEEDS_DECISION | Assert primary message persistence, edited/deleted state and events; record derived views. |
| Q2 | Expanded conversation copy graph, 500-item cap, timezone and source references | NEEDS_DECISION | Assert source records unchanged, destination membership and independently observed copy IDs. |
| Q3 | Draft handoff visibility across received list, detail, history and search | NEEDS_DECISION | Assert draft owner and patient persistence; capture each audience response. |
| Q4 | Stable cursor contract for space handoffs ordered by shiftDate and ID | NEEDS_DECISION | Assert source handoffs and ordered first page; capture repeated/missing IDs. |
| Q5 | Supported local/provider media formats and complete upload-to-message pipeline | NEEDS_DECISION | Assert exact upload bytes and metadata; report send incompatibility as observed, not supported success. |
| Q6 | Referenced media deletion, retention and dangling-reference UX | NEEDS_DECISION | Assert deletion endpoint effect on stored bytes and separately capture references. |
| Q7 | Idempotency/atomicity for concurrent creation, response loss and partial accept | NEEDS_DECISION | Assert persisted identities/resources after each operation; capture duplicates or partial state. |
| Q8 | Availability note/until convergence in socket payload | NEEDS_DECISION | Assert persisted availability and record peer event fields. |
| Q9 | Quiet-hour timezone and disabled-emergency push policy | NEEDS_DECISION | Assert fake push decision at controlled server time; record boundary and preference ordering. |
| Q10 | Immediate room eviction on membership removal | NEEDS_DECISION | Assert DB membership and post-sync/reconnect rooms; record pre-sync events. |
| Q11 | Draft/bookmark/recent/cache scope across logout and account switch | NEEDS_DECISION | Assert stored values for the active identity and capture cross-account visibility. |
| Q12 | Handoff acknowledgement wording and local-day overdue labels | NEEDS_DECISION | Assert persisted handoff status and controlled-clock client labels separately. |
| Q13 | Forwarded message-link target and media forwarding contract | NEEDS_DECISION | Assert copied link string and submitted forwarding payload; capture route handling. |
| Q14 | Pending approval/admin setting UX without management routes | NEEDS_DECISION | Assert pending request persists without membership and capture client state. |

## Source drift review

Planning inspected fork baseline `a4340b3da1aa628a9722622bd42a7903c33df45c`. A read-only fetch of upstream master on 9 October 2026 resolved `da2baff` and introduced five commits (`77b6d2d`, `97d90fe`, `7a0ae10`, `eac2e92`, `da2baff`) since that baseline. The source changes include authentication OTP, channel/DM access and upsert, handoff, media, message requests, message/thread models, notifications, search, profile, validation, and several Flutter message/media files. New source code attempts atomic DM upsert and modifies notification schema; the historical `message-requests-01`/`-02` failures apply only to the saved older SHA and must be rerun. No Q1–Q14 decision is resolved by this code drift. All expected results remain the catalog oracles pending execution and product input.
