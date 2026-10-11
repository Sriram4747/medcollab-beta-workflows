# QA findings

Source: f5bcc29244d624b2445fbdf7d78b038b1806c966; harness: f5bcc29244d624b2445fbdf7d78b038b1806c966.
No issues, assignments or notifications are created.

## QA-1ed2d3c6b615

Feature: HOF; cases: FR-HOF-12.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Client lifecycle label changes per model, backend status unchanged; timezone/wording Q12.
Actual: [{"status":"NEEDS_DECISION"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d5175244954f

Feature: HOF; cases: FR-HOF-13.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Cancel leaves form unchanged; save updates selected patient only; validation shown before submit.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-8da9f78a08f2

Feature: HOME; cases: FR-HOME-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Assigned/shift/task cards reflect current assignee/status; no separate roster state fabricated.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-5956187329ea

Feature: LINK; cases: FR-LINK-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Copied vocle://c/<id>/m/<id> string exact; opening target currently incomplete, Q13 required.
Actual: [{"status":"NEEDS_DECISION"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-fce633d44e53

Feature: LINK; cases: FR-LINK-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Latest debounced route wins; auth queues intended destination; missing target falls back to notification/handoff list.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-68ba597c572d

Feature: NAV; cases: FR-NAV-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Login/profile setup/home respectively, no transient wrong destination; stored identity loaded.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-946e233ea9c4

Feature: NAV; cases: FR-NAV-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Success retries request with new token; failure clears session; bounded retry desired, recursion/concurrency behavior recorded for clarification.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-bf35f0c1962a

Feature: NAV; cases: FR-NAV-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Detail then documented tab history restored; no duplicate route stack or lost selected tab.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7821bb2d9619

Feature: OFF; cases: FR-OFF-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Decide retained/account-scoped data Q11; capture leak/stale UX without presuming implemented cleanup.
Actual: [{"status":"NEEDS_DECISION"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e751d0efc598

Feature: REQ; cases: FR-REQ-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Correct send/wait/accept/open state; errors preserve retry UI; acceptance navigates returned channel.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-505217da6143

Feature: RT; cases: FR-RT-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Correct peer/channel typing state; no self indicator; timeout clears stale typing; disposed listeners do not update closed state.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0fd5a1cf0da2

Feature: RT; cases: FR-RT-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Valid refresh reconnects with new token; failure yields session recovery UI without endless connection loop.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-23dca0d75e6c

Feature: RUN; cases: FR-RUN-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Error state distinct from empty result; loading terminates; retry restores correct data.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9863f669c923

Feature: SAVE; cases: FR-SAVE-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Corrupt data returns empty safely; unavailable target shows recoverable error, not crash.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-f8e4a533ae7a

Feature: SOC; cases: FR-SOC-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: UI labels reflect model; no claim sent=delivered; opt-out hides receipt UI.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-74aa410f11ea

Feature: SRCH; cases: FR-SRCH-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Latest visible query owns results, no stale overwrite; error state recoverable; correct result route selected.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7e4fad24dd94

Feature: SUP; cases: FR-SUP-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Input retained on error, success acknowledgement matches ticket; routes and bundled content render; external contact intent captured only.
Actual: [{"status":"FAIL"}].
Reproduce: Use original run command and exact source/harness revisions recorded in provenance.
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.
