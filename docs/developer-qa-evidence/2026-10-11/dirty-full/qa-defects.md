# QA findings

Source: efe43c88a5bf85df2630d3dc47d6e09e10fe30cb; harness: efe43c88a5bf85df2630d3dc47d6e09e10fe30cb.
No issues, assignments or notifications are created.

## QA-ae55c8dc1e6f

Feature: AUTH; cases: authentication-and-profiles-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Request OTP; inspect hashed record; verify captured code; assert new verified user, access/refresh tokens and persisted identity..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6067a87ed3b9

Feature: AUTH; cases: authentication-and-profiles-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Request/verify again for same phone; assert same user ID and isNewUser=false..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e2d3aa4fdc51

Feature: AUTH; cases: authentication-and-profiles-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Submit wrong code then correct captured code; first rejects, second yields token..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-f0f19a002250

Feature: AUTH; cases: authentication-and-profiles-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Reuse consumed code; reject and do not create another user..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-26063c5c03c6

Feature: PRO; cases: authentication-and-profiles-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Update onboarding name/institution; GET me; assert onboarded and exact profile values..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6e04860f9620

Feature: AUTH; cases: authentication-and-profiles-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Refresh with missing token then valid token; missing gives 401; use returned access token on me..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-12838fec4d12

Feature: AUTH; cases: authentication-and-profiles-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Register device twice; DB has one token; logout removes it; fake widget-token exchange returns access token..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-746fc173ee03

Feature: SPC; cases: spaces-and-invitations-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Create department space; assert owner membership and general/emergency/academics defaults..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ba705f0ca049

Feature: SPC; cases: spaces-and-invitations-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Preview invite as B; join; GET spaces/detail/members; assert B membership and returned channels..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-49206840bdec

Feature: SPC; cases: spaces-and-invitations-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Repeat B join; expect 409 without duplicate membership..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e2784248efa5

Feature: SPC; cases: spaces-and-invitations-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Rename S2 and rotate invite; reread name/new code; old invite preview gives 404..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e5ba14057ced

Feature: SPC; cases: spaces-and-invitations-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: B leaves, owner removes C, owner tries leaving; final list only A, owner leave gives 400..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d1c72c775813

Feature: CH; cases: channels-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Create public channel, duplicate create gives 409, rename; mutation response contains new name..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6f867f6d274d

Feature: CH; cases: channels-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Create private channel as A; GET creator detail returns same ID..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-1f6fb0eb682b

Feature: CH; cases: channels-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Send in custom channel, archive; messages retained in DB, message GET gives 403, active list excludes channel; default archive gives 400..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-f7a946bbb3a9

Feature: MSG; cases: messaging-and-needl-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Send text A→general; B reads text/sender; detail contains matching lastMessage preview..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-a0bd4830612b

Feature: MSG; cases: messaging-and-needl-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Send three roots; page limit=2 then before cursor; ordered roots have no overlap..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7974d49b99ef

Feature: MSG; cases: messaging-and-needl-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Quote prior message via replyToId; assert mutation response replyTo ID/text; independent persistence is added in FR-MSG-03..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-63c45b93bd93

Feature: THR; cases: messaging-and-needl-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Reply to root; immediately read root count/lastReply, thread and Needl; assert root/reply. This immediate read can race asynchronous updates..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-5c69cc6d552d

Feature: MSG; cases: messaging-and-needl-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Subscribe, edit text, delete it; assert update/delete events and soft-deleted DB state..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-1cd372fba143

Feature: SOC; cases: messaging-and-needl-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Toggle reaction on/off; pin/unpin; assert response reaction and pin arrays; independent persistence added under FR-SOC..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-393da0431afb

Feature: MSG; cases: messaging-and-needl-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Empty text fails; send normal-priority text in emergency channel; stored priority is emergency..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-b3514f73cabb

Feature: REQ; cases: message-requests-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Enable D requests; lookup, create/repeat A→D, read both directions/count; same request ID and recipient notification. Historical FAIL..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9416c5fd4e64

Feature: REQ; cases: message-requests-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: D accepts preceding request; assert accepted, DM listed for both, peer=A, sender acceptance notification names channel. Historical FAIL..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-bc7457488f66

Feature: REQ; cases: message-requests-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Create separate A→E eligible request; E declines; count decreases and repeated terminal action rejects..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ac86024da60a

Feature: DM; cases: direct-and-group-conversations-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Reopen accepted A/D DM from both sides; IDs identical. Historical BLOCKED by accept..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-20353bccf2f1

Feature: DM; cases: direct-and-group-conversations-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Send in accepted DM; recipient reads sender and lists peer/lastMessage. Historical BLOCKED..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-173d37d2b49e

Feature: DM; cases: direct-and-group-conversations-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Mark peer message read twice; one readBy; disable receipts and mark another; no new receipt. Historical BLOCKED..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-1970e9009c9f

Feature: DM; cases: direct-and-group-conversations-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Open self notes and send; create/reopen group with exact members; rename and assert membership/name..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-17ed43b52ec3

Feature: DM; cases: direct-and-group-conversations-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Expand independent source DMs with none/all; verify new membership, zero/copied history and unchanged sources. Historical BLOCKED..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-2c85cf9aa96f

Feature: HOF; cases: handoffs-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Create draft patient+attachment, edit summary, read; draft and attachment filename survive..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-3068e1715d95

Feature: HOF; cases: handoffs-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Empty draft submit gives 400; delete disposable draft; subsequent detail gives 404..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-b7c0041f423d

Feature: HOF; cases: handoffs-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Submit populated draft; verify received list/space history, notification and submitted event; update/delete give 400..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-139219d45f73

Feature: HOF; cases: handoffs-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: B acknowledges with note; verify status/time/note, sender notification and event; duplicate acknowledgement rejects..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-a3df81656602

Feature: HOF; cases: handoffs-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: B adds note then reassigns to C; DB history has one entry and resets acknowledgement; C can acknowledge..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-b5f7caf51f75

Feature: MED; cases: media-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Upload PNG, download exact bytes, delete, subsequent retrieval 404..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-03134e0e4ee5

Feature: MED; cases: media-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Upload PDF, compare downloaded bytes; create handoff attachment and reread filename/MIME..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e829eee0e758

Feature: MED; cases: media-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Send inert image/ECG/document URL metadata; GET same URL/filename; final document sidebar label matches. No provider retrieval proof..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-97a640deb556

Feature: NOT; cases: notifications-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Send ordinary message to non-viewing B; poll inbox/count, reference metadata and personal socket event..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-014194435ebd

Feature: NOT; cases: notifications-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Mention B then emergency message; persisted type/priority match mention/emergency..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d4c184234226

Feature: NOT; cases: notifications-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Mark one read/unread, channel read, all read, delete; lists/counts match changes..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-cb9763f55bd6

Feature: RT; cases: realtime-and-availability-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Authenticate two sockets, join, REST send, receive; disconnect/reconnect/rejoin. No second-message assertion exists in this retained case..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9770a71d2e52

Feature: RT; cases: realtime-and-availability-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Start/stop typing; peer receives channel/user IDs..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-54b1ed1ea4fa

Feature: RT; cases: realtime-and-availability-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: REST/socket availability, room sync, final disconnect; assert stored state, broadcasts and offline presence..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-46c3688fec17

Feature: SRCH; cases: search-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Known-user name query and phone lookup return intended colleague..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-bdd7dd47c42e

Feature: SRCH; cases: search-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Global marker search finds message/doctor/channel/attachment/handoff; nonmatching marker returns empty arrays..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-1f9878404fb2

Feature: SUP; cases: support-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Submit bug, inspect ticket ID/author/type/title/description; missing title fails..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6fa2ec11a5fb

Feature: RUN; cases: startup-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: GET health; connected test DB and disabled Firebase/Cloudinary reported..
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-acc3a4565fa2

Feature: AUTH; cases: FR-AUTH-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Validator accepts supported E164/6-digit shapes; invalid requests 400 and no user/session.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-39b8dd5fb647

Feature: AUTH; cases: FR-AUTH-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Old invalidated; latest usable; one identity.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6b2c17d1205c

Feature: AUTH; cases: FR-AUTH-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Expired rejected independently of TTL deletion; fresh code works.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-09e3f5318d4f

Feature: AUTH; cases: FR-AUTH-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Third valid attempt succeeds; exhausted OTP fails; resend resets usable attempts.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-a366b35bb29e

Feature: AUTH; cases: FR-AUTH-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: 503 for transport failure; no authenticated user from failed send; subsequent request usable; record superseded OTP state.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9228ccc27df5

Feature: AUTH; cases: FR-AUTH-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Valid identity/tokens only for verified matching phone; failure returns error without creating wrong user.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-5f9327c16e7f

Feature: AUTH; cases: FR-AUTH-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Expired refresh rejects; new login restores functional session.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-53b312161169

Feature: PRO; cases: FR-PRO-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Onboarding persists and protected app routes become available; same ID.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7b24690d0023

Feature: PRO; cases: FR-PRO-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Supported endpoints accept exact limits, reject out-of-range with unchanged profile.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6cca2976496d

Feature: PRO; cases: FR-PRO-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Partial preference updates retain both values and other defaults.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-5962d0df7135

Feature: PRO; cases: FR-PRO-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Fresh populated views use updated fields; no assumption stored historical sender snapshots update.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-937a5c2ff48d

Feature: DISC; cases: FR-DISC-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Self canMessage/no request; shared space enables request rather than new DM; accepted peer opens DM; opt-in affects request eligibility.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-2903270c32ae

Feature: DISC; cases: FR-DISC-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Absent 404, malformed 400, equivalent supported formats resolve same ID.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-86b04e0a3031

Feature: DISC; cases: FR-DISC-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Short q rejected; trimmed literal case-insensitive matches; S2 filter intersects known users.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-21ed7148f269

Feature: DISC; cases: FR-DISC-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: At most 20 eligible results, no duplicates; inactive/incomplete omitted; do not assume unspecified order.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-586a9b827c30

Feature: SPC; cases: FR-SPC-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Valid values/defaults persisted; invalid creates leave no partial space/channels.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-78ba72009273

Feature: SPC; cases: FR-SPC-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Case normalization works; alreadyMember true after join; new code usable.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-36ff1883b8a1

Feature: SPC; cases: FR-SPC-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: One pending request, no membership; UI must not assume channels/join success; approval completion unsupported.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ad9a64002374

Feature: SPC; cases: FR-SPC-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Supported admin actions persist; ordinary member rejected; owner remains.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-c54b32da5878

Feature: SPC; cases: FR-SPC-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: on_call before in_ot/on_rounds/in_icu before available before DND before off_duty; ties not specified.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d5e105b05a17

Feature: SPC; cases: FR-SPC-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Lists no longer include S; room membership after sync reflects current DB; immediate eviction guarantee needs decision.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-2c1c2af5e7f6

Feature: CH; cases: FR-CH-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Limits/format enforced; accepted entry appears once and exact fields persist.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d8455ab9f297

Feature: CH; cases: FR-CH-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Public X in both; private Y in creator lists only; compare IDs across three list surfaces.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e34d69f911ef

Feature: CH; cases: FR-CH-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: B rejected while enabled, A stored; B succeeds after reset; no rejected message/preview mutation.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-58772a7b9471

Feature: CH; cases: FR-CH-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Custom persisted; general/emergency/academics keep names and cannot archive.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-25c3ae2806c8

Feature: CH; cases: FR-CH-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Active surfaces omit X, send rejected, DB messages retained; pin data not silently destroyed.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-05152684326d

Feature: REQ; cases: FR-REQ-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Same pending ID, incoming action accept_incoming; one record/count; peer and direction correct.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-1c50ab5b9a96

Feature: REQ; cases: FR-REQ-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Specific ordinary business rejection; no pending request/count/notification increase.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-725fbd949d07

Feature: REQ; cases: FR-REQ-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Route validation limit enforced; exact intro and peer serialization; filter results/count independent of outgoing.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-72d46a18ada6

Feature: REQ; cases: FR-REQ-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Only first valid transition; persisted terminal state and count remain stable.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6ce6bb05b9c6

Feature: REQ; cases: FR-REQ-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Record partial accepted-without-DM possibility; desired recovery/atomicity must be agreed, never count initial 2xx alone.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6289b166371e

Feature: DM; cases: FR-DM-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Exact deduplicated membership reuses group ID; one other delegates pair rules; self-only rejected.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-27146db3f3ba

Feature: DM; cases: FR-DM-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: 9 total accepted, 10 total rejected with no partial group.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-28fc0b63f38a

Feature: DM; cases: FR-DM-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Empty returns fallback display name, stored custom name trimmed/truncated to 80; members unchanged.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e099791a168f

Feature: DM; cases: FR-DM-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Most recent lastMessage first; peer is opposite user; self notes isSelfNotes=true and group isNeedl=true.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d2f7ff37366c

Feature: DM; cases: FR-DM-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Current code selects >= server midnight; agree intended timezone before gate; source untouched.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0d25ea1e5ef2

Feature: DM; cases: FR-DM-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Characterize oldest-500 cap and excluded deleted records; require decision on cap and source-ID preview mismatch.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0fd0cad7dcd4

Feature: DM; cases: FR-DM-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Source graph unchanged; destination graph behavior needs decision because threadId not copied and quote IDs reference source.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-67009b5a7400

Feature: DM; cases: FR-DM-08.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Existing destination reused, no second history import; all source records retained.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-8994a9c818bb

Feature: DM; cases: FR-DM-09.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Pair intent one conversation; group concurrency guarantee unresolved; classify target-specific failure without copying fork fix.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-02fd224000de

Feature: MSG; cases: FR-MSG-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Invalid 400 no message; supported text persists without unexpected content loss.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-a0ad5428c737

Feature: MSG; cases: FR-MSG-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Invalid bounds rejected; hasMore uses extra row; no duplicate roots or thread leakage.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7b0b24d4ef79

Feature: MSG; cases: FR-MSG-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Correct source ID/sender/type and 120-char text or Photo/filename fallback.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-b1fc94c7c0bd

Feature: MSG; cases: FR-MSG-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Text isEdited/editedAt/content persisted; nontext edit 400; event identifies changed message.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ddfea22a7a92

Feature: MSG; cases: FR-MSG-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Message state verified; preview/snapshot propagation policy unresolved; capture mismatches.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-2af7ef8b1ac2

Feature: MSG; cases: FR-MSG-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Soft deletion, deletion placeholder text, cleared media/reactions and deleted event; unrelated messages intact.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ed67d0d339ad

Feature: MSG; cases: FR-MSG-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: General preserves urgent; emergency overrides to emergency; notification priority follows.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e15043bc870b

Feature: MSG; cases: FR-MSG-08.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Fetch reveals committed record; automatic exactly-once resend not assumed; product decision on duplicate prevention.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-a4e0255a9a1d

Feature: THR; cases: FR-THR-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Count equals replies, lastReply correct sender/100-char preview, reply IDs not main roots.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-bb483fcbf6c4

Feature: THR; cases: FR-THR-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Ascending presentation within page; no overlap, correct hasMore; deleted omitted.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ee6d117638cd

Feature: THR; cases: FR-THR-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: At most 40 newest qualifying roots; metadata channel/root IDs correct; archived excluded.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-237428b00aef

Feature: THR; cases: FR-THR-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Thread content reflects action; aggregate correction policy Q1 required.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ae51fbe97c72

Feature: SOC; cases: FR-SOC-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: One emoji per user; switching replaces B's prior emoji; removal leaves other users intact; event matches stored set.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d4a2fcf10c48

Feature: SOC; cases: FR-SOC-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Reject supported invalid forms and deleted reaction; old reactions unchanged.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-4b1c866fe7b7

Feature: SOC; cases: FR-SOC-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: At most five, populated message/sender and pinnedBy/time retained, freed slot reusable.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-694cca48a12f

Feature: SOC; cases: FR-SOC-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Re-pin below cap returns 409; at cap returns 400 (cap checked first); absent unpin succeeds; cardinality unchanged.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-767960c5d4bf

Feature: SOC; cases: FR-SOC-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: One readBy per user/message, timestamps stable on duplicate, C independent; opt-out no added B receipt.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-82448b61be7f

Feature: HOF; cases: FR-HOF-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Remaining patient fields/tasks/flags/attachments exact, draft status and sender preserved.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-df4837e8c490

Feature: HOF; cases: FR-HOF-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Valid schema boundaries save; invalid reject without replacing previous draft.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-b4b2ca02db68

Feature: HOF; cases: FR-HOF-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: One successful transition each, timestamps set once; exactly one transition notification/event by resource after quiescence.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d36f4b0a79af

Feature: HOF; cases: FR-HOF-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Invalid lifecycle operations rejected; no state or patient loss.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-df20f51ba577

Feature: HOF; cases: FR-HOF-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Record cross-view difference; Q3 decides accepted audience before gate.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-647a6bf706fd

Feature: HOF; cases: FR-HOF-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Correct participant/date filters; populated users; draft visibility handled under Q3.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e12c4d3f15ee

Feature: HOF; cases: FR-HOF-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Intended no missing/repeated items needs cursor/sort decision; save ordered IDs to demonstrate gap.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7635c1e0e9b8

Feature: HOF; cases: FR-HOF-08.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Valid trimmed text/author/kind/time append, blank/oversize rejected; handoff patient/status unchanged.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-06c98ca33060

Feature: HOF; cases: FR-HOF-09.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Two ordered history entries, new assignee/submitted, ack reset, patients retained, correct new notification.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e8e4c7b3a4fd

Feature: HOF; cases: FR-HOF-10.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Rejected invalid transition, history/ack unchanged; supported note limit follows route and model.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-637ae12aba82

Feature: MED; cases: FR-MED-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Missing/unsupported/oversize reject; supported bytes/metadata retained; exact limit from MEDIA.MAX_FILE_SIZE_BYTES.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-2ceedccc3565

Feature: MED; cases: FR-MED-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Extension fallback accepted by filter; MIME-derived format mismatch characterized; Q5 decides normalized type contract.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-f3348af5340e

Feature: MED; cases: FR-MED-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Current local URL rejected by send policy; Q5 must resolve full pipeline, never substitute inert URL and call E2E passed.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9994b129c0eb

Feature: MED; cases: FR-MED-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Upload supported but validator rejects; Q5 required to enable successful send expectation.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6a14b59e0fe7

Feature: MED; cases: FR-MED-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: image/raw/video resource type, folders, filename/size, thumbnail/delivery mapping; provider error returns upload failure, no message created.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9cd9e3b147b4

Feature: MED; cases: FR-MED-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Profile points to B; old-file lifecycle and dangling references Q6; no invented automatic deletion.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-fdbe3ae134f2

Feature: MED; cases: FR-MED-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Local bytes removed when supported; references not auto-cleared; Q6 defines retention/error UX and missing video destroy support.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-8b139327dea5

Feature: NOT; cases: FR-NOT-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Ordinary suppressed while viewing; emergency still stored; later ordinary stored; sender excluded.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-05b284243a45

Feature: NOT; cases: FR-NOT-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Self mention excluded; viewed B mention suppressed; non-viewed B gets mention; ordinary and mention may both exist by type.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-dffd08d56c84

Feature: NOT; cases: FR-NOT-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Filtered pages no overlap, correct hasMore; returned unreadCount is total user unread, not filtered page length.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0756e2a1b8e4

Feature: NOT; cases: FR-NOT-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Both representations read, unrelated unchanged, repeat modifiedCount=0; count reconciles.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-17b50be24871

Feature: NOT; cases: FR-NOT-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: First message persists despite side-effect failure; next send notification works; no automatic replay promise.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-78d83d4a88c8

Feature: PUSH; cases: FR-PUSH-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Most recent five unique tokens retained; t3 moved to front then removed; other device tokens stay.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-56b763cb2552

Feature: PUSH; cases: FR-PUSH-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Inbox/socket still persist; disabled type sends no push; enabled control does send.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ebf63b42780c

Feature: PUSH; cases: FR-PUSH-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: start inclusive/end exclusive, equal disabled; current emergency bypass only after preference check; timezone Q9.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-8228e4f83391

Feature: PUSH; cases: FR-PUSH-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: t1 eventually removed; t2/t3 retained; persisted inbox unaffected; string metadata and routing fields correct.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0aaf1dc4e9f2

Feature: RT; cases: FR-RT-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: First disconnect leaves online; last emits offline and lastSeenAt persists.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-ce180debabe9

Feature: RT; cases: FR-RT-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: New space room included, sync acknowledgement count correct; presence snapshot IDs unique.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-1c6c11540bac

Feature: RT; cases: FR-RT-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Persistence matches; socket note/until broadcast discrepancy Q8 must resolve.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-3e26b34d31d8

Feature: RT; cases: FR-RT-07.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Configured recovery restores missed events/rooms; recovered connection must still have functional handlers and presence; compare fresh reconnect control. Source skips handler registration when recovered, so flag any runtime failure rather than assuming listeners survive.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e256160d2751

Feature: SRCH; cases: FR-SRCH-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Correct populated arrays only, query trimmed; q<2 rejected; literal matching.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-3c54b00eb755

Feature: SRCH; cases: FR-SRCH-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Max 50 per category, newest first where sorted; archived results omitted.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-48d8ee75748f

Feature: SRCH; cases: FR-SRCH-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Patient-specific title assembled when matched; otherwise summary; detail navigation visibility Q3 tracked separately.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-2df4426ebff3

Feature: SUP; cases: FR-SUP-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Correct distinct type/author/open status; required blanks rejected.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-aa611f791baa

Feature: SUP; cases: FR-SUP-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Controller trims/truncates to 200/5000/3000; accepted ticket data exact.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0c3e1844b557

Feature: SUP; cases: FR-SUP-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: No-space gives actionable error; joined fixtures created with correct IDs/content; disabled mode rejects seed.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-09a89e96374f

Feature: RUN; cases: FR-RUN-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Same IDs/content/status available; ephemeral presence rebuilt from new sockets.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0ec5e912f648

Feature: RUN; cases: FR-RUN-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Bounded error/no fabricated empty success; recovery permits fresh read; no automatic failed-write replay assumed.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-a384c861526f

Feature: JRN; cases: FR-JRN-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Stable identities/membership/messages/handoff status and notifications across sessions; no invented handoff system message.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-eaebafbb56c3

Feature: JRN; cases: FR-JRN-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Consent changes ability to message, one DM ID, exact messages/receipt and notification route.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-90884502036d

Feature: JRN; cases: FR-JRN-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Responsibility moves without losing patients/tasks; history/notes/ack reset/new ack and alerts consistent.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-b72a7a27e9cb

Feature: JRN; cases: FR-JRN-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Supported lists recover membership; no stale active rooms after sync; immediate transition semantics Q10.
Actual: [{"status":"BLOCKED","error":"Linux Docker engine unavailable; network-none isolation is required"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7a008d521957

Feature: PRO; cases: FR-PRO-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Cancel no request; error retains inputs; successful reload renders saved profile.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e751d0efc598

Feature: REQ; cases: FR-REQ-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Correct send/wait/accept/open state; errors preserve retry UI; acceptance navigates returned channel.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-5ca7965f704e

Feature: THR; cases: FR-THR-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: One rendered reply and one increment; refresh converges to server counts.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-f8e4a533ae7a

Feature: SOC; cases: FR-SOC-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: UI labels reflect model; no claim sent=delivered; opt-out hides receipt UI.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-317f16cb8b26

Feature: HOF; cases: FR-HOF-11.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Existing draft ID reused; input retained, no duplicate draft; submit only after save success.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-1ed2d3c6b615

Feature: HOF; cases: FR-HOF-12.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Client lifecycle label changes per model, backend status unchanged; timezone/wording Q12.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d5175244954f

Feature: HOF; cases: FR-HOF-13.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Cancel leaves form unchanged; save updates selected patient only; validation shown before submit.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-a1e044229b64

Feature: NOT; cases: FR-NOT-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Dedupe by ID, badge/list consistent; mutation failure restores or refreshes correct state.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-505217da6143

Feature: RT; cases: FR-RT-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Correct peer/channel typing state; no self indicator; timeout clears stale typing; disposed listeners do not update closed state.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-208793d5b054

Feature: RT; cases: FR-RT-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: HTTP recovers persisted state for fresh connection; limited Socket.IO recovery is tested separately; Flutter duplicate events do not duplicate messages.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-0fd5a1cf0da2

Feature: RT; cases: FR-RT-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Valid refresh reconnects with new token; failure yields session recovery UI without endless connection loop.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-74aa410f11ea

Feature: SRCH; cases: FR-SRCH-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Latest visible query owns results, no stale overwrite; error state recoverable; correct result route selected.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7e4fad24dd94

Feature: SUP; cases: FR-SUP-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Input retained on error, success acknowledgement matches ticket; routes and bundled content render; external contact intent captured only.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-68ba597c572d

Feature: NAV; cases: FR-NAV-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Login/profile setup/home respectively, no transient wrong destination; stored identity loaded.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-946e233ea9c4

Feature: NAV; cases: FR-NAV-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Success retries request with new token; failure clears session; bounded retry desired, recursion/concurrency behavior recorded for clarification.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-bf35f0c1962a

Feature: NAV; cases: FR-NAV-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Detail then documented tab history restored; no duplicate route stack or lost selected tab.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-874a2132f5d0

Feature: OFF; cases: FR-OFF-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Optimistic row reconciled to one server ID, isSending cleared; text/quote retained.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-c0ab0eff31b8

Feature: OFF; cases: FR-OFF-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Failed row visibly failed, composer usable; no invented durable queue or automatic resend.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-5fb224e1a000

Feature: OFF; cases: FR-OFF-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Exact text restored; thread keys separate/excluded from channel badges; unrelated draft retained.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e5640a9eb6e1

Feature: OFF; cases: FR-OFF-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Cache offers prior messages in process; recovery replaces stale state; app restart does not promise disk transcript.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-32efc91291d3

Feature: OFF; cases: FR-OFF-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: No text-message success before upload/send success; error visible, no duplicate busy submission.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7821bb2d9619

Feature: OFF; cases: FR-OFF-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Decide retained/account-scoped data Q11; capture leak/stale UX without presuming implemented cleanup.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-e1f655749630

Feature: SAVE; cases: FR-SAVE-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: One item per ID, newest savedAt first, routes carry correct IDs; remove persists.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-9863f669c923

Feature: SAVE; cases: FR-SAVE-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Corrupt data returns empty safely; unavailable target shows recoverable error, not crash.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-091ffab0a035

Feature: SAVE; cases: FR-SAVE-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Recent channels cap 8, pins cap 12; dedup/order preserved; independent recent-space behavior not assumed capped.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-6e1687ef82d7

Feature: HOME; cases: FR-HOME-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Order/visibility survive, defaults restored, missing new widgets merged; corruption safe defaults.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-8da9f78a08f2

Feature: HOME; cases: FR-HOME-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Assigned/shift/task cards reflect current assignee/status; no separate roster state fabricated.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-daf8a03315fb

Feature: HOME; cases: FR-HOME-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Appropriate empty/action cards, correct target navigation; DM-load failure falls back to empty DMs; required repository failure sets dashboard error and retry restores data.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-217bad2c121a

Feature: LINK; cases: FR-LINK-01.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Text payload includes attribution/source link/body/media URL; one successful destination message; failure retains sheet.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-5956187329ea

Feature: LINK; cases: FR-LINK-02.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Copied vocle://c/<id>/m/<id> string exact; opening target currently incomplete, Q13 required.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-fce633d44e53

Feature: LINK; cases: FR-LINK-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Latest debounced route wins; auth queues intended destination; missing target falls back to notification/handoff list.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-23dca0d75e6c

Feature: RUN; cases: FR-RUN-03.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Error state distinct from empty result; loading terminates; retry restores correct data.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter 3.29.3 unavailable; actual SDK 3.47.2"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-50ae36c83a34

Feature: TOOLING; cases: flutter-retained.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Required check completes with valid evidence.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter SDK unavailable"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-91cc087eaf5a

Feature: TOOLING; cases: flutter-analysis.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Required check completes with valid evidence.
Actual: [{"status":"BLOCKED","error":"Pinned Flutter SDK unavailable"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7d4ed59e8523

Feature: MED; cases: FR-MED-08.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Cancel sends nothing; denial recoverable; supported selected file preview and external opener work; unsupported formats clearly fail.
Actual: [{"status":"BLOCKED","error":"Optional Android lane: rerun with --android on an isolated emulator"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-207d087daa6b

Feature: PUSH; cases: FR-PUSH-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Correct channel grouping, navigation and local reply dispatch; successful reply stored once in local backend; no real FCM proof.
Actual: [{"status":"BLOCKED","error":"Optional Android lane: rerun with --android on an isolated emulator"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-7a3684645641

Feature: PUSH; cases: FR-PUSH-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: App remains usable; refreshed token registration and logout removal verified locally; no platform delivery guarantee.
Actual: [{"status":"BLOCKED","error":"Optional Android lane: rerun with --android on an isolated emulator"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-a4998dffd18c

Feature: NAV; cases: FR-NAV-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Resume invokes connection restoration; current chat can refetch; input survives supported draft storage.
Actual: [{"status":"BLOCKED","error":"Optional Android lane: rerun with --android on an isolated emulator"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-c6a1824c8fce

Feature: NAV; cases: FR-NAV-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Secure session restoration routes correctly; logout removes local session even if API logout errors.
Actual: [{"status":"BLOCKED","error":"Optional Android lane: rerun with --android on an isolated emulator"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-88632fe39209

Feature: LINK; cases: FR-LINK-04.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Supported code extracted, no accidental join on cancel, permission recovery; join reflects actual member/pending response.
Actual: [{"status":"BLOCKED","error":"Optional Android lane: rerun with --android on an isolated emulator"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-4f52aa0a35cb

Feature: JRN; cases: FR-JRN-05.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Draft and committed content survive their supported storage scope; exactly one displayed committed message after refetch.
Actual: [{"status":"BLOCKED","error":"Optional Android lane: rerun with --android on an isolated emulator"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-94c0e0d539fb

Feature: JRN; cases: FR-JRN-06.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: HIGH (suggested; QA review required). Reproducibility: One recorded execution; rerun required.
Expected: Right handoff/assignee displayed; one acknowledgement; sender sees local backend update; no real provider proof.
Actual: [{"status":"BLOCKED","error":"Optional Android lane: rerun with --android on an isolated emulator"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-402e7d0614cc

Feature: TOOLING; cases: backend-legacy-jest.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Required check completes with valid evidence.
Actual: [{"status":"BLOCKED","error":"Two retained Jest files exist, but Jest and a Jest runner are absent from the lockfile; backend npm test is a placeholder. No assertion execution claimed."}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-564fe3638d8d

Feature: TOOLING; cases: security-runtime.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Required check completes with valid evidence.
Actual: [{"status":"BLOCKED","error":"Optional: --security reuses existing media, data and 691-case discovery runners in network-none Docker. Provider account integration stays QA-only."}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-94f26ea8b60d

Feature: TOOLING; cases: provider-accounts.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Required check completes with valid evidence.
Actual: [{"status":"BLOCKED","error":"QA-only: approved isolated test account credentials and resource cleanup; existing Cloudinary workflow"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.

## QA-d5aaeede2ea8

Feature: TOOLING; cases: ios-physical-device.
Owner: **UNASSIGNED**. Authorized maintainer must confirm owner and routing before assignment/notification.
Severity: UNASSESSED. Reproducibility: One recorded execution; rerun required.
Expected: Required check completes with valid evidence.
Actual: [{"status":"BLOCKED","error":"QA-only: platform hardware/runner required; existing coverage makes no iOS claim"}].
Reproduce: node tests/developer-workflow/run.mjs "--source" "." "--output" "tests/developer-workflow/output/actual-dirty-full".
Artifacts: run diagnostics and original reports.
Verification: RECORDED; independent QA verification pending.
