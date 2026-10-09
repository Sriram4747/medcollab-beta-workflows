# Upstream functional regression checkpoint

Pinned upstream: `da2baff621fe03b21e614965bdb77510f32a62b9`. Scope: 48 retained sanity plus 9 new Batch 2 cases. This is a partial catalog run and **not** backend-all success.

- PASS: 51
- FAIL: 2
- BLOCKED: 4
- ERROR: 0
- NEEDS_DECISION: 0
- Unimplemented catalog cases: 130

- **message-requests-01 FAIL:** Recipient message-request notification was not persisted within 5 seconds (request state was persisted).
- **message-requests-02 FAIL:** POST /api/message-requests/6ac8abc8e7a01d3ec18672d5/accept expected 200, received 500: {"success":false,"message":"Plan executor error during findAndModify :: caused by :: cannot infer query fields to set, path 'members' is matched twice","errors":[]}
- **direct-and-group-conversations-01 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-02 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-03 BLOCKED:** Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-05 BLOCKED:** Required request, conversation, or message fixture was not created.

The nine new cases all passed with independent module databases. The retained sanity failures remain application defects. See the JSON for each selected ID and seeded-prerequisite disclosures.
