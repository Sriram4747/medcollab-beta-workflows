# QA findings

Source: f5bcc29244d624b2445fbdf7d78b038b1806c966; harness: f5bcc29244d624b2445fbdf7d78b038b1806c966.
No issues, assignments or notifications are created.

## QA-36ff1883b8a1

Feature: SPC; cases: FR-SPC-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: One pending request, no membership; UI must not assume channels/join success; approval completion unsupported.
Actual: [{"status":"NEEDS_DECISION","error":"Q14: pending-join client state and approval completion need product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d5e105b05a17

Feature: SPC; cases: FR-SPC-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Lists no longer include S; room membership after sync reflects current DB; immediate eviction guarantee needs decision.
Actual: [{"status":"FAIL","error":"Explicit room sync left revoked users subscribed to a space room\n+ actual - expected\n\n  [\n+   true,\n+   true\n-   false,\n-   false\n  ]\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d8455ab9f297

Feature: CH; cases: FR-CH-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Public X in both; private Y in creator lists only; compare IDs across three list surfaces.
Actual: [{"status":"FAIL","error":"GET /api/channels/6acb233dca522472806f9740 expected 403, got 200"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6ce6bb05b9c6

Feature: REQ; cases: FR-REQ-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Record partial accepted-without-DM possibility; desired recovery/atomicity must be agreed, never count initial 2xx alone.
Actual: [{"status":"NEEDS_DECISION","error":"Q7: recovery or atomic rollback contract for accepted-without-DM state requires product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d2f7ff37366c

Feature: DM; cases: FR-DM-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Current code selects >= server midnight; agree intended timezone before gate; source untouched.
Actual: [{"status":"NEEDS_DECISION","error":"Q2: intended client timezone for today expansion needs product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0d25ea1e5ef2

Feature: DM; cases: FR-DM-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Characterize oldest-500 cap and excluded deleted records; require decision on cap and source-ID preview mismatch.
Actual: [{"status":"NEEDS_DECISION","error":"Q2: 500-item oldest-first cap and source-ID destination preview require product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0fd0cad7dcd4

Feature: DM; cases: FR-DM-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Source graph unchanged; destination graph behavior needs decision because threadId not copied and quote IDs reference source.
Actual: [{"status":"NEEDS_DECISION","error":"Q2: copied thread and quote graph remapping requires product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-8994a9c818bb

Feature: DM; cases: FR-DM-09.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Pair intent one conversation; group concurrency guarantee unresolved; classify target-specific failure without copying fork fix.
Actual: [{"status":"NEEDS_DECISION","error":"Q7: concurrent group exact-membership guarantee unresolved; observed 1 matching group record(s)"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-02fd224000de

Feature: MSG; cases: FR-MSG-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Invalid 400 no message; supported text persists without unexpected content loss.
Actual: [{"status":"FAIL","error":"POST /api/channels/6acb2368495a9badc433bda2/messages expected 201, got 400"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ddfea22a7a92

Feature: MSG; cases: FR-MSG-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Message state verified; preview/snapshot propagation policy unresolved; capture mismatches.
Actual: [{"status":"NEEDS_DECISION","error":"Q1: derived quote snapshot and channel preview propagation after edit/delete needs product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e15043bc870b

Feature: MSG; cases: FR-MSG-08.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Fetch reveals committed record; automatic exactly-once resend not assumed; product decision on duplicate prevention.
Actual: [{"status":"NEEDS_DECISION","error":"Q7: automatic duplicate prevention after a lost successful response needs product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-237428b00aef

Feature: THR; cases: FR-THR-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Thread content reflects action; aggregate correction policy Q1 required.
Actual: [{"status":"NEEDS_DECISION","error":"Q1: expected thread aggregate correction after editing/deleting the latest reply needs product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-df20f51ba577

Feature: HOF; cases: FR-HOF-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Record cross-view difference; Q3 decides accepted audience before gate.
Actual: [{"status":"FAIL","error":"GET /api/handoffs/6acb23c6b97004ac388839d5 expected 403, got 200"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e12c4d3f15ee

Feature: HOF; cases: FR-HOF-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Intended no missing/repeated items needs cursor/sort decision; save ordered IDs to demonstrate gap.
Actual: [{"status":"NEEDS_DECISION","error":"Q4: shiftDate sort with ID cursor; expected [\"6acb23c6b97004ac388839f8\",\"6acb23c6b97004ac38883a02\",\"6acb23c6b97004ac38883a07\",\"6acb23c6b97004ac388839fd\"], observed [\"6acb23c6b97004ac388839f8\",\"6acb23c6b97004ac38883a02\",\"6acb23c6b97004ac388839f8\",\"6acb23c6b97004ac388839fd\"]"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-637ae12aba82

Feature: MED; cases: FR-MED-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Missing/unsupported/oversize reject; supported bytes/metadata retained; exact limit from MEDIA.MAX_FILE_SIZE_BYTES.
Actual: [{"status":"FAIL","error":"Unsupported files must be client errors, not HTTP 500\n+ actual - expected\n\n  [\n+   500,\n+   500\n-   400,\n-   400\n  ]\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-2ceedccc3565

Feature: MED; cases: FR-MED-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Extension fallback accepted by filter; MIME-derived format mismatch characterized; Q5 decides normalized type contract.
Actual: [{"status":"FAIL","error":"Expected values to be strictly equal:\n\nnull !== 'pdf'\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-f3348af5340e

Feature: MED; cases: FR-MED-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Current local URL rejected by send policy; Q5 must resolve full pipeline, never substitute inert URL and call E2E passed.
Actual: [{"status":"NEEDS_DECISION","error":"Q5: local upload URL is rejected by image-message policy; full upload→message pipeline has no successful local path"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9994b129c0eb

Feature: MED; cases: FR-MED-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Upload supported but validator rejects; Q5 required to enable successful send expectation.
Actual: [{"status":"NEEDS_DECISION","error":"Q5: video upload succeeds, but video message type is rejected by the pinned source"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6a14b59e0fe7

Feature: MED; cases: FR-MED-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: image/raw/video resource type, folders, filename/size, thumbnail/delivery mapping; provider error returns upload failure, no message created.
Actual: [{"status":"FAIL","error":"Expected values to be strictly equal:\n\nfalse !== true\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9cd9e3b147b4

Feature: MED; cases: FR-MED-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Profile points to B; old-file lifecycle and dangling references Q6; no invented automatic deletion.
Actual: [{"status":"NEEDS_DECISION","error":"Q6: profile points to replacement avatar; old file was deleted explicitly, automatic old-file lifecycle remains undecided"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-fdbe3ae134f2

Feature: MED; cases: FR-MED-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Local bytes removed when supported; references not auto-cleared; Q6 defines retention/error UX and missing video destroy support.
Actual: [{"status":"NEEDS_DECISION","error":"Q6: referenced local image/video bytes delete, handoff-context deletion is unsupported, and handoff attachment references remain"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-8b139327dea5

Feature: NOT; cases: FR-NOT-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Ordinary suppressed while viewing; emergency still stored; later ordinary stored; sender excluded.
Actual: [{"status":"FAIL","error":"Expected values to be strictly deep-equal:\n+ actual - expected\n\n+ Set(3) {\n+   '6acb2393c31dc230c49a6654',\n- Set(2) {\n    '6acb2393c31dc230c49a6656',\n    '6acb2393c31dc230c49a6658'\n  }\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-05b284243a45

Feature: NOT; cases: FR-NOT-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Self mention excluded; viewed B mention suppressed; non-viewed B gets mention; ordinary and mention may both exist by type.
Actual: [{"status":"FAIL","error":"The expression evaluated to a falsy value:\n\n  assert.ok(!inbox.data.notifications.some((item) => item.referenceId === viewed._id))\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0756e2a1b8e4

Feature: NOT; cases: FR-NOT-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Both representations read, unrelated unchanged, repeat modifiedCount=0; count reconciles.
Actual: [{"status":"FAIL","error":"Expected values to be strictly equal:\n\n1 !== 2\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ebf63b42780c

Feature: PUSH; cases: FR-PUSH-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: start inclusive/end exclusive, equal disabled; current emergency bypass only after preference check; timezone Q9.
Actual: [{"status":"NEEDS_DECISION","error":"Q9: client/device timezone policy for quiet hours needs product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-1c6c11540bac

Feature: RT; cases: FR-RT-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Persistence matches; socket note/until broadcast discrepancy Q8 must resolve.
Actual: [{"status":"NEEDS_DECISION","error":"Q8: intended socket availability note/until convergence needs product decision"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-3e26b34d31d8

Feature: RT; cases: FR-RT-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Configured recovery restores missed events/rooms; recovered connection must still have functional handlers and presence; compare fresh reconnect control. Source skips handler registration when recovered, so flag any runtime failure rather than assuming listeners survive.
Actual: [{"status":"FAIL","error":"Recovered socket must keep typing, room sync, availability handlers and persisted state\n+ actual - expected\n\n  {\n+   availabilityOk: false,\n+   persistedStatus: 'available',\n+   syncOk: false,\n+   typingOk: false\n-   availabilityOk: true,\n-   persistedStatus: 'on_call',\n-   syncOk: true,\n-   typingOk: true\n  }\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0c3e1844b557

Feature: SUP; cases: FR-SUP-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: No-space gives actionable error; joined fixtures created with correct IDs/content; disabled mode rejects seed.
Actual: [{"status":"FAIL","error":"Dev notification seeding must create three valid inbox records\n\n400 !== 200\n"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-b72a7a27e9cb

Feature: JRN; cases: FR-JRN-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Supported lists recover membership; no stale active rooms after sync; immediate transition semantics Q10.
Actual: [{"status":"FAIL","error":"Socket event sync_space_rooms timed out"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.
