# Batch 3 partial checkpoint

Pinned upstream: `da2baff621fe03b21e614965bdb77510f32a62b9`. Eight root messaging and four thread/Needl cases executed. This is a partial Batch 3 run; **backend-all success is false**.

- PASS 8; FAIL 1; ERROR 0; BLOCKED 0; NEEDS_DECISION 3; SKIP 0
- Implemented catalog cases so far: 100 of 187 (48 retained sanity, 40 Batch 2, 12 Batch 3).

- **FR-MSG-01 FAIL:** POST /api/channels/6ac8f2854d47d9bea0ad61c4/messages expected 201, got 400
- **FR-MSG-05 NEEDS_DECISION:** Q1: derived quote snapshot and channel preview propagation after edit/delete needs product decision
- **FR-MSG-08 NEEDS_DECISION:** Q7: automatic duplicate prevention after a lost successful response needs product decision
- **FR-THR-04 NEEDS_DECISION:** Q1: expected thread aggregate correction after editing/deleting the latest reply needs product decision
