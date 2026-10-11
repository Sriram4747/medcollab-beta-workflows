# Vocle functional regression

- Scope: backend-p0; source: fork-change `f5bcc29244d624b2445fbdf7d78b038b1806c966`
- Result: **FAIL**; backend-all success: **false**
- PASS 118; FAIL 13; ERROR 0; BLOCKED 0; NEEDS_DECISION 16; SKIP 0
- Selected 147; executed 147; planned catalog 187 (B/F/D 147/32/8)
- Provenance PASS; cleanup PASS

- FR-SPC-03 **NEEDS_DECISION**: Q14: pending-join client state and approval completion need product decision
- FR-SPC-06 **FAIL**: Explicit room sync left revoked users subscribed to a space room
+ actual - expected

  [
+   true,
+   true
-   false,
-   false
  ]

- FR-CH-02 **FAIL**: GET /api/channels/6acb233dca522472806f9740 expected 403, got 200
- FR-REQ-05 **NEEDS_DECISION**: Q7: recovery or atomic rollback contract for accepted-without-DM state requires product decision
- FR-DM-05 **NEEDS_DECISION**: Q2: intended client timezone for today expansion needs product decision
- FR-DM-06 **NEEDS_DECISION**: Q2: 500-item oldest-first cap and source-ID destination preview require product decision
- FR-DM-07 **NEEDS_DECISION**: Q2: copied thread and quote graph remapping requires product decision
- FR-DM-09 **NEEDS_DECISION**: Q7: concurrent group exact-membership guarantee unresolved; observed 1 matching group record(s)
- FR-MSG-01 **FAIL**: POST /api/channels/6acb2368495a9badc433bda2/messages expected 201, got 400
- FR-MSG-05 **NEEDS_DECISION**: Q1: derived quote snapshot and channel preview propagation after edit/delete needs product decision
- FR-MSG-08 **NEEDS_DECISION**: Q7: automatic duplicate prevention after a lost successful response needs product decision
- FR-THR-04 **NEEDS_DECISION**: Q1: expected thread aggregate correction after editing/deleting the latest reply needs product decision
- FR-HOF-05 **FAIL**: GET /api/handoffs/6acb23c6b97004ac388839d5 expected 403, got 200
- FR-HOF-07 **NEEDS_DECISION**: Q4: shiftDate sort with ID cursor; expected ["6acb23c6b97004ac388839f8","6acb23c6b97004ac38883a02","6acb23c6b97004ac38883a07","6acb23c6b97004ac388839fd"], observed ["6acb23c6b97004ac388839f8","6acb23c6b97004ac38883a02","6acb23c6b97004ac388839f8","6acb23c6b97004ac388839fd"]
- FR-MED-01 **FAIL**: Unsupported files must be client errors, not HTTP 500
+ actual - expected

  [
+   500,
+   500
-   400,
-   400
  ]

- FR-MED-02 **FAIL**: Expected values to be strictly equal:

null !== 'pdf'

- FR-MED-03 **NEEDS_DECISION**: Q5: local upload URL is rejected by image-message policy; full upload→message pipeline has no successful local path
- FR-MED-04 **NEEDS_DECISION**: Q5: video upload succeeds, but video message type is rejected by the pinned source
- FR-MED-05 **FAIL**: Expected values to be strictly equal:

false !== true

- FR-MED-06 **NEEDS_DECISION**: Q6: profile points to replacement avatar; old file was deleted explicitly, automatic old-file lifecycle remains undecided
- FR-MED-07 **NEEDS_DECISION**: Q6: referenced local image/video bytes delete, handoff-context deletion is unsupported, and handoff attachment references remain
- FR-NOT-01 **FAIL**: Expected values to be strictly deep-equal:
+ actual - expected

+ Set(3) {
+   '6acb2393c31dc230c49a6654',
- Set(2) {
    '6acb2393c31dc230c49a6656',
    '6acb2393c31dc230c49a6658'
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

- FR-JRN-04 **FAIL**: Socket event sync_space_rooms timed out
