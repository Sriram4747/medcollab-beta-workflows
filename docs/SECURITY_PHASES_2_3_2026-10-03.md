# Phase 2, Phase 3 and bounded Phase 4 expansion

Started 2026-10-03; completed and reviewed 2026-10-04. Final hosted [run 37144805902](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37144805902), source `f559332b82783b7fee4341434e15c49ec25dc728`: **626/626 executed, 566 passes, 60 observations, infrastructure healthy**. HTTP route coverage **70/77 (90.9%)**. All original 386 retain **348 passes / 38 observations** and exact IDs/expectations. All 579 prior expansion pass/observation outcomes are unchanged.

| Batch | Module/file | Added | IDs | Passes | Observations |
| --- | --- | ---: | --- | ---: | ---: |
| Phase 2 | `users-profiles.js` | 75 | VOCLE-387–461 | 71 | 4 |
| Phase 3 | `space-lifecycle.js` | 53 | VOCLE-462–514 | 51 | 2 |
| Phase 3 | `consent-handoffs.js` | 65 | VOCLE-515–579 | 58 | 7 |
| Bounded HTTP Phase 4 | `bounded-http.js` | 47 | VOCLE-580–626 | 38 | 9 |
| **Expansion** | | **240** | | **218** | **22** |

Phase 2 traverses all seven previously uncovered user routes: public-profile identity/credential minimization, inactive/incomplete public-read contract, pair-bound lookup metadata and real request eligibility, known-user search union/exclusion/intersection/regex boundaries, private Needl controls, caller-only profile writes, computed onboarding, preference merging/injection, availability validation, synthetic device dedup/cap/logout. Public preferences/activity exposure and foreign-space membership inference are policy/hardening questions, not blanket foreign-profile denials.

Phase 3 traverses five missing space operations, group DM, notes and reassignment: caller ownership/default-channel bindings, creation validation, invite preview allowlist, owner/admin/member/outsider rotation with old-code invalidation/new-code join, direct/pending/replay/inactive joins, self-leave/owner protection, independent-admin removal, immediate REST/list/search/Needl revocation, group eligibility/duplicate/boundary/no-partial-write checks, and handoff participant/state matrices with history, acknowledgement reset, note attribution and notification audience. Group-derived consent and removed-party handoff access remain explicit policy questions.

Phase 4 was implemented only after healthy Phase 2/3 [run 37144068281](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37144068281): 579/579, 528 passes, 51 observations, 66/77 routes. It adds reactions, private pins/unpins, archive mutation policy, quote binding, mention notification audience and support ticket ownership/type/truncation/authentication. Developer tools, platform/deep links, broader realtime recovery/expiry/deactivation/cache/crash behavior and provider delivery remain deliberately deferred.

No setup, fixture/reset, backend health, authentication or execution failure occurred in either hosted run. The runner now snapshots synthetic-owned spaces/default resources and user-scoped SupportTickets, deletes only controlled tickets, verifies zero tickets on reset, and reports explicit semantic invariants for confidentiality/policy checks. Follow-up strengthens revoked Needl and unavailable-target identity evidence without changing names, statuses or IDs. The existing workflow adds syntax and original 386-case canonical manifest checks. Local syntax/manifest checks pass; no local backend execution is claimed because MongoDB/Docker are unavailable on this workstation.

The 22 new reviewed observations comprise eight confirmed security cases across three roots, ten hardening/lifecycle cases and four consent/audit questions. Read [findings](SECURITY_FINDINGS_2026-10-04.md), [per-observation review](security-evidence/37144805902/reviewed-observations.json), [coverage](security-evidence/37144805902/security-api-coverage-report.md) and [execution hashes](security-evidence/37144805902/execution.json). All four reports are generated from actual hosted execution and preserved; historical raw reports remain unchanged. Legacy trailing whitespace in old testcase headings is retained as raw evidence.

## Files changed

- New modules under `medcollab-backend/scripts/security/suites/`: `users-profiles.js`, `space-lifecycle.js`, `consent-handoffs.js`, `bounded-http.js`.
- New `medcollab-backend/scripts/security-manifest-check.js`; updated `scripts/security-api-discovery.js` and `.github/workflows/vocle-backend-environment-test.yml`.
- Updated `docs/SECURITY_AUTOMATION_PROGRESS.md`, `SECURITY_TEST_COVERAGE.md`, `SECURITY_TERRA_NEXT_PHASE.md`; new this batch document and `SECURITY_FINDINGS_2026-10-04.md`.
- Retained `docs/security-evidence/37144068281/` and `37144805902/`: each has `results.json`, `summary.md`, `security-test-report.md`, `security-api-coverage-report.md`, `reviewed-observations.json`; the final directory also has `execution.json` with source/run/artifact/report hashes.

Implementation commits: `afd22893cc581509f4775b112b4cc6d5fc4e7b17` (Phases 2/3), `f559332b82783b7fee4341434e15c49ec25dc728` (bounded Phase 4 and evidence improvements). The final evidence commit is documentation/reports only relative to the final executed source. All pushes target only the experimental fork's origin/master; upstream, application source and unrelated Flutter/Android worktree edits are untouched. No production services/credentials/identities, real phone numbers, provider delivery or returned Railway links are used.
