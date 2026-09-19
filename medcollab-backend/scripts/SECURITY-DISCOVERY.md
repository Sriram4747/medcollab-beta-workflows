# Disposable API discovery baseline

Run only in the existing backend environment workflow, after fixture verification
and authentication smoke checks. `node scripts/security-api-discovery.js --list`
prints the complete deterministic manifest without connecting to any service.
The default command executes 146 cases serially against the real local API.

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
space membership; private/DM access uses explicit membership (with an admin
exception in channelAccess). Messages enforce sender ownership and channel binding.
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
MongoDB snapshots independently detect writes during denied requests. Expected
successful edits/deletes/acknowledgements/member removal also check persistence;
lists and ownership injection have selected content assertions. This is not a
complete response-schema or side-effect audit. Asynchronous notifications are
outside snapshot scope; concurrency testing is deferred.

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

Local validation covers syntax, manifest generation and fail-closed preflight.
This does not establish API results: run the workflow to obtain the baseline.
