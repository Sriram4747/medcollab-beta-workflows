# Batch 3 implementation checkpoint

Pinned upstream: `da2baff621fe03b21e614965bdb77510f32a62b9`. 33 new Batch 3 cases executed. All planned Batch 3 cases are implemented and executed. **Backend-all success is false**.

- PASS 22; FAIL 6; ERROR 0; BLOCKED 0; NEEDS_DECISION 5; SKIP 0
- Implemented catalog cases so far: 121 of 187 (48 retained sanity, 40 Batch 2, 33 Batch 3).

- **FR-MSG-01 FAIL:** POST /api/channels/6ac8f2854d47d9bea0ad61c4/messages expected 201, got 400
- **FR-MSG-05 NEEDS_DECISION:** Q1: derived quote snapshot and channel preview propagation after edit/delete needs product decision
- **FR-MSG-08 NEEDS_DECISION:** Q7: automatic duplicate prevention after a lost successful response needs product decision
- **FR-THR-04 NEEDS_DECISION:** Q1: expected thread aggregate correction after editing/deleting the latest reply needs product decision
- **FR-SOC-01 FAIL:** Switching emoji must replace B prior reaction
+ actual - expected

  [
+   '👍',
    '❤️'
  ]

- **FR-NOT-01 FAIL:** Expected values to be strictly deep-equal:
+ actual - expected

+ Set(3) {
+   '6ac8f5addbbefeffe3fce1c6',
- Set(2) {
    '6ac8f5addbbefeffe3fce1c8',
    '6ac8f5addbbefeffe3fce1ca'
  }

- **FR-NOT-02 FAIL:** The expression evaluated to a falsy value:

  assert.ok(!inbox.data.notifications.some((item) => item.referenceId === viewed._id))

- **FR-NOT-04 FAIL:** Expected values to be strictly equal:

1 !== 2

- **FR-PUSH-03 NEEDS_DECISION:** Q9: client/device timezone policy for quiet hours needs product decision
- **FR-RT-03 NEEDS_DECISION:** Q8: intended socket availability note/until convergence needs product decision
- **FR-RT-07 FAIL:** Recovered socket must keep typing, room sync, availability handlers and persisted state
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
