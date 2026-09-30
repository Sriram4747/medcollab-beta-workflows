# Vocle functional sanity suite — Terra implementation plan

## 1. Inspection findings and scope

**Target:** `mathiharan29/medcollab-beta`, branch `master`, as selected.

Inspected upstream revision: `4638682c0c930fcde3378d7e809612b6c0eab370`.

Upstream’s default branch currently points to `design/clinical-design-system`. The workflow must therefore explicitly track `refs/heads/master`, rather than follow upstream `HEAD`.

Read `AGENTS.md` and inspected:

- Backend startup, configuration, dependencies, middleware, validation, response handling, and database connections.
- Authentication, OTP and MSG91 widget services, profiles, preferences, availability, and device registration.
- Spaces, invitations, membership, channels, direct conversations, group conversations, and conversation expansion.
- Messages, pagination, quotes, threads, reactions, pins, read receipts, and Needl.
- Message requests, handoffs, reassignment, write-back notes, notifications, media, search, and support.
- Socket authentication, rooms, message events, typing, presence, and notification delivery.
- Existing security workflows, fixture scripts, discovery runner, representative suites, and handoff documentation.
- Differences between fork backend code and current upstream `master`.

### Important implementation facts

- Sharing a space makes users eligible for message requests; it does **not** directly enable a new one-to-one DM.
- Notifications and several message side effects run asynchronously. HTTP success alone cannot establish success.
- Logout removes a device token; it does not revoke stateless JWTs.
- Handoff submission currently does not call the existing system-message helper. Do not assert a chat card based on stale comments.
- Approval-required spaces store pending requests, but no approval endpoint exists.
- Upstream includes conversation expansion with `none`, `today`, and `all` history choices.

### Existing issues the plan must preserve visibly

Source inspection indicates:

- Message-request notifications use `referenceType: 'MessageRequest'`, which upstream’s notification schema does not accept.
- Local upload URLs conflict with the message controller’s HTTPS Cloudinary-host requirement.
- Video upload exists, but message validation excludes `video`.
- Upstream’s DM upsert differs from the fork’s repaired implementation and needs runtime verification.

These are source findings, not results from an executed sanity suite. Do not copy fork application fixes into the tested checkout, introduce expected-failure allowances, or silently drop failing assertions.

## 2. Sanity scenarios and fixtures

Implement **approximately 50 named scenarios**. Each scenario can contain several assertions and HTTP operations; avoid counting every request as a separate test.

All successful mutations require a subsequent API read or independent database check. Controls should cover ordinary user mistakes and lifecycle rules, without actor-permutation matrices or attack discovery.

| Journey | Count | Required scenarios |
|---|---:|---|
| Authentication and profiles | 7 | OTP request → verification creates a user and usable tokens; returning login preserves identity; incorrect OTP fails and correct OTP subsequently works; consumed OTP cannot be reused; onboarding unlocks application routes and profile changes persist; refresh produces a usable session and missing refresh fails; synthetic device registration deduplicates and logout removes that device. |
| Spaces and invitations | 5 | Create space with owner and exactly three default channels; preview and join invitation, then verify spaces/detail/member lists; duplicate join returns conflict without duplicate membership; rename space and regenerate invitation, with old code rejected; member leave and owner removal of another member update membership, while owner leave is rejected. |
| Channels | 3 | Create/list/read/update custom public channel and reject duplicate name; create private channel and verify creator’s normal access; archive custom channel, retain its stored messages, remove it from active lists, and reject archiving a default channel. |
| Messaging and Needl | 7 | Send/read text with correct sender and sidebar preview; paginate three roots with limit two, preserving order without overlap; quote a message and retain quote metadata; reply to a thread, verify reply count/preview/thread results and Needl entry; edit and soft-delete with corresponding socket events; toggle reaction and pin/unpin with persisted results; reject empty text and verify emergency-channel priority override. |
| Message requests | 3 | Lookup eligible peer, create request, verify sent/received lists, count, duplicate-request stability, and recipient notification; accept request, verify accepted state, DM creation, sender notification, and actual conversation; decline a separate request, reduce pending count, and reject a second terminal transition. |
| Direct and group conversations | 5 | Reopen accepted one-to-one DM from both participants and get the same ID; send/read DM with peer details and last-message preview; read receipt deduplicates, while preference-disabled receipt is omitted; notes-to-self persists and group DM creation/reopening/rename preserves exact membership; expand separate conversations using `none` and `all`, verify new membership and expected copied content while source history remains intact. |
| Handoffs | 5 | Create/edit/read draft with synthetic patient and attachment; empty draft cannot submit and disposable draft can be deleted; submit populated draft, verify recipient inbox, space history, notification, event, and edit/delete rejection; acknowledge with note and verify timestamp, sender notification, event, and duplicate-transition rejection; add write-back note, reassign to third member, verify history and acknowledgement reset, then acknowledge as new assignee. |
| Media | 3 | Upload/download/delete small PNG with exact bytes and subsequent 404; repeat for PDF and persist its attachment metadata in a handoff; persist/read image, ECG, and document messages using inert accepted URL strings, verifying metadata and previews without fetching those URLs. |
| Notifications | 3 | Ordinary message generates inbox entry, matching unread count, reference metadata, and personal socket event; mention and emergency messages produce their respective notification types/priorities; single read/unread, channel read, read-all, and delete update lists and counts consistently. |
| Realtime and availability | 3 | Authenticate two clients, await `authenticated`, join channel, receive REST-created message, disconnect/reconnect and rejoin successfully; typing start/stop reaches peer with correct IDs; REST and socket availability updates persist and broadcast, room synchronization acknowledges, and final disconnect updates presence. |
| Search | 2 | Known-user search and phone lookup find expected synthetic colleague; global search finds matching message, doctor, channel, attachment, and handoff, with a nonmatching query returning empty results. |
| Support | 1 | Submit one bug report and verify stored ticket ID, author, type, title, and description; missing required title fails. |
| Startup | 1 | Health reports connected MongoDB, test environment, and disabled Firebase/Cloudinary. |
| **Total** | **48** | Current implementation scope: all explicitly listed scenarios run whenever testing is required. |

### Fixture design

- Use five synthetic identities with fixed labels and reserved fictional numbers, for example `+12025550101` through `+12025550105`.
- A/B/C share a synthetic institution and join the main space. D/E remain unrelated; explicitly enable request acceptance preferences where needed.
- Create identities and ordinary journey resources through public APIs. Capture returned IDs and invite codes instead of assuming generated values.
- Use fixed text markers, names, patient aliases, and a fixed UTC handoff date. Assert timestamp ordering rather than exact wall-clock values.
- Use two or three disposable spaces to keep membership cleanup independent of messaging and handoff scenarios.
- Read MongoDB directly for otherwise invisible state, such as device tokens, soft deletion, and support tickets. Do not use database writes to perform the operation being tested.
- Separate modules may seed prerequisite resources through upstream models when an earlier journey fails; report that setup explicitly. Never count seeded setup as passing the failed API journey.
- Use a fresh database for each complete run. No production fixtures, real contacts, or copied clinical data.

### External substitutes

Use a sanity-owned Node preload with an HTTP interception library:

- Run real OTP logic with `OTP_BYPASS=false`.
- Intercept only the exact MSG91 SMS/widget endpoints, using dummy configuration.
- Capture generated OTPs in a private fake inbox for the test driver; verify through the actual endpoint and hashed OTP model.
- Add a widget happy-path assertion within the authentication scenario using an opaque synthetic token and a fixed provider response.
- Keep Firebase and Cloudinary unconfigured. Exercise real local media storage and real database/socket notifications.
- Never replace controllers, authentication middleware, models, or business services.

The media scenario intentionally covers local storage and accepted message metadata separately. Report upload-to-message integration and video messaging as uncovered existing limitations, not as passing end-to-end journeys.

## 3. Workflow, upstream selection, and success history

### Repository structure

Create:

- `.github/workflows/vocle-sanity.yml`
- `tests/sanity/` containing its own package/lockfile, configuration, workflow helper scripts, runner, fixtures, provider preload, reporting, and modular scenarios.
- `docs/VOCLE_SANITY_TERRA_PLAN.md` containing this specification, source findings, scenario IDs, commands, and acceptance checklist.

No backend public API, application schema, or application dependency changes are required.

### Workflow execution

Use GitHub-hosted Ubuntu, Node 22, and MongoDB 7.

Triggers:

- Daily cron: `17 2 * * *` — approximately 07:47 India time.
- `workflow_dispatch` with `force` boolean, default `false`.
- No push or upstream event trigger.

Require the exact repository `Sriram4747/medcollab-beta-workflows` and `refs/heads/master`. Verify fork `master` is its default branch when enabling scheduling. GitHub scheduled workflows run from the default branch and can be delayed or disabled after inactivity. Document checking that the schedule remains enabled. [GitHub scheduling documentation](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#schedule)

Use workflow concurrency `vocle-sanity-upstream-master`, with `cancel-in-progress: false`.

Three jobs:

1. **Detect:** resolve upstream SHA, inspect successful evidence, and decide run/skip.
2. **Sanity:** conditional checkout, dependency preparation, isolated backend/database startup, complete suite, report, and cleanup.
3. **Summary:** always report PASS, FAIL, ERROR, or SKIP with revision and evidence links.

The detection job must not declare MongoDB services or install backend dependencies.

### Exact change detection

Store the inspected upstream URL and explicit branch in sanity configuration; Actions checkouts do not inherit this workstation’s remote configuration.

1. Read:
   `git ls-remote --exit-code https://github.com/mathiharan29/medcollab-beta.git refs/heads/master`
2. Require exactly one valid SHA for that exact ref.
3. Obtain the most recent verified successful sanity manifest for this upstream repository, branch, and suite fingerprint.
4. Skip only when its tested SHA equals the resolved tip and `force=false`.
5. Otherwise test the resolved SHA.

Treat any different SHA as requiring testing, including rebases, force pushes, and rollbacks. Commit dates and ancestry are not reliable substitutes for exact revision comparison.

Test the latest tip observed at detection time; do not test every intermediate commit. Changes arriving afterward are considered on the next run.

### Reliable success history

Use **fork-owned Actions artifacts plus run/job conclusions**, with `contents: read` and `actions: read`. No PAT, writable Git state branch, repository variable, tag, or upstream state is needed.

Produce a success manifest only after:

- Every expected scenario passed.
- No scenario was skipped or blocked.
- Backend provenance checks passed.
- Required reporting and cleanup completed successfully.

Manifest fields:

`schemaVersion`, upstream repository/ref/SHA, fork harness SHA, suite fingerprint, run ID, attempt number, expected/passed counts, completion time, and result.

Use an artifact name containing the run ID and attempt. The suite fingerprint hashes the sanity directory and workflow contents.

During detection:

- Paginate this workflow’s fork run history.
- Accept only completed successful runs on fork `master`, from scheduled/manual events.
- Verify the relevant attempt’s sanity job actually succeeded.
- Download and validate that attempt’s success manifest and matching fingerprint.
- Never use workflow `head_sha` as the tested upstream SHA: it identifies the fork’s harness revision.
- Never accept a skipped job, partial report, cancelled run, failed run, or artifact from a different attempt.

GitHub exposes workflow-run, job, and artifact metadata through its APIs. [Workflow runs](https://docs.github.com/en/rest/actions/workflow-runs), [workflow jobs](https://docs.github.com/en/rest/actions/workflow-jobs), [artifacts](https://docs.github.com/en/rest/actions/artifacts)

Request 90-day artifact retention, subject to repository limits. If evidence expires or is deleted, report **“successful baseline unavailable; retesting”** and run again. API outages or permission errors must report ERROR, never “no changes.”

This provides conservative cross-run correctness without pretending retained Actions history is permanent storage.

### Guarantee the tested code is upstream

- Check out the fork harness into `harness/` at the workflow’s exact commit.
- Fetch upstream into a separate `target/` repository and detach at the captured SHA.
- Assert `target` HEAD equals the detection output.
- Install dependencies using the target’s own lockfile.
- Start `target/medcollab-backend/src/server.js` with that directory as its working directory.
- Keep harness dependencies outside the backend.
- Verify tracked target files remain unchanged before and after testing.
- Record target tree SHA and backend lockfile hash in the report.
- Never overlay fork backend files or apply security-suite repairs.
- If the captured revision becomes unavailable, fail rather than substitute a newer tip or fork revision.

## 4. Isolation, reporting, and validation

### Isolation

Prepare dependencies and container images before starting application processes.

Run MongoDB with Docker `--network none`; run backend and driver containers sharing that network namespace. They communicate over loopback but have no external route. Publish no ports.

- Use only `mongodb://127.0.0.1:27017/vocle_sanity`.
- Allow only the local backend origin in test HTTP helpers; reject redirects.
- Supply a minimal explicit environment with test JWT secrets and dummy MSG91 values.
- Mount no `.env`, cloud credentials, SSH keys, Git credentials, Actions tokens, or Docker socket into runtime containers.
- Fail preflight if an application `.env` would be loaded.
- Mount application source read-only; provide separate writable uploads and output directories.
- Require database and origin guards before fixture writes.
- Check `/health` reports external providers disabled.
- Do not follow hard-coded Railway invitation URLs.
- Clean up sockets, processes, containers, volumes, and uploads in unconditional teardown.

Upstream remains read-only through credential-free fetches, no persisted checkout credentials, read-only workflow permissions, and the absence of push/PR/tag/release operations. No merge into either repository is needed.

### Reporting and failure behavior

Produce JSON, JUnit XML, Markdown, backend diagnostics, and a GitHub job summary containing:

- Upstream repository, branch, tested SHA, and harness SHA.
- Last verified successful SHA and run link.
- Reason for testing or skipping.
- Scenario counts, durations, failures, blocked dependencies, and coverage limitations.
- Isolation and provenance results.

Use bounded HTTP/socket deadlines and polling for asynchronous persistence. Register event listeners before triggering operations. Match events by resource ID; current fan-out can deliver duplicates.

Do not retry failed mutations or rerun failed scenarios until green. Poll only eventual results.

Any assertion failure, unexpected 429, missing scenario, backend crash, timeout, provenance mismatch, isolation failure, or required artifact failure makes the workflow fail. Continue independent modules to collect useful diagnostics. Blocked dependent scenarios prevent success.

Known functional failures remain gating; no security-discovery observation classification or `continue-on-error` behavior is imported.

### Infrastructure verification

Before enabling the daily schedule, test the workflow helpers against:

- First run with no history.
- Same SHA after full success: skip with no runtime startup.
- Changed SHA: complete suite.
- Failed/cancelled/skipped predecessor: no success advancement.
- Previous attempt artifact combined with failed rerun.
- Expired/deleted artifact: conservative retest.
- API outage: ERROR.
- Changed suite fingerprint at unchanged upstream SHA.
- Force-pushed branch and tip movement after detection.
- Manual force run and concurrent dispatch.
- Wrong target checkout and missing scenario.
- Deliberately failed assertion: failing workflow and no accepted success evidence.

Expected runtime: **under one minute for ordinary skips; approximately 4–8 minutes for a full run**, with a 15-minute test-job timeout. These are estimates, not measured results.

### Reuse and independence

Reuse infrastructure patterns:

- Ubuntu runner, Node 22, disposable MongoDB 7.
- Readiness polling, explicit local URLs, synthetic identities.
- HTTP plus independent persistence checks.
- Local media fallback, socket client handling, and artifact diagnostics.

Keep independent:

- Workflow, package/lockfile, fixture namespace, database, runner, scenario registry, assertions, result schema, reports, and success-history logic.
- No invocation of security discovery or its fixture scripts.
- No dependency on security observations, counts, baseline files, or repaired fork application code.

## 5. Documentation handoff and current task status

When execution is enabled, first save this specification as `docs/VOCLE_SANITY_TERRA_PLAN.md`. Include the inspected SHAs, numbered scenario manifest, known limitations, and implementation acceptance checklist. Commit only that documentation to `origin/master`; the full suite remains for the fresh Terra implementation task.

Preserve the existing unrelated Flutter/Android working-tree changes. Stage explicit documentation paths only. Verify the destination is the fork before pushing.

**Current result:**

- Backend and infrastructure inspection completed.
- Upstream `master` fetched read-only.
- Current implementation scope: **48 scenarios**.
- Files created/changed by this task: **none**.
- Commit pushed to `origin/master`: **none**.

Documentation writing and committing remain pending because this session is in **Plan Mode**, which prohibits those mutations.

## 6. Delivery phases

### Phase 1 — Harness contract and scenario inventory

**Objective:** establish a standalone, backend-independent sanity harness that makes the proposed suite concrete before any upstream runtime is started.

**Included work:**

- Create `tests/sanity/` with an independent Node 22 package and lockfile; it must not add dependencies to `medcollab-backend`.
- Add immutable target configuration for `mathiharan29/medcollab-beta`, `refs/heads/master`, the inspected SHA, fixture labels, synthetic phone-number range, test database name, and the expected local origin.
- Define an explicit registry of all 48 named scenarios, grouped by the journeys in this plan, with stable IDs and the required count for each group.
- Implement a runner self-check that validates scenario IDs, group counts, unique names, configuration guards, and report generation without contacting a backend or MongoDB.
- Implement structured JSON, JUnit XML, and Markdown report writers. Phase 1 reports must be marked `planned`/`not-executed`; they must never create success-history evidence.
- Add provenance, isolation, and external-provider preflight contracts as executable helpers. Their integration with Docker and Actions is deferred until the workflow phase.
- Copy this plan into the repository documentation path before the documentation-only commit requested by the specification. Preserve the current outer workspace copy as a working-session artifact until that commit is made.

**Exit criteria:** `npm ci` and `npm test` within `tests/sanity/` succeed; the self-check reports exactly 48 planned scenarios, emits all three report formats, and does not write application data or start any process/container.

**Not included:** GitHub workflow execution, Actions success-history lookup, OTP interception, backend startup, database fixtures, sockets, or live API assertions. Those belong to later phases and may not be represented as passed in Phase 1 output.

**Manifest reconciliation:** the journey counts in Section 2 total **48** (`7+5+3+7+3+5+5+3+3+3+2+1+1`). On 2026-09-30, implementation scope was explicitly set to those 48 named scenarios. The harness must reject a count other than 48 until a later plan revision names and approves additional scenarios.

### Phase 2 — Workflow detection, provenance, and isolation

Implement `vocle-sanity.yml`, exact upstream SHA detection, artifact-backed baseline validation, target/harness separation, Docker network isolation, readiness/cleanup, and the startup scenario.

**Implementation status (2026-09-30):** detection, fingerprinting, baseline-manifest validation, separate target checkout, and target provenance verification are implemented. The workflow deliberately prevents a Phase 1-only harness from publishing a success manifest. Docker runtime isolation, readiness/cleanup, and the live startup assertion remain pending the Phase 3 driver.

**Execution hold (2026-09-30):** the daily trigger is temporarily removed while implementation is incomplete. Do not manually dispatch the workflow until the full 48-scenario suite, its success-manifest gate, and final environment validation are ready. Re-enable `17 2 * * *` only as part of Phase 5 rollout.

### Phase 3 — Test driver, provider substitute, and core fixtures

Implement bounded HTTP/socket clients, direct read-only MongoDB checks, MSG91-only interception, five synthetic identities, and authentication/profile, space, channel, and core messaging scenarios.

**Implementation status (2026-09-30):** the bounded local-only HTTP helper and an exact-endpoint MSG91 preload are in place. The preload captures server-generated OTPs only in the private sanity inbox and returns a fixed widget-provider response for an opaque test token; it does not replace application controllers, services, models, or middleware. Fixture provisioning and live scenario execution remain pending.

### Phase 4 — Collaboration journeys

Implement message requests, direct/group conversations, handoffs, media metadata/local storage, notifications, realtime/availability, search, and support scenarios.

### Phase 5 — Evidence hardening and rollout

Add infrastructure verification cases, full reporting/artifacts/job summary, success-manifest publication rules, deliberate-failure validation, a documentation-only commit to `origin/master`, and schedule enablement checks.
