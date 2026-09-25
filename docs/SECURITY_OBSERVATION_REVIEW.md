# Current observation review — 2026-09-25

The [243-case evidence review](SECURITY_RESEARCH_BATCH_2026-09-25.md) supersedes baseline counts and pending-execution statements below: 230 passes, 13 observations; three confirmed security roots, four hardening cases and three unresolved functional errors. VOCLE-159 is the new DM member-list authorization finding; 193/197 extend the known reply-binding root. Corrected 137 now passes with 404. Original historical evidence and findings remain unchanged below.

---

# Review of the eight baseline observations

Reviewed 2026-09-19 against source at `bb05fb875263102823fdd994e6ec48c99330c4b6`.
Evidence: the downloaded `vocle-security-discovery (2)/results.json` artifact,
SHA-256 `dbdbf40fe860f82860eaef58139b15ee9a60c0cd720ab273c0d853425c47b1d3`.
It records 146 executed, 138 passed, eight observations, no infrastructure failure.
The artifact was inspected locally; this review did not independently observe the
hosted job or perform a new API run. Do not present projected results as a new run.

## Classification of every observation

| Case | Actual result | Reviewed classification | Disposition |
| --- | --- | --- | --- |
| VOCLE-094: foreign-channel reply, A | 201, success, tracked state changed | Confirmed resource-binding security issue | Preserve rejection expectation; same root cause as 098 |
| VOCLE-098: foreign-channel reply, B | 201, success, tracked state changed | Confirmed resource-binding security issue | Preserve rejection expectation; normal member also affected |
| VOCLE-099: foreign handoff channelId | 201, success, tracked state changed | Confirmed cross-space reference integrity/security issue | Preserve rejection expectation; downstream disclosure is unconfirmed |
| VOCLE-109: numeric text POST | 201, success, tracked state changed | Validation/hardening issue | String coercion is implemented; strict-type policy still needs product decision |
| VOCLE-110: numeric text PUT | 200, success, tracked state changed | Validation/hardening issue | Same coercion, edit path |
| VOCLE-111: object text POST | 201, success, tracked state changed | Validation/hardening issue | No demonstrated authorization bypass or code execution |
| VOCLE-112: object text PUT | 200, success, tracked state changed | Validation/hardening issue | Same coercion, edit path |
| VOCLE-137: purported absent ObjectId | 400, failure, tracked state unchanged | Incorrect test input/expectation; application behaved correctly | Repaired 25-character input to valid, absent 24-character ID; retain expected 404 |

The first three cases represent **two distinct security defects**, not three
unrelated vulnerabilities. Confirmation is limited to accepting invalid resource
relationships. Severity, mobile visibility and downstream disclosure are not
established by an HTTP status or the aggregate database snapshot alone.

## Foreign-channel replies: VOCLE-094 and VOCLE-098

Actors A/B can access channel AB; the target root message belongs to C's separate
channel. Neither actor has access to C's channel.

Trace:

1. [message.routes.js](../medcollab-backend/src/features/messages/message.routes.js):
   `POST /api/channels/:channelId/messages/:id/reply`, `protect`,
   `requireOnboarding`, `validateMongoId('id')`, `validateSendMessage`.
2. [auth.js](../medcollab-backend/src/middleware/auth.js): `protect` verifies JWT
   signature/expiry and active user. Authentication is working in these cases.
3. [validate.js](../medcollab-backend/src/middleware/validate.js): checks identifier
   syntax and message fields, not parent-message/channel ownership.
4. [message.controller.js](../medcollab-backend/src/features/messages/message.controller.js):
   `replyToThread` copies the URL message ID into `threadId` and calls `sendMessage`.
   `resolveChannelAccess` authorizes only the URL channel. Unlike `getThread`,
   `editMessage` and `deleteMessage`, this path never calls `assertMessageInChannel`.
5. [channelAccess.js](../medcollab-backend/src/utils/channelAccess.js) defines the
   explicit containment rule used by those other handlers.
6. [message.model.js](../medcollab-backend/src/features/messages/message.model.js)
   stores `threadId` as an ObjectId reference without a cross-channel validator.

The executed requests created accepted replies using C's root ID. The secure rule
is rejection with 403/404 and no resource mutation. `sendMessage` additionally
schedules a root-message `replyCount`/`lastReply` update by ID alone, while
`getThread` selects replies by `threadId` without an additional channel predicate.
Those paths explain possible cross-channel thread contamination; the artifact's
aggregate snapshot does not prove which asynchronous root fields changed.

Manual follow-up (local disposable app build and Reqable only): sign in as A,
then B, replay an ordinary reply against AB but substitute the controlled C root
ID in the URL. As C, open that root's thread and inspect the message/count/preview.
Confirm integrity impact if the foreign reply appears or C's root bookkeeping
changes. Secure behavior rejects the reply and leaves both channels unchanged.
Record sanitized statuses and controlled labels only. API evidence already
confirms the binding defect; manual work establishes the visible impact.

## Foreign handoff channel: VOCLE-099

Trace:

1. [handoff.routes.js](../medcollab-backend/src/features/handoffs/handoff.routes.js):
   `POST /api/handoffs`, `protect`, `requireOnboarding`, `validateCreateHandoff`.
2. `validateCreateHandoff` checks recipient/date/shift/patient inputs, not that
   `channelId` belongs to `spaceId`.
3. [handoff.controller.js](../medcollab-backend/src/features/handoffs/handoff.controller.js):
   `createHandoff` checks that A and recipient B belong to AB, then stores the
   supplied channel ID without looking up that channel or its membership.
4. [handoff.model.js](../medcollab-backend/src/features/handoffs/handoff.model.js):
   `spaceId` and `channelId` references do not enforce mutual containment.

A created an AB draft referencing C's channel. This violates resource integrity;
reject with 400/403/404 and no draft write. The foreign-space and foreign-recipient
variants (100/101) passed, so this is specifically the unchecked channel reference.

Manual follow-up: create the same synthetic draft with the substituted C channel,
inspect it as A/B, and observe how the local app links/navigates to its channel.
If assessing submission, use only synthetic handoff content and verify which
controlled recipient/channel receives it. Secure behavior rejects the invalid
association. Cross-channel delivery or exposure would establish additional impact.
Do not claim such exposure now: `postHandoffSystemMessage` exists in the controller
but the current submit/acknowledge paths do not invoke it. Their broadcasts target
the handoff's space; notifications target its participants.

## Text coercion: VOCLE-109 through VOCLE-112

POST follows `validateSendMessage` -> `sendMessage`; PUT has an inline
`content.text` validator -> `editMessage`. Both routes run authentication and
channel access; PUT additionally checks sender ownership. Their validators use
`.trim().notEmpty().isLength({ max: 4000 })` without `.isString()` before sanitation.
The [Message content schema](../medcollab-backend/src/features/messages/message.model.js)
stores a String. The recorded 201/200 responses are consistent with sanitizer
coercion of numbers/objects before controller persistence, rather than storing
an arbitrary executable object or bypassing message ownership.

Strict rejection of non-string JSON is a reasonable hardening policy but is not
currently enforced or unambiguously specified. Preserve these four tests as
non-gating hardening observations pending that decision. Do not normalize them to
PASS just to remove observations, and do not claim every successful mutation is
a vulnerability. The saved artifact does not contain the resulting text value.

Manual follow-up is optional for usability/security impact: in a disposable
conversation, replace text with a number or empty object, create/edit as the owner,
then reload as the permitted reader. Inspect the serialized text and mobile
rendering. Unexpected disclosure, crash, or misattribution would warrant escalation;
ordinary string rendering establishes coercion only. A strict-type policy would
require 400 and no write; a coercion policy needs explicit safe-string assertions.

## ObjectId: VOCLE-137

The original test ID is **25** hex characters. `validateMongoId` correctly rejects
it with 400 before `space.controller.getSpaceById`. The error handler also maps
Mongoose CastError to 400. This is expected application behavior, not a finding.
The testcase now supplies a reserved 24-character ID absent from the fixture map,
preserving the intended 404 test and the total of 146 cases. Other cases still
check malformed IDs with 400. No mobile confirmation is needed. The corrected
case needs the next disposable run; 139/7 would be a projection, not measured data.

## Regression decisions

No new strict CI gates are enabled in this review. Discovery observations remain
non-blocking; infrastructure/auth/fixture/transport failures remain blocking.

- Candidate permanent gates: malformed ID -> 400; valid absent resource -> 404;
  invalid/absent JWT -> 401; outsider denied; sender-only message edits; owner/admin
  deletion rule; owner-only space changes; draft sender actions; immutable submitted
  handoffs; recipient-only acknowledgement and replay rejection. Preserve each
  route's actual denial contract (e.g. acknowledgement can return 400).
- Future fix-verification gates: foreign replies and foreign-channel handoffs must
  reject and preserve state. Keep their demonstrating cases; do not gate on the
  present insecure success or silently repair production code.
- Four coercion cases: keep non-gating until the API type policy is decided.
- Before enabling gates, isolate/wait for asynchronous effects: snapshots cover
  scratch Space/Channel/Message/Handoff documents, not User.lastSeenAt,
  notifications, sockets or all eventual writes. A passed status alone is not
  complete isolation proof. Review strict cases against a fresh run first.

The historical artifact is unchanged. Its original automatic labels remain
historical data; this document supplies the reviewed interpretation.
