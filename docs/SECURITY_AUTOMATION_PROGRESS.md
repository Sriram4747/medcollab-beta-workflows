# Vocle security automation continuity

Updated 2026-09-25. A new session should read **AGENTS.md and this file first**,
then the linked review/map before changing tests.

## Architecture and safety

- Work only on `master` tracking `origin/master`, experimental fork
  `Sriram4747/medcollab-beta-workflows`. Never write to upstream
  `mathiharan29/medcollab-beta`, change its URL, or use/recreate
  `design/clinical-design-system`. Preserve unrelated application worktree edits.
- One pipeline: `.github/workflows/vocle-backend-environment-test.yml`, manual
  dispatch, contents:read, Ubuntu, Node 22. MongoDB 7 is disposable Docker bound
  to loopback; backend is the real Express/Mongoose application.
- Require NODE_ENV=test, exact loopback API and local vocle_ci database. Never use
  Railway, Atlas, production JWT/external credentials, real users or real phone
  numbers. No security traffic to external services. OTP bypass is only for this
  disposable environment; its application implementation is environment-variable
  controlled, so do not assume the application itself prevents production bypass.
- Fixtures use real models; authentication uses real verify-otp plus middleware.
  Masked tokens pass via GITHUB_ENV inside the runner; never commit, print or
  upload tokens/credentials. Only the sanitized results directory is an artifact.
- `scripts/security-api-discovery.js` runs real HTTP actions, with model setup
  and snapshots. No mocked authorization. Current suites run sequentially.
- Four artifacts: results.json (source of truth), summary.md (concise),
  security-test-report.md (case catalog), security-api-coverage-report.md (route
  inventory). Existing artifact name `vocle-security-discovery`, seven-day retention.
- Boot/auth/fixture/transport failures block CI; security observations currently
  do not. Snapshot checks cover scratch Space/Channel/Message/Handoff documents,
  not user last-seen, all notifications or completed async/socket side effects.

## Completed and latest evidence

Boot/health, deterministic A owner/B member/C outsider fixtures, controlled
messages/handoff, real authentication smoke and 146 discovery cases are implemented.
Human reporting and the route inventory are implemented in the same workflow.

Latest reviewed downloaded artifact: **146 executed, 138 passed, 8 observations,
no infrastructure failure**. SHA-256 of reviewed results.json:
`dbdbf40fe860f82860eaef58139b15ee9a60c0cd720ab273c0d853425c47b1d3`.
It came from local Downloads/vocle-security-discovery (2). The review independently
read those results, not the hosted job status; do not invent a run ID/commit link.
No new hosted/API run was executed in this review.

## Findings and decisions

See [SECURITY_OBSERVATION_REVIEW.md](SECURITY_OBSERVATION_REVIEW.md) for exact
route/middleware/controller/model traces, eight individual classifications,
manual scenarios and gate decisions.

- VOCLE-094/098: confirmed foreign-root reply binding defect (one root cause).
  Wider asynchronous/thread display impact needs controlled manual confirmation.
- VOCLE-099: confirmed foreign-channel handoff reference integrity defect.
  Downstream disclosure/visible impact is unconfirmed. Do not claim an unused
  system-message helper actually runs on submit.
- VOCLE-109/110/111/112: numeric/object text coercion hardening observations.
  Strict-string rejection is not currently enforced; retain observation cases
  pending policy decision. No demonstrated authentication/ownership bypass.
- VOCLE-137: test defect. Replaced 25-character ID with valid absent 24-character
  ID; kept intended 404 and unchanged total 146. Existing malformed cases keep
  400. Corrected case has not run against the API yet. Do not call 139/7 measured.
- Coverage reporter corrected: /users/me no longer also credits /users/:id.
  Baseline is 20 distinct route operations, not the old report's 21.
- No application security behavior was changed; confirmed defects remain in
  application code and their rejecting test expectations are preserved.
- No new strict CI gates enabled. Documented gate candidates need a reviewed
  fresh run; known defects remain discovery observations until separately fixed.

## Coverage and next step

Full map: [SECURITY_TEST_COVERAGE.md](SECURITY_TEST_COVERAGE.md).
73 explicit HTTP operations, plus static uploads and realtime events. Auth,
users, spaces/member boundaries, public channels/messages/threads and handoffs
are partial. At the reviewed baseline, DM, message requests, media/static
delivery, notifications, search, support, developer tools and Socket.IO security
were not covered. DM/message-request execution evidence is now pending a fresh
run; no complete business module is comprehensively covered.

**At the 146-case baseline, Direct Messages had zero API security cases.** GENERAL fixtures never exercise
DIRECT membership/receipt logic. Existing institution-normalization unit tests
are not DM integration coverage.

Exact next step: run the existing workflow on origin/master and review corrected
VOCLE-137, the 20-route attribution, and the now-implemented bounded DM +
message-request phase. It adds genuinely unrelated controlled identities while
preserving A/B/C, existing fixture/case IDs, and the single workflow.
Keep findings visible and bring application fixes through separate authorization.
Do not perform mobile interception; manual Reqable scenarios are documented only.

## DM and message-request implementation (pending fresh API evidence)

The bounded DM/message-request phase is implemented in the existing serial
discovery command, without a new workflow. The original 146 baseline cases and
their IDs are retained; the manifest now plans **243** cases: **61 Direct
Messages** and **36 Message Requests** additions. Results now carry a `module`
field and module/context information in the JSON summary, concise summary,
human-readable test report, and route coverage report.

New deterministic fixture identities are A–I. A/B/C remain unchanged. D is a
same-institution peer with no shared space; E–H have different institutions and
no shared space; I is inactive and target-only. Per-case resets explicitly model
an existing DM, archived DM, pending, declined, blocked, and accepted request
states. The suites make real HTTP calls and use models only for reset and
independent persistence/containment checks.

This workstation has no Docker, `mongod`, or `mongosh`; therefore no local API
run was substituted with mocks or `mongodb-memory-server`. Syntax, manifest, and
report-generator validation completed, but there is no fresh execution evidence
yet and no new observation is classified from this implementation alone. The
next required evidence is the existing origin/master workflow against its
loopback Docker MongoDB, followed by review of its generated `results.json`.
