# Batch 4 partial checkpoint

Pinned upstream: `da2baff621fe03b21e614965bdb77510f32a62b9`. 22 new Batch 4 backend cases executed. **Backend-all success is false**.

- PASS 13; FAIL 2; ERROR 0; BLOCKED 0; NEEDS_DECISION 7; SKIP 0
- Implemented catalog cases so far: 143 of 187.

- **FR-HOF-05 NEEDS_DECISION:** Q3: draft audience policy pending; receiver search includes current draft false
- **FR-HOF-07 NEEDS_DECISION:** Q4: shiftDate sort with ID cursor; expected ["6ac93ac6e457ffa41cf8f50a","6ac93ac6e457ffa41cf8f514","6ac93ac6e457ffa41cf8f519","6ac93ac6e457ffa41cf8f50f"], observed ["6ac93ac6e457ffa41cf8f50a","6ac93ac6e457ffa41cf8f514","6ac93ac6e457ffa41cf8f50a","6ac93ac6e457ffa41cf8f50f"]
- **FR-MED-01 FAIL:** Unsupported files must be client errors, not HTTP 500
+ actual - expected

  [
+   500,
+   500
-   400,
-   400
  ]

- **FR-MED-02 NEEDS_DECISION:** Q5: octet-stream upload format/MIME contract pending; synthetic-octet.pdf:pdf/application/octet-stream, synthetic-octet.mp4:video/application/octet-stream
- **FR-MED-03 NEEDS_DECISION:** Q5: local upload URL is rejected by image-message policy; full upload→message pipeline has no successful local path
- **FR-MED-04 NEEDS_DECISION:** Q5: video upload succeeds, but video message type is rejected by the pinned source
- **FR-MED-06 NEEDS_DECISION:** Q6: profile points to replacement avatar; old file was deleted explicitly, automatic old-file lifecycle remains undecided
- **FR-MED-07 NEEDS_DECISION:** Q6: referenced local image/video bytes delete, handoff-context deletion is unsupported, and handoff attachment references remain
- **FR-SUP-03 FAIL:** Dev notification seeding must create three valid inbox records

400 !== 200
