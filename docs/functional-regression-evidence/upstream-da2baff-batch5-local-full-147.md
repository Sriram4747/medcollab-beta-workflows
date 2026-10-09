# Vocle functional regression

- Scope: backend-all; source: upstream-read-only `da2baff621fe03b21e614965bdb77510f32a62b9`
- Result: **FAIL**; backend-all success: **false**
- PASS 109; FAIL 17; ERROR 0; BLOCKED 4; NEEDS_DECISION 17; SKIP 0
- Selected 147; executed 147; planned catalog 187 (B/F/D 147/32/8)
- Provenance PASS; cleanup PASS

- message-requests-01 **FAIL**: Recipient message-request notification was not persisted within 5 seconds (request state was persisted).
- message-requests-02 **FAIL**: POST /api/message-requests/6ac9408f56db68320fc0d222/accept expected 200, received 500: {"success":false,"message":"Plan executor error during findAndModify :: caused by :: cannot infer query fields to set, path 'members' is matched twice","errors":[]}
- direct-and-group-conversations-01 **BLOCKED**: Required request, conversation, or message fixture was not created.
- direct-and-group-conversations-02 **BLOCKED**: Required request, conversation, or message fixture was not created.
- direct-and-group-conversations-03 **BLOCKED**: Required request, conversation, or message fixture was not created.
- direct-and-group-conversations-05 **BLOCKED**: Required request, conversation, or message fixture was not created.
- FR-SPC-03 **NEEDS_DECISION**: Q14: pending-join client state and approval completion need product decision
- FR-SPC-06 **FAIL**: Explicit room sync left revoked users subscribed to a space room
+ actual - expected

  [
+   true,
+   true
-   false,
-   false
  ]

- FR-REQ-04 **FAIL**: POST /api/message-requests/6ac940f1f998e176d56a5177/accept expected 200, got 500
- FR-REQ-05 **NEEDS_DECISION**: Q7: recovery or atomic rollback contract for accepted-without-DM state requires product decision
- FR-DM-01 **FAIL**: POST /api/channels/dm/group transport timed out after 10000 ms
- FR-DM-05 **NEEDS_DECISION**: Q2: intended client timezone for today expansion needs product decision
- FR-DM-06 **NEEDS_DECISION**: Q2: 500-item oldest-first cap and source-ID destination preview require product decision
- FR-DM-07 **NEEDS_DECISION**: Q2: copied thread and quote graph remapping requires product decision
- FR-DM-09 **FAIL**: POST /api/channels/dm expected 200, got 500; concurrent group records observed: 2
- FR-MSG-01 **FAIL**: POST /api/channels/6ac94118a6c3381d1491b8be/messages expected 201, got 400
- FR-MSG-05 **NEEDS_DECISION**: Q1: derived quote snapshot and channel preview propagation after edit/delete needs product decision
- FR-MSG-08 **NEEDS_DECISION**: Q7: automatic duplicate prevention after a lost successful response needs product decision
- FR-THR-04 **NEEDS_DECISION**: Q1: expected thread aggregate correction after editing/deleting the latest reply needs product decision
- FR-SOC-01 **FAIL**: Switching emoji must replace B prior reaction
+ actual - expected

  [
+   '👍',
    '❤️'
  ]

- FR-HOF-05 **NEEDS_DECISION**: Q3: draft audience policy pending; receiver search includes current draft false
- FR-HOF-07 **NEEDS_DECISION**: Q4: shiftDate sort with ID cursor; expected ["6ac9416eb7d6de408cd7491c","6ac9416eb7d6de408cd74926","6ac9416eb7d6de408cd7492b","6ac9416eb7d6de408cd74921"], observed ["6ac9416eb7d6de408cd7491c","6ac9416eb7d6de408cd74926","6ac9416eb7d6de408cd7491c","6ac9416eb7d6de408cd74921"]
- FR-MED-01 **FAIL**: Unsupported files must be client errors, not HTTP 500
+ actual - expected

  [
+   500,
+   500
-   400,
-   400
  ]

- FR-MED-02 **NEEDS_DECISION**: Q5: octet-stream upload format/MIME contract pending; synthetic-octet.pdf:pdf/application/octet-stream, synthetic-octet.mp4:video/application/octet-stream
- FR-MED-03 **NEEDS_DECISION**: Q5: local upload URL is rejected by image-message policy; full upload→message pipeline has no successful local path
- FR-MED-04 **NEEDS_DECISION**: Q5: video upload succeeds, but video message type is rejected by the pinned source
- FR-MED-06 **NEEDS_DECISION**: Q6: profile points to replacement avatar; old file was deleted explicitly, automatic old-file lifecycle remains undecided
- FR-MED-07 **NEEDS_DECISION**: Q6: referenced local image/video bytes delete, handoff-context deletion is unsupported, and handoff attachment references remain
- FR-NOT-01 **FAIL**: Expected values to be strictly deep-equal:
+ actual - expected

+ Set(3) {
+   '6ac9413eb8c07e60f593df54',
- Set(2) {
    '6ac9413eb8c07e60f593df56',
    '6ac9413eb8c07e60f593df58'
  }

- FR-NOT-02 **FAIL**: The expression evaluated to a falsy value:

  assert.ok(!inbox.data.notifications.some((item) => item.referenceId === viewed._id))

- FR-NOT-04 **FAIL**: Expected values to be strictly equal:

1 !== 2

- FR-PUSH-03 **NEEDS_DECISION**: Q9: client/device timezone policy for quiet hours needs product decision
- FR-RT-03 **NEEDS_DECISION**: Q8: intended socket availability note/until convergence needs product decision
- FR-RT-07 **FAIL**: Recovered socket must keep typing, room sync, availability handlers and persisted state
+ actual - expected

  {
+   availabilityOk: false,
+   persistedStatus: 'available',
+   syncOk: false,
+   typingOk: false
-   availabilityOk: true,
-   persistedStatus: 'on_call',
-   syncOk: true,
-   typingOk: true
  }

- FR-SUP-03 **FAIL**: Dev notification seeding must create three valid inbox records

400 !== 200

- FR-RUN-02 **FAIL**: Post-restart independent Mongo read
+ actual - expected

+ ''
- 'Synthetic outage recovery profile'

- FR-JRN-02 **FAIL**: POST /api/message-requests/6ac9418bcf8700ea92e306f4/accept expected 200, got 500
- FR-JRN-04 **FAIL**: Socket event sync_space_rooms timed out
