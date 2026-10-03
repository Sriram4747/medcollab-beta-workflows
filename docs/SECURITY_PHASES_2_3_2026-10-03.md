# Phase 2 and 3 security expansion — 2026-10-03

Implementation pending hosted execution. The verified baseline remains run 36664384991: 386 executed, 348 passes, 38 observations. No new measured result is claimed yet.

| Batch | Module | Added cases | IDs |
| --- | --- | ---: | --- |
| Phase 2 | Users and Profiles | 75 | VOCLE-387–461 |
| Phase 3 | Space Lifecycle | 53 | VOCLE-462–514 |
| Phase 3 | Consent and Handoffs | 65 | VOCLE-515–579 |

All original 386 registration positions, names, statuses and semantic/preparation flags remain unchanged. `scripts/security-manifest-check.js` checks their canonical manifest SHA-256 against the starting checkout. Existing artifacts and observation dispositions remain historical evidence. No application behavior or vulnerability is patched.

Phase 2 traverses all seven previously uncovered user routes: public-profile identity/credential minimization, inactive/incomplete public-read contract, pair-bound lookup metadata and real request eligibility, known-user search union/exclusion/intersection/regex boundaries, private Needl controls, caller-only profile writes, computed onboarding, preference merging/injection, availability validation, synthetic device dedup/cap/logout. Public preferences/activity exposure and foreign-space membership inference are policy/hardening questions, not invented foreign-profile read denials.

Phase 3 traverses the five missing space operations, group DM, notes and reassignment. It covers caller ownership/default-channel bindings, creation validation, invite preview field allowlist, owner/admin/member/outsider rotation with old-code invalidation and new-code join, direct/pending/replay/inactive joins, self-leave/owner protection, independent-admin removal, immediate REST/list/search/Needl revocation, group peer eligibility/duplicate/boundary/no-partial-write checks and handoff participant/state matrices with history, acknowledgement reset, note attribution and notification audience. Group-derived messaging consent and removed-party handoff write access are explicitly recorded as policy questions. Inactive/incomplete targets and private Needl previews use secure lifecycle/confidentiality expectations, with observations retained if the implementation differs.

The runner extends settled snapshots to all spaces created by synthetic fixture users and their default channels/messages/handoffs. Selective reset already removes those owned resources, synthetic DMs, notifications, OTPs and restores User fields. No real user, production API/database, SMS, FCM or Cloudinary integration is used. Returned Railway join links are inert metadata and never followed. Model changes only establish preconditions; case actions use actual HTTP routes and real Mongoose persistence.

Hosted execution, reviewed observations, final coverage, evidence hashes and corrections will be appended after the run. Phase 4 remains conditional on healthy Phase 2/3 execution; provider integrations, socket recovery/token-cache/crash supervision and nonexistent approval/owner-transfer APIs remain deferred.
