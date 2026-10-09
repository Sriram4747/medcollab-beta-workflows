# Upstream functional regression checkpoint

Pinned upstream: `da2baff621fe03b21e614965bdb77510f32a62b9`. Scope: 48 retained sanity plus 30 new Batch 2 cases. This is a partial catalog run and **not** backend-all success.

- PASS: 69
- FAIL: 4
- BLOCKED: 4
- ERROR: 0
- NEEDS_DECISION: 1
- Unimplemented catalog cases: 109

- **message-requests-01 FAIL:** Recipient message-request notification was not persisted within 5 seconds (request state was persisted).
- **message-requests-02 FAIL:** POST /api/message-requests/6ac8b8ce6b43e313a440fb15/accept expected 200, received 500: {"success":false,"message":"Plan executor error during findAndModify :: caused by :: cannot infer query fields to set, path 'members' is matched twice","errors":[]}
- **direct-and-group-conversations-01 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-02 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-03 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-05 BLOCKED:** Required request, conversation, or message fixture was not created.
- **FR-SPC-03 NEEDS_DECISION:** Q14: pending-join client state and approval completion need product decision
- **FR-REQ-04 FAIL:** POST /api/message-requests/6ac8be940925cb087f40f633/accept expected 200, got 500
- **FR-DM-01 FAIL:** POST /api/channels/dm/group transport timed out after 10000 ms

FR-SPC-03 verified safe subassertions and remains NEEDS_DECISION under Q14. The retained sanity request failures and FR-DM-01 timeout remain application defects. See the JSON for each selected ID and seeded-prerequisite disclosures.
