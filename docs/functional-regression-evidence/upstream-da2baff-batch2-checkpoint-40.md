# Upstream functional regression checkpoint

Pinned upstream: `da2baff621fe03b21e614965bdb77510f32a62b9`. Scope: 48 retained sanity plus 40 new Batch 2 cases. This is a partial catalog run and **not** backend-all success.

- PASS: 73
- FAIL: 6
- BLOCKED: 4
- ERROR: 0
- NEEDS_DECISION: 5
- Unimplemented catalog cases: 99

- **message-requests-01 FAIL:** Recipient message-request notification was not persisted within 5 seconds (request state was persisted).
- **message-requests-02 FAIL:** POST /api/message-requests/6ac8efb1019ff02ce229770f/accept expected 200, received 500: {"success":false,"message":"Plan executor error during findAndModify :: caused by :: cannot infer query fields to set, path 'members' is matched twice","errors":[]}
- **direct-and-group-conversations-01 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-02 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-03 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-05 BLOCKED:** Required request, conversation, or message fixture was not created.
- **FR-SPC-03 NEEDS_DECISION:** Q14: pending-join client state and approval completion need product decision
- **FR-SPC-06 FAIL:** Explicit room sync left revoked users subscribed to a space room
+ actual - expected

  [
+   true,
+   true
-   false,
-   false
  ]

- **FR-REQ-04 FAIL:** POST /api/message-requests/6ac8f008494a7a2de326de3c/accept expected 200, got 500
- **FR-REQ-05 NEEDS_DECISION:** Q7: recovery or atomic rollback contract for accepted-without-DM state requires product decision
- **FR-DM-01 FAIL:** POST /api/channels/dm/group transport timed out after 10000 ms
- **FR-DM-05 NEEDS_DECISION:** Q2: intended client timezone for today expansion needs product decision
- **FR-DM-06 NEEDS_DECISION:** Q2: 500-item oldest-first cap and source-ID destination preview require product decision
- **FR-DM-07 NEEDS_DECISION:** Q2: copied thread and quote graph remapping requires product decision
- **FR-DM-09 FAIL:** POST /api/channels/dm expected 200, got 500; concurrent group records observed: 2

The FAIL results preserve request notification, acceptance, room-revocation and direct-conversation defects. Q2, Q7 and Q14 cases record verified subassertions while disputed contracts remain NEEDS_DECISION. See the JSON for each selected ID and seeded-prerequisite disclosures.
