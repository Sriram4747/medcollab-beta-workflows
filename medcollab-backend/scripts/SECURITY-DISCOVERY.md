# Current suite status — 2026-09-26

The serial suite now registers **352 cases**. [Run 36228675577](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36228675577) executed all: 312 passed, 40 observations. Read the [current findings](../../docs/SECURITY_FINDINGS_2026-09-26.md) and [Terra plan](../../docs/SECURITY_TERRA_NEXT_PHASE.md) before implementation. Current coverage is 46/77 routes. Media and 21 actual socket cases are implemented; older deferral/count statements below are historical.

Current policy: shared institution permits discovery, not automatic DM; active existing DM or accepted request permits messaging. Shared active space or target opt-in permits message requests. Self notes are intentional. Three lifecycle cases currently fail their opt-in precondition; see the review. Use `--list` for an offline manifest. No application fix is authorized in this analysis phase.

---

## Historical implementation notes

# Disposable API discovery baseline

Run only in the existing backend environment workflow, after fixture verification
and authentication smoke checks. `node scripts/security-api-discovery.js --list`
prints the complete deterministic manifest without connecting to any service.
The default command executes 243 cases serially against the real local API: the
preserved 146-case group/space/handoff baseline, 61 direct-message cases, and 36
message-request cases.

## Authorization matrix and evidence

| Operation | A (owner) | B (member) | C (outsider) | Anonymous | Evidence |
| --- | --- | --- | --- | --- | --- |
| Space/member/channel/message list or detail | 200 | 200 | 403 | 401 | space.controller, channel.controller, channelAccess, message.controller |
| Own-space list | includes AB | includes AB | excludes AB | 401 | space.controller.getMySpaces |
| Space update/member removal | 200 | 403 | 403 | 401 | space.controller.updateSpace/removeMember |
| Message create | 201 | 201 | 403 | 401 | channelAccess + message.controller.sendMessage |
| Message edit | own only | own only | 403 | 401 | message.controller.editMessage |
| Message delete | own or B's | own only | 403 | 401 | message.controller.deleteMessage |
| Handoff read (A to B) | 200 | 200 | 403 | 401 | handoff.controller.getHandoffById |
| Draft edit/delete/submit | 200 | 403 | 403 | 401 | handoff controller sender checks |
| Submitted edit/delete | 400 | 403 | 403 | 401 | handoff lifecycle checks |
| Acknowledge | 400 | 200 | 400 | 401 | atomic recipient/status predicate |
| Create handoff to B in AB | 201 | 201 | 403 | 401 | createHandoff membership checks |

All protected routes use `protect`: JWT signature/expiry verification plus a
database lookup of the active user. Resource routes also require onboarding.
Space roles are separate from medical roles. Public channel access derives from
space membership; private channel access allows explicit members or a space admin;
DM access requires explicit membership. Message read/edit/delete handlers check
channel binding, but the reply path has a confirmed binding gap (see review below).
Handoffs enforce sender/receiver and draft/submitted state, with admin audit access.

Cross-channel edit/delete/read/reply and cross-space handoff references have a
security expectation of rejection (400/403/404 as appropriate). That expectation
comes from resource containment and the route/helper comments, even where a
controller may omit a check. Acceptance is a candidate finding, not an automatic
claim of exploitability. Wrong string primitive types are hardening expectations:
express-validator sanitizers can coerce them, so acceptance is not automatically
classified as authorization bypass.

Mutations are bounded and derived from validateSendMessage, validatePagination,
validateCreateHandoff, message route validators, and model constraints: missing,
null, empty, number/object/array text; text lengths 1/3999/4000/4001; enums;
malformed and absent ObjectIds; foreign user/space/channel references; unexpected
ownership fields; pagination 0/1/99/100/101; handoff required fields; acknowledgement
replay. Auth cases cover absent/malformed schemes, invalid JWT, and a changed
signature. Positive cases use real A/B/C tokens from the existing auth smoke step.

## Isolation and result interpretation

Exact local API URI, database URI, test mode and known test signing configuration
are asserted before traffic. Redirects are rejected and requests have a 10-second
deadline. External service credentials must be absent. No production URLs are
used. No auth endpoints are fuzzed and no SMS/upload/media traffic is generated.

The original fixture world remains intact. Scratch AB/C spaces, channels, three
messages and one handoff use reserved deterministic IDs. Real Mongoose models
create/reset them before each case; only their IDs and dependent scratch resources
are removed. This enables independent destructive cases and repeatable reruns.
Test actions themselves go through HTTP, Express, auth, controllers and MongoDB.
Settled MongoDB snapshots independently detect writes during denied requests,
including fixture notifications. The runner waits for post-response work before
comparing state and verifies the exact reset baseline before each case. Every
currently successful case has a semantic check: allowed reads assert controlled
identities/containment and mutations assert persisted state. Expected denials also
require an error envelope without a success `data` payload. Socket/FCM delivery,
complete response minimization and concurrency testing remain outside this suite.

JSON includes every case, source paths, expected statuses, actual status/envelope,
state preservation, classification and manual follow-up flag. Markdown summarizes
observations. Raw bodies, Authorization headers, tokens and credentials are never
included. Reports live under RUNNER_TEMP/vocle-security-results and only this
directory is uploaded (7-day retention); a concise summary appears in Actions.

Discovery observations do not fail the workflow. Safety/setup/authentication,
fixture reset, transport, unexpected execution errors, or failed health checks
do. A 5xx is recorded as an observation only if the backend remains healthy.
Partial reports survive infrastructure failures. Review results.json before
promoting selected expectations to regression gates or confirming via Reqable.

Reviewed adjacent DM/message-request and media routes/controllers: DM eligibility
also includes shared institution/accepted requests, so C being outside AB does not
imply C cannot DM A/B (all original fixtures share an institution). Broad DM,
private-channel, media, Socket.IO, load, refresh/expiry and randomized fuzz testing
are intentionally deferred. No application security behavior is changed here.

## Direct-message and message-request phase

The modular suites in `security/suites/direct-messages.js` and
`security/suites/message-requests.js` run after the baseline in the same process
and workflow. A/B are participants in a controlled DM; D is a same-institution
nonparticipant; E–H are different-institution, no-shared-space identities; I is
an inactive target-only identity. Resets establish an existing and archived DM,
plus pending, declined, blocked, and accepted request states.

The suites cover participant/third-party/anonymous permutations for DM list,
creation, detail, member metadata, messages, ownership, threads, foreign-message
binding, receipts, pins, archived access, known-user pair idempotency, and target
validation. Request coverage includes recipient-scoped list/count, pending and
reciprocal behavior, each relationship state, recipient-only accept/decline,
replay, request schemas, blocked paths, and accepted/declined DM binding.

`results.json` records each case's `module`; the human security report includes
module/context per case and the route coverage report preserves module counts for
shared group/DM message paths. These are execution reports: inspect a fresh
artifact before stating any expanded case passed or before classifying a case as a
security observation.

Local validation covers syntax, manifest generation and fail-closed preflight.
This does not establish API results: run the workflow to obtain the baseline.

## Reviewed evidence and continuation

The latest reviewed artifact before the quality hardening is run 36168079327:
243 cases, 230 passes and 13 observations. See the
[quality review](../../docs/SECURITY_SUITE_QUALITY_REVIEW_2026-09-25.md),
[observation classifications](../../docs/SECURITY_OBSERVATION_REVIEW.md),
[coverage map](../../docs/SECURITY_TEST_COVERAGE.md), and
[continuity instructions](../../docs/SECURITY_AUTOMATION_PROGRESS.md).
The corrected absent-ID case passed; DM and message-request suites executed.
Post-quality-change results require a fresh isolated workflow run and must not be
inferred from syntax or manifest checks.
