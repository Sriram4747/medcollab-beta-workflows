# Vocle API Security Test Report

This report is generated from the security cases that actually executed in the disposable local CI environment. `results.json` remains the machine-readable source of truth; `summary.md` is the concise run summary.

## Controlled test identities and resources

- User A = space owner/admin.
- User B = normal member.
- User C = authenticated outsider/non-member; User D = same-institution peer without channel membership.
- Users E–H = different-institution, no-shared-space message-request identities; User I = inactive target-only identity.
- Anonymous = unauthenticated caller.

Controlled resources include group and direct messages, relationship-state message requests, and handoffs between controlled users. All requests target the disposable local backend and database only.

## Report summary

- Total tests executed: 352/352
- Passed: 312
- Observations: 40
- Infrastructure status: healthy
- Security-area breakdown:
  - Authentication: 10
  - Authorization: 21
  - Authorization / Ownership: 150
  - Authorization / Workflow Integrity: 1
  - Direct-message Authorization: 60
  - Input Validation: 67
  - Message-request Authorization: 30
  - Resource Isolation / IDOR: 13
- Module breakdown:
  - Baseline group, space, and handoff security: 146
  - Cross-module: 8
  - Direct Messages: 61
  - Extended API: 49
  - Media: 31
  - Message Requests: 36
  - Realtime: 21

## Security Observations Requiring Review

- [VOCLE-094 — cross-channel reply by A](#vocle-094--cross-channel-reply-by-a): expected HTTP 403/404, received HTTP 201; likely security finding.
- [VOCLE-098 — cross-channel reply by B](#vocle-098--cross-channel-reply-by-b): expected HTTP 403/404, received HTTP 201; likely security finding.
- [VOCLE-099 — handoff foreign channelId](#vocle-099--handoff-foreign-channelid): expected HTTP 400/403/404, received HTTP 201; likely security finding.
- [VOCLE-110 — message text number PUT](#vocle-110--message-text-number-put): expected HTTP 400, received HTTP 200; validation weakness/hardening opportunity.
- [VOCLE-112 — message text object PUT](#vocle-112--message-text-object-put): expected HTTP 400, received HTTP 200; validation weakness/hardening opportunity.
- [VOCLE-159 — read direct-message member metadata](#vocle-159--read-direct-message-member-metadata): expected HTTP 403, received HTTP 200; likely security finding.
- [VOCLE-168 — same-institution DM creation is pair-idempotent](#vocle-168--same-institution-dm-creation-is-pair-idempotent): expected HTTP 200, received HTTP 403; ambiguous / requires manual investigation.
- [VOCLE-171 — self DM is rejected](#vocle-171--self-dm-is-rejected): expected HTTP 400, received HTTP 200; likely security finding.
- [VOCLE-193 — foreign direct-message ID reply](#vocle-193--foreign-direct-message-id-reply): expected HTTP 403/404, received HTTP 201; likely security finding.
- [VOCLE-197 — foreign direct-message ID reply](#vocle-197--foreign-direct-message-id-reply): expected HTTP 403/404, received HTTP 201; likely security finding.
- [VOCLE-218 — known same-institution user needs no message request](#vocle-218--known-same-institution-user-needs-no-message-request): expected HTTP 400, received HTTP 403; ambiguous / requires manual investigation.
- [VOCLE-219 — pending request is idempotent for the sender](#vocle-219--pending-request-is-idempotent-for-the-sender): expected HTTP 200, received HTTP 403; ambiguous / requires manual investigation.
- [VOCLE-220 — reciprocal pending request exposes accept-incoming only to sender](#vocle-220--reciprocal-pending-request-exposes-accept-incoming-only-to-sender): expected HTTP 200, received HTTP 403; ambiguous / requires manual investigation.
- [VOCLE-221 — declined relationship can create a fresh request](#vocle-221--declined-relationship-can-create-a-fresh-request): expected HTTP 201, received HTTP 403; ambiguous / requires manual investigation.
- [VOCLE-267 — handoff draft inbox privacy ?type=received&status=draft](#vocle-267--handoff-draft-inbox-privacy-type-received-status-draft): expected HTTP 200, received HTTP 200; ambiguous / requires manual investigation.
- [VOCLE-268 — handoff draft direct receiver privacy](#vocle-268--handoff-draft-direct-receiver-privacy): expected HTTP 403/404, received HTTP 200; likely security finding.
- [VOCLE-270 — search draft handoff privacy](#vocle-270--search-draft-handoff-privacy): expected HTTP 200, received HTTP 200; ambiguous / requires manual investigation.
- [VOCLE-271 — search draft handoff privacy](#vocle-271--search-draft-handoff-privacy): expected HTTP 200, received HTTP 200; ambiguous / requires manual investigation.
- [VOCLE-272 — private group excluded member read ](#vocle-272--private-group-excluded-member-read): expected HTTP 403, received HTTP 200; likely security finding.
- [VOCLE-273 — private group excluded member read /members](#vocle-273--private-group-excluded-member-read-members): expected HTTP 403, received HTTP 200; likely security finding.
- [VOCLE-275 — direct body foreign thread binding 7ec000000000000000000007](#vocle-275--direct-body-foreign-thread-binding-7ec000000000000000000007): expected HTTP 400/403/404, received HTTP 201; likely security finding.
- [VOCLE-276 — direct body foreign thread binding 7ec00000000000000000000e](#vocle-276--direct-body-foreign-thread-binding-7ec00000000000000000000e): expected HTTP 400/403/404, received HTTP 201; likely security finding.
- [VOCLE-301 — upload rejects wrong field](#vocle-301--upload-rejects-wrong-field): expected HTTP 400, received HTTP 500; validation weakness/hardening opportunity.
- [VOCLE-302 — upload rejects multiple files](#vocle-302--upload-rejects-multiple-files): expected HTTP 400, received HTTP 500; validation weakness/hardening opportunity.
- [VOCLE-303 — upload rejects forbidden MIME](#vocle-303--upload-rejects-forbidden-mime): expected HTTP 400, received HTTP 500; validation weakness/hardening opportunity.
- [VOCLE-304 — upload rejects octet forbidden suffix](#vocle-304--upload-rejects-octet-forbidden-suffix): expected HTTP 400, received HTTP 500; validation weakness/hardening opportunity.
- [VOCLE-306 — upload rejects empty bytes](#vocle-306--upload-rejects-empty-bytes): expected HTTP 400, received HTTP 200; validation weakness/hardening opportunity.
- [VOCLE-307 — upload rejects inert MIME extension mismatch](#vocle-307--upload-rejects-inert-mime-extension-mismatch): expected HTTP 400, received HTTP 200; validation weakness/hardening opportunity.
- [VOCLE-313 — media canonical owner containment single](#vocle-313--media-canonical-owner-containment-single): expected HTTP 400/403/404, received HTTP 200; likely security finding.
- [VOCLE-314 — media canonical owner containment double](#vocle-314--media-canonical-owner-containment-double): expected HTTP 400/403/404, received HTTP 200; likely security finding.
- [VOCLE-323 — local upload to authorized message integration](#vocle-323--local-upload-to-authorized-message-integration): expected HTTP 201, received HTTP 400; ambiguous / requires manual investigation.
- [VOCLE-339 — socket unauthorized typing_start foreign space](#vocle-339--socket-unauthorized-typing-start-foreign-space): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.
- [VOCLE-340 — socket unauthorized typing_stop foreign space](#vocle-340--socket-unauthorized-typing-stop-foreign-space): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.
- [VOCLE-342 — socket unauthorized typing_start foreign DM](#vocle-342--socket-unauthorized-typing-start-foreign-dm): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.
- [VOCLE-343 — socket unauthorized typing_stop foreign DM](#vocle-343--socket-unauthorized-typing-stop-foreign-dm): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.
- [VOCLE-345 — socket unauthorized typing_start private group](#vocle-345--socket-unauthorized-typing-start-private-group): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.
- [VOCLE-346 — socket unauthorized typing_stop private group](#vocle-346--socket-unauthorized-typing-stop-private-group): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.
- [VOCLE-347 — private REST message personal-room audience](#vocle-347--private-rest-message-personal-room-audience): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.
- [VOCLE-348 — membership revocation stale channel room before sync](#vocle-348--membership-revocation-stale-channel-room-before-sync): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.
- [VOCLE-349 — membership revocation stale channel room after sync](#vocle-349--membership-revocation-stale-channel-room-after-sync): expected HTTP 200, received HTTP null; ambiguous / requires manual investigation.

Observations are not confirmed vulnerabilities. A finding is only labelled confirmed after separate review and reproduction.

## Executed testcase catalog

### VOCLE-001 — read /api/spaces/7ec000000000000000000001

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/spaces/7ec000000000000000000001.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-002 — read /api/spaces/7ec000000000000000000001/members

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/spaces/7ec000000000000000000001/members.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/members`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-003 — read /api/spaces/7ec000000000000000000001/channels

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/spaces/7ec000000000000000000001/channels.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/channels`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-004 — read /api/channels/7ec000000000000000000003/messages

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-005 — read /api/handoffs/7ec000000000000000000008

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `GET`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-006 — read /api/spaces/7ec000000000000000000001/handoffs

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/spaces/7ec000000000000000000001/handoffs.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-007 — list only own spaces

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/spaces.
- Transport/method: `GET`
- Endpoint: `/api/spaces`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-008 — update space admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that an ordinary member or outsider cannot perform space-administration actions.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/spaces/7ec000000000000000000001.
- Transport/method: `PUT`
- Endpoint: `/api/spaces/7ec000000000000000000001`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-009 — create message member boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only members of the controlled space can create a channel message.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-010 — edit A message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The target message was created by User A.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-011 — delete A message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.

**Test setup:**
- User A (space owner/admin)
- The target message was created by User A.

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-012 — edit B message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The target message was created by User B.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000006.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000006`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-013 — delete B message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.

**Test setup:**
- User A (space owner/admin)
- The target message was created by User B.

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000006.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000006`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-014 — edit submitted handoff

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-015 — delete submitted handoff

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `DELETE`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-016 — acknowledge receiver only

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only the intended handoff recipient can acknowledge a submitted handoff, and that acknowledgement cannot be replayed.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs/7ec000000000000000000008/acknowledge.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/acknowledge`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-017 — remove member admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that an ordinary member or outsider cannot perform space-administration actions.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/spaces/7ec000000000000000000001/members/6ab77ca013d6c93b9e7bb2c1.
- Transport/method: `DELETE`
- Endpoint: `/api/spaces/7ec000000000000000000001/members/6ab77ca013d6c93b9e7bb2c1`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-018 — draft handoff create

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-019 — draft handoff edit

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-020 — draft handoff delete

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `DELETE`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-021 — draft handoff submit

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs/7ec000000000000000000008/submit.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/submit`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-022 — read /api/spaces/7ec000000000000000000001

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/spaces/7ec000000000000000000001.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-023 — read /api/spaces/7ec000000000000000000001/members

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/spaces/7ec000000000000000000001/members.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/members`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-024 — read /api/spaces/7ec000000000000000000001/channels

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/spaces/7ec000000000000000000001/channels.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/channels`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-025 — read /api/channels/7ec000000000000000000003/messages

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User B (normal space member)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-026 — read /api/handoffs/7ec000000000000000000008

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `GET`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-027 — read /api/spaces/7ec000000000000000000001/handoffs

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/spaces/7ec000000000000000000001/handoffs.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-028 — list only own spaces

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/spaces.
- Transport/method: `GET`
- Endpoint: `/api/spaces`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-029 — update space admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that an ordinary member or outsider cannot perform space-administration actions.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/spaces/7ec000000000000000000001.
- Transport/method: `PUT`
- Endpoint: `/api/spaces/7ec000000000000000000001`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-030 — create message member boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only members of the controlled space can create a channel message.

**Test setup:**
- User B (normal space member)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-031 — edit A message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether User B can modify a message created by User A. Message editing should be limited to the sender.

**Test setup:**
- User B (normal space member)
- The target message was created by User A.

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-032 — delete A message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.

**Test setup:**
- User B (normal space member)
- The target message was created by User A.

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-033 — edit B message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The target message was created by User B.

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000006.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000006`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-034 — delete B message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.

**Test setup:**
- User B (normal space member)
- The target message was created by User B.

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000006.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000006`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-035 — edit submitted handoff

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-036 — delete submitted handoff

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `DELETE`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-037 — acknowledge receiver only

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only the intended handoff recipient can acknowledge a submitted handoff, and that acknowledgement cannot be replayed.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/handoffs/7ec000000000000000000008/acknowledge.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/acknowledge`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-038 — remove member admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that an ordinary member or outsider cannot perform space-administration actions.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/spaces/7ec000000000000000000001/members/6ab77ca013d6c93b9e7bb2c1.
- Transport/method: `DELETE`
- Endpoint: `/api/spaces/7ec000000000000000000001/members/6ab77ca013d6c93b9e7bb2c1`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-039 — draft handoff create

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-040 — draft handoff edit

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-041 — draft handoff delete

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `DELETE`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-042 — draft handoff submit

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/handoffs/7ec000000000000000000008/submit.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/submit`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-043 — read /api/spaces/7ec000000000000000000001

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/spaces/7ec000000000000000000001.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-044 — read /api/spaces/7ec000000000000000000001/members

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/spaces/7ec000000000000000000001/members.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/members`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-045 — read /api/spaces/7ec000000000000000000001/channels

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/spaces/7ec000000000000000000001/channels.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/channels`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-046 — read /api/channels/7ec000000000000000000003/messages

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User C (authenticated outsider)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-047 — read /api/handoffs/7ec000000000000000000008

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `GET`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-048 — read /api/spaces/7ec000000000000000000001/handoffs

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/spaces/7ec000000000000000000001/handoffs.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-049 — list only own spaces

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/spaces.
- Transport/method: `GET`
- Endpoint: `/api/spaces`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-050 — update space admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that an ordinary member or outsider cannot perform space-administration actions.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a PUT request to /api/spaces/7ec000000000000000000001.
- Transport/method: `PUT`
- Endpoint: `/api/spaces/7ec000000000000000000001`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-051 — create message member boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only members of the controlled space can create a channel message.

**Test setup:**
- User C (authenticated outsider)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-052 — edit A message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)
- The target message was created by User A.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-053 — delete A message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.

**Test setup:**
- User C (authenticated outsider)
- The target message was created by User A.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-054 — edit B message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)
- The target message was created by User B.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000006.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000006`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-055 — delete B message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.

**Test setup:**
- User C (authenticated outsider)
- The target message was created by User B.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000006.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000006`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-056 — edit submitted handoff

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-057 — delete submitted handoff

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a DELETE request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `DELETE`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-058 — acknowledge receiver only

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only the intended handoff recipient can acknowledge a submitted handoff, and that acknowledgement cannot be replayed.

**Test setup:**
- User C (authenticated outsider)

**Action performed:**
Authenticated as User C (authenticated outsider), sent a POST request to /api/handoffs/7ec000000000000000000008/acknowledge.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/acknowledge`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-059 — remove member admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that an ordinary member or outsider cannot perform space-administration actions.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a DELETE request to /api/spaces/7ec000000000000000000001/members/6ab77ca013d6c93b9e7bb2c1.
- Transport/method: `DELETE`
- Endpoint: `/api/spaces/7ec000000000000000000001/members/6ab77ca013d6c93b9e7bb2c1`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-060 — draft handoff create

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-061 — draft handoff edit

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-062 — draft handoff delete

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a DELETE request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `DELETE`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-063 — draft handoff submit

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a POST request to /api/handoffs/7ec000000000000000000008/submit.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/submit`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-064 — read /api/spaces/7ec000000000000000000001

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/spaces/7ec000000000000000000001.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-065 — read /api/spaces/7ec000000000000000000001/members

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/spaces/7ec000000000000000000001/members.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/members`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-066 — read /api/spaces/7ec000000000000000000001/channels

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/spaces/7ec000000000000000000001/channels.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/channels`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-067 — read /api/channels/7ec000000000000000000003/messages

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- Anonymous caller (unauthenticated)
- The target message is in the controlled A/B channel.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-068 — read /api/handoffs/7ec000000000000000000008

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `GET`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-069 — read /api/spaces/7ec000000000000000000001/handoffs

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/spaces/7ec000000000000000000001/handoffs.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000001/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-070 — list only own spaces

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/spaces.
- Transport/method: `GET`
- Endpoint: `/api/spaces`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-071 — update space admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that an ordinary member or outsider cannot perform space-administration actions.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/spaces/7ec000000000000000000001.
- Transport/method: `PUT`
- Endpoint: `/api/spaces/7ec000000000000000000001`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-072 — create message member boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only members of the controlled space can create a channel message.

**Test setup:**
- Anonymous caller (unauthenticated)
- The target message is in the controlled A/B channel.

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-073 — edit A message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)
- The target message was created by User A.

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-074 — delete A message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.

**Test setup:**
- Anonymous caller (unauthenticated)
- The target message was created by User A.

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-075 — edit B message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)
- The target message was created by User B.

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000006.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000006`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-076 — delete B message

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.

**Test setup:**
- Anonymous caller (unauthenticated)
- The target message was created by User B.

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000006.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000006`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-077 — edit submitted handoff

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-078 — delete submitted handoff

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `DELETE`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-079 — acknowledge receiver only

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only the intended handoff recipient can acknowledge a submitted handoff, and that acknowledgement cannot be replayed.

**Test setup:**
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/handoffs/7ec000000000000000000008/acknowledge.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/acknowledge`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-080 — remove member admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that an ordinary member or outsider cannot perform space-administration actions.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/spaces/7ec000000000000000000001/members/6ab77ca013d6c93b9e7bb2c1.
- Transport/method: `DELETE`
- Endpoint: `/api/spaces/7ec000000000000000000001/members/6ab77ca013d6c93b9e7bb2c1`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-081 — draft handoff create

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-082 — draft handoff edit

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-083 — draft handoff delete

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `DELETE`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-084 — draft handoff submit

**Security area:** Authorization / Ownership

**Module/context:** Baseline group, space, and handoff security — Draft handoff A to B in AB space; only sender may edit/delete/submit

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/handoffs/7ec000000000000000000008/submit.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/submit`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-085 — authentication header missing

**Security area:** Authentication

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: Authorization header variant: missing.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-086 — authentication header basic scheme

**Security area:** Authentication

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: Authorization header variant: Basic invalid.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-087 — authentication header bearer without token

**Security area:** Authentication

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: Authorization header variant: Bearer.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-088 — authentication header invalid bearer token

**Security area:** Authentication

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: Authorization header variant: Bearer invalid.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-089 — authentication header lowercase bearer scheme

**Security area:** Authentication

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: Authorization header variant: bearer invalid.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-090 — authentication header tampered bearer token

**Security area:** Authentication

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: Authorization header variant: tampered.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-091 — cross-channel thread by A

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — C owns target message in C-only space; A/B can access URL channel only

**What this test checks:**
Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.

**Test setup:**
- User A (space owner/admin) has access to the controlled A/B channel.
- The target message belongs to User C in a separate controlled space and channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/thread`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-092 — cross-channel edit by A

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — C owns target message in C-only space; A/B can access URL channel only

**What this test checks:**
Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.

**Test setup:**
- User A (space owner/admin) has access to the controlled A/B channel.
- The target message belongs to User C in a separate controlled space and channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000007`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-093 — cross-channel delete by A

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — C owns target message in C-only space; A/B can access URL channel only

**What this test checks:**
Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.

**Test setup:**
- User A (space owner/admin) has access to the controlled A/B channel.
- The target message belongs to User C in a separate controlled space and channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000007`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-094 — cross-channel reply by A

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — C owns target message in C-only space; A/B can access URL channel only

**What this test checks:**
Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.

**Test setup:**
- User A (space owner/admin) has access to the controlled A/B channel.
- The target message belongs to User C in a separate controlled space and channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/reply.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/reply`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-095 — cross-channel thread by B

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — C owns target message in C-only space; A/B can access URL channel only

**What this test checks:**
Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.

**Test setup:**
- User B (normal space member) has access to the controlled A/B channel.
- The target message belongs to User C in a separate controlled space and channel.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/thread`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-096 — cross-channel edit by B

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — C owns target message in C-only space; A/B can access URL channel only

**What this test checks:**
Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.

**Test setup:**
- User B (normal space member) has access to the controlled A/B channel.
- The target message belongs to User C in a separate controlled space and channel.

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000007`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-097 — cross-channel delete by B

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — C owns target message in C-only space; A/B can access URL channel only

**What this test checks:**
Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.

**Test setup:**
- User B (normal space member) has access to the controlled A/B channel.
- The target message belongs to User C in a separate controlled space and channel.

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000007`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-098 — cross-channel reply by B

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — C owns target message in C-only space; A/B can access URL channel only

**What this test checks:**
Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.

**Test setup:**
- User B (normal space member) has access to the controlled A/B channel.
- The target message belongs to User C in a separate controlled space and channel.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/reply.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/reply`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-099 — handoff foreign channelId

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether the API rejects a valid identifier when it belongs to a different controlled resource or identity context.

**Test setup:**
- User A owns the controlled space.
- The referenced field is replaced with a valid controlled value from another identity or space context.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: Replaced channelId with a valid controlled resource or identity from another security context.

**Expected security behaviour:**
The API should reject the request with HTTP 400 or 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-100 — handoff foreign spaceId

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether the API rejects a valid identifier when it belongs to a different controlled resource or identity context.

**Test setup:**
- User A owns the controlled space.
- The referenced field is replaced with a valid controlled value from another identity or space context.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: Replaced spaceId with a valid controlled resource or identity from another security context.

**Expected security behaviour:**
The API should reject the request with HTTP 400 or 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-101 — handoff foreign toUserId

**Security area:** Resource Isolation / IDOR

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks whether the API rejects a valid identifier when it belongs to a different controlled resource or identity context.

**Test setup:**
- User A owns the controlled space.
- The referenced field is replaced with a valid controlled value from another identity or space context.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: Replaced toUserId with a valid controlled resource or identity from another security context.

**Expected security behaviour:**
The API should reject the request with HTTP 400 or 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-102 — acknowledgement replay

**Security area:** Authorization / Workflow Integrity

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that only the intended handoff recipient can acknowledge a submitted handoff, and that acknowledgement cannot be replayed.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/handoffs/7ec000000000000000000008/acknowledge.
- Transport/method: `POST`
- Endpoint: `/api/handoffs/7ec000000000000000000008/acknowledge`
- Mutation used: Repeated an acknowledgement after it was already accepted.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-103 — message text missing POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: missing.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-104 — message text missing PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: missing.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-105 — message text null POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: null.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-106 — message text null PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: null.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-107 — message text empty POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: empty.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-108 — message text empty PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: empty.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-109 — message text number POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: number.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-110 — message text number PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: number.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: passed.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-111 — message text object POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: object.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-112 — message text object PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: object.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: passed.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-113 — message text array POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: array.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-114 — message text array PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: array.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-115 — message text minimum POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: minimum.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-116 — message text minimum PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: minimum.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-117 — message text below-max POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: below-max.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-118 — message text below-max PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: below-max.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-119 — message text at-max POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: at-max.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-120 — message text at-max PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: at-max.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-121 — message text above-max POST

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Message text variant: above-max.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-122 — message text above-max PUT

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/7ec000000000000000000005`
- Mutation used: Message text variant: above-max.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-123 — message invalid type enum

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Invalid message field variant: type enum.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-124 — message invalid priority enum

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Invalid message field variant: priority enum.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-125 — message invalid threadId format

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Invalid message field variant: threadId format.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-126 — message invalid null content

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Invalid message field variant: null content.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-127 — message invalid array content

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Invalid message field variant: array content.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-128 — message ownership fields ignored

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: Sent client-controlled ownership and deletion fields that the API should ignore.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-129 — pagination boundary 0

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000003/messages?limit=0.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages?limit=0`
- Mutation used: Pagination limit: 0.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-130 — pagination boundary 1

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000003/messages?limit=1.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages?limit=1`
- Mutation used: Pagination limit: 1.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-131 — pagination boundary 99

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000003/messages?limit=99.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages?limit=99`
- Mutation used: Pagination limit: 99.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-132 — pagination boundary 100

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000003/messages?limit=100.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages?limit=100`
- Mutation used: Pagination limit: 100.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-133 — pagination boundary 101

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000003/messages?limit=101.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages?limit=101`
- Mutation used: Pagination limit: 101.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-134 — object id boundary

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/spaces/not-an-id.
- Transport/method: `GET`
- Endpoint: `/api/spaces/not-an-id`
- Mutation used: Malformed or non-existent object identifier.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-135 — object id boundary

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000003/messages/not-an-id/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages/not-an-id/thread`
- Mutation used: Malformed or non-existent object identifier.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-136 — object id boundary

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/handoffs/not-an-id.
- Transport/method: `GET`
- Endpoint: `/api/handoffs/not-an-id`
- Mutation used: Malformed or non-existent object identifier.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-137 — object id boundary

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/spaces/7ec000000000000000000999.
- Transport/method: `GET`
- Endpoint: `/api/spaces/7ec000000000000000000999`
- Mutation used: Malformed or non-existent object identifier.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-138 — handoff toUserId missing

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: toUserId is missing.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-139 — handoff toUserId null

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: toUserId is null.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-140 — handoff toUserId invalid

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: toUserId is invalid.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-141 — handoff shiftDate missing

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: shiftDate is missing.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-142 — handoff shiftDate null

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: shiftDate is null.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-143 — handoff shiftDate invalid

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: shiftDate is invalid.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-144 — handoff shiftType missing

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: shiftType is missing.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-145 — handoff shiftType null

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: shiftType is null.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-146 — handoff shiftType invalid

**Security area:** Input Validation

**Module/context:** Baseline group, space, and handoff security — A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/handoffs.
- Transport/method: `POST`
- Endpoint: `/api/handoffs`
- Mutation used: shiftType is invalid.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-147 — list direct-message conversations

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/dm.
- Transport/method: `GET`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-list-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-148 — read direct-message channel detail

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000009.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009`
- Mutation used: Controlled direct messages authorization/state permutation: direct-participant-access.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-149 — read direct-message member metadata

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000009/members.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/members`
- Mutation used: Controlled direct messages authorization/state permutation: direct-member-metadata-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-150 — read direct-message messages

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000009/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-participant-access.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-151 — send direct-message text

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000009/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-write-participant-access.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-152 — list direct-message conversations

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/dm.
- Transport/method: `GET`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-list-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-153 — read direct-message channel detail

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000009.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009`
- Mutation used: Controlled direct messages authorization/state permutation: direct-participant-access.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-154 — read direct-message member metadata

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000009/members.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/members`
- Mutation used: Controlled direct messages authorization/state permutation: direct-member-metadata-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-155 — read direct-message messages

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000009/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-participant-access.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-156 — send direct-message text

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000009/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-write-participant-access.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-157 — list direct-message conversations

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a GET request to /api/channels/dm.
- Transport/method: `GET`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-list-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-158 — read direct-message channel detail

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a GET request to /api/channels/7ec000000000000000000009.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009`
- Mutation used: Controlled direct messages authorization/state permutation: direct-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-159 — read direct-message member metadata

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a GET request to /api/channels/7ec000000000000000000009/members.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/members`
- Mutation used: Controlled direct messages authorization/state permutation: direct-member-metadata-isolation.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: response exposed a success data payload.
- Semantic check: passed.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-160 — read direct-message messages

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a GET request to /api/channels/7ec000000000000000000009/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-161 — send direct-message text

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a POST request to /api/channels/7ec000000000000000000009/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-write-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-162 — list direct-message conversations

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/channels/dm.
- Transport/method: `GET`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-list-isolation.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-163 — read direct-message channel detail

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/channels/7ec000000000000000000009.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009`
- Mutation used: Controlled direct messages authorization/state permutation: direct-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-164 — read direct-message member metadata

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/channels/7ec000000000000000000009/members.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/members`
- Mutation used: Controlled direct messages authorization/state permutation: direct-member-metadata-isolation.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-165 — read direct-message messages

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/channels/7ec000000000000000000009/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-166 — send direct-message text

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/channels/7ec000000000000000000009/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-write-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-167 — existing DM creation returns the fixed pair

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-idempotence.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-168 — same-institution DM creation is pair-idempotent

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-known-user-idempotence.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-169 — accepted message-request permits DM creation

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User E (unrelated controlled identity)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-accepted-request-binding.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-170 — unrelated identity cannot create a DM

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User E (unrelated controlled identity)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-unrelated-identity.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-171 — self DM is rejected

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User E (unrelated controlled identity)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-self-target.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: passed.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-172 — inactive DM target is not eligible through relationships

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-inactive-target.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-173 — absent DM target is not found

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User E (unrelated controlled identity)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-absent-target.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-174 — malformed DM target is rejected

**Security area:** Input Validation

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User E (unrelated controlled identity)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-target-schema.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-175 — anonymous DM creation is rejected

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled direct messages authorization/state permutation: direct-anonymous.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-176 — edit direct-message sender ownership

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c`
- Mutation used: Controlled direct messages authorization/state permutation: direct-message-ownership.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-177 — edit direct-message sender ownership

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c`
- Mutation used: Controlled direct messages authorization/state permutation: direct-message-ownership.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-178 — edit direct-message sender ownership

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a PUT request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c`
- Mutation used: Controlled direct messages authorization/state permutation: direct-message-ownership.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-179 — edit direct-message sender ownership

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c`
- Mutation used: Controlled direct messages authorization/state permutation: direct-message-ownership.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-180 — delete direct-message sender ownership

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000d.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000d`
- Mutation used: Controlled direct messages authorization/state permutation: direct-message-ownership.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-181 — delete direct-message sender ownership

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000d.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000d`
- Mutation used: Controlled direct messages authorization/state permutation: direct-message-ownership.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-182 — delete direct-message sender ownership

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a DELETE request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000d.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000d`
- Mutation used: Controlled direct messages authorization/state permutation: direct-message-ownership.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-183 — delete direct-message sender ownership

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000d.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000d`
- Mutation used: Controlled direct messages authorization/state permutation: direct-message-ownership.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-184 — read direct-message thread

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/thread`
- Mutation used: Controlled direct messages authorization/state permutation: direct-thread-participant-access.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-185 — read direct-message thread

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/thread`
- Mutation used: Controlled direct messages authorization/state permutation: direct-thread-participant-access.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-186 — read direct-message thread

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a GET request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/thread`
- Mutation used: Controlled direct messages authorization/state permutation: direct-thread-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-187 — read direct-message thread

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/thread`
- Mutation used: Controlled direct messages authorization/state permutation: direct-thread-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-188 — reply to direct-message thread as participant

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/reply.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/reply`
- Mutation used: Controlled direct messages authorization/state permutation: direct-thread-participant-access.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-189 — outsider cannot reply to direct-message thread

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a POST request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/reply.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000c/reply`
- Mutation used: Controlled direct messages authorization/state permutation: direct-thread-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-190 — foreign direct-message ID thread

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/thread`
- Mutation used: Controlled direct messages authorization/state permutation: direct-foreign-message-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-191 — foreign direct-message ID edit

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e`
- Mutation used: Controlled direct messages authorization/state permutation: direct-foreign-message-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-192 — foreign direct-message ID delete

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e`
- Mutation used: Controlled direct messages authorization/state permutation: direct-foreign-message-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-193 — foreign direct-message ID reply

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/reply.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/reply`
- Mutation used: Controlled direct messages authorization/state permutation: direct-foreign-message-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-194 — foreign direct-message ID thread

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/thread.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/thread`
- Mutation used: Controlled direct messages authorization/state permutation: direct-foreign-message-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-195 — foreign direct-message ID edit

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e`
- Mutation used: Controlled direct messages authorization/state permutation: direct-foreign-message-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-196 — foreign direct-message ID delete

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e`
- Mutation used: Controlled direct messages authorization/state permutation: direct-foreign-message-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-197 — foreign direct-message ID reply

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/reply.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/reply`
- Mutation used: Controlled direct messages authorization/state permutation: direct-foreign-message-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-198 — DM recipient records a read receipt only in its channel

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000009/messages/read.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/read`
- Mutation used: Controlled direct messages authorization/state permutation: direct-read-receipt-binding.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-199 — DM receipt ignores a foreign message ID

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000009/messages/read.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/read`
- Mutation used: Controlled direct messages authorization/state permutation: direct-read-receipt-foreign-id.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-200 — DM outsider cannot record a receipt

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a POST request to /api/channels/7ec000000000000000000009/messages/read.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/read`
- Mutation used: Controlled direct messages authorization/state permutation: direct-read-receipt-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-201 — anonymous caller cannot record a DM receipt

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- Anonymous caller (unauthenticated)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/channels/7ec000000000000000000009/messages/read.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/messages/read`
- Mutation used: Controlled direct messages authorization/state permutation: direct-read-receipt-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-202 — DM participant can pin its conversation message

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User B (normal space member)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/channels/7ec000000000000000000009/pin/7ec00000000000000000000c.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/pin/7ec00000000000000000000c`
- Mutation used: Controlled direct messages authorization/state permutation: direct-pin-participant-access.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-203 — DM outsider cannot pin a conversation message

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a POST request to /api/channels/7ec000000000000000000009/pin/7ec00000000000000000000c.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/pin/7ec00000000000000000000c`
- Mutation used: Controlled direct messages authorization/state permutation: direct-pin-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-204 — DM participant cannot pin a foreign message

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User A (space owner/admin)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000009/pin/7ec00000000000000000000e.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000009/pin/7ec00000000000000000000e`
- Mutation used: Controlled direct messages authorization/state permutation: direct-pin-foreign-message.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-205 — DM outsider cannot unpin conversation metadata

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User D is a same-institution medical peer but is not a member of that conversation.
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a DELETE request to /api/channels/7ec000000000000000000009/pin/7ec00000000000000000000c.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000009/pin/7ec00000000000000000000c`
- Mutation used: Controlled direct messages authorization/state permutation: direct-pin-participant-access.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-206 — archived DM participant cannot read messages

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User E (unrelated controlled identity)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a GET request to /api/channels/7ec00000000000000000000b/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec00000000000000000000b/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-archived-channel.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-207 — archived DM participant cannot send messages

**Security area:** Direct-message Authorization

**Module/context:** Direct Messages — A and B are direct-message participants; D is a same-institution medical peer but not a participant; E–H are unrelated fixture identities.

**What this test checks:**
Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.

**Test setup:**
- Users A and B are the two members of the controlled direct-message channel.
- User E (unrelated controlled identity)
- Users E–H use different institutions and no shared space for relationship-state checks.

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/channels/7ec00000000000000000000b/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec00000000000000000000b/messages`
- Mutation used: Controlled direct messages authorization/state permutation: direct-archived-channel.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-208 — list received pending requests

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a GET request to /api/message-requests.
- Transport/method: `GET`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-list-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-209 — sender does not receive its own pending request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a GET request to /api/message-requests.
- Transport/method: `GET`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-list-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-210 — unrelated identity cannot list other requests

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User D (same-institution medical peer)

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a GET request to /api/message-requests.
- Transport/method: `GET`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-list-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-211 — anonymous caller cannot list requests

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/message-requests.
- Transport/method: `GET`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-anonymous.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-212 — list sent declined requests

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a GET request to /api/message-requests?direction=sent&status=declined.
- Transport/method: `GET`
- Endpoint: `/api/message-requests?direction=sent&status=declined`
- Mutation used: Controlled message requests authorization/state permutation: message-request-state-filter.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-213 — list accepted request only for its sender

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a GET request to /api/message-requests?direction=sent&status=accepted.
- Transport/method: `GET`
- Endpoint: `/api/message-requests?direction=sent&status=accepted`
- Mutation used: Controlled message requests authorization/state permutation: message-request-state-filter.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-214 — pending count is recipient-scoped

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a GET request to /api/message-requests/pending-count.
- Transport/method: `GET`
- Endpoint: `/api/message-requests/pending-count`
- Mutation used: Controlled message requests authorization/state permutation: message-request-count-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-215 — pending count excludes sent requests

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a GET request to /api/message-requests/pending-count.
- Transport/method: `GET`
- Endpoint: `/api/message-requests/pending-count`
- Mutation used: Controlled message requests authorization/state permutation: message-request-count-isolation.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-216 — anonymous caller cannot read pending count

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a GET request to /api/message-requests/pending-count.
- Transport/method: `GET`
- Endpoint: `/api/message-requests/pending-count`
- Mutation used: Controlled message requests authorization/state permutation: message-request-anonymous.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-217 — reject message request to self

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-self-target.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-218 — known same-institution user needs no message request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-known-user.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-219 — pending request is idempotent for the sender

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-pending-replay.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-220 — reciprocal pending request exposes accept-incoming only to sender

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-reciprocal-pending.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-221 — declined relationship can create a fresh request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-declined-transition.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-222 — accepted relationship uses DM rather than a new request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-accepted-transition.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-223 — blocked relationship rejects a new request from sender

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-blocked-transition.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-224 — blocked relationship rejects a reciprocal request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User G (unrelated controlled identity)

**Action performed:**
Authenticated as User G (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-blocked-transition.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-225 — inactive request target is not exposed

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-inactive-target.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-226 — absent request target is not exposed

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-absent-target.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-227 — malformed request target is rejected by model/controller

**Security area:** Input Validation

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-target-schema.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-228 — missing request target is rejected

**Security area:** Input Validation

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-target-schema.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-229 — anonymous caller cannot create a request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-anonymous.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-230 — message-request omitted intro validation

**Security area:** Input Validation

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-intro-schema.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-231 — message-request maximum intro validation

**Security area:** Input Validation

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-intro-schema.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-232 — message-request overlong intro validation

**Security area:** Input Validation

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-intro-schema.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-233 — message-request object intro validation

**Security area:** Input Validation

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/message-requests.
- Transport/method: `POST`
- Endpoint: `/api/message-requests`
- Mutation used: Controlled message requests authorization/state permutation: message-request-intro-schema.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-234 — recipient accepts a pending request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/message-requests/7ec00000000000000000000f/accept.
- Transport/method: `POST`
- Endpoint: `/api/message-requests/7ec00000000000000000000f/accept`
- Mutation used: Controlled message requests authorization/state permutation: message-request-recipient-transition.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-235 — sender cannot accept its own pending request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User E (unrelated controlled identity)

**Action performed:**
Authenticated as User E (unrelated controlled identity), sent a POST request to /api/message-requests/7ec00000000000000000000f/accept.
- Transport/method: `POST`
- Endpoint: `/api/message-requests/7ec00000000000000000000f/accept`
- Mutation used: Controlled message requests authorization/state permutation: message-request-recipient-transition.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-236 — outsider cannot accept another request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User D (same-institution medical peer)

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a POST request to /api/message-requests/7ec00000000000000000000f/accept.
- Transport/method: `POST`
- Endpoint: `/api/message-requests/7ec00000000000000000000f/accept`
- Mutation used: Controlled message requests authorization/state permutation: message-request-recipient-transition.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-237 — recipient cannot accept an already accepted request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User H (unrelated controlled identity)

**Action performed:**
Authenticated as User H (unrelated controlled identity), sent a POST request to /api/message-requests/7ec000000000000000000012/accept.
- Transport/method: `POST`
- Endpoint: `/api/message-requests/7ec000000000000000000012/accept`
- Mutation used: Controlled message requests authorization/state permutation: message-request-replay.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-238 — blocked request cannot be accepted

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User G (unrelated controlled identity)

**Action performed:**
Authenticated as User G (unrelated controlled identity), sent a POST request to /api/message-requests/7ec000000000000000000011/accept.
- Transport/method: `POST`
- Endpoint: `/api/message-requests/7ec000000000000000000011/accept`
- Mutation used: Controlled message requests authorization/state permutation: message-request-blocked-transition.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-239 — recipient declines a fresh request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User H (unrelated controlled identity)

**Action performed:**
Authenticated as User H (unrelated controlled identity), sent a POST request to /api/message-requests/6ab77d300e77271fcc6b8c3c/decline.
- Transport/method: `POST`
- Endpoint: `/api/message-requests/6ab77d300e77271fcc6b8c3c/decline`
- Mutation used: Controlled message requests authorization/state permutation: message-request-recipient-transition.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-240 — sender cannot decline its own fresh request

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/message-requests/6ab77d300e77271fcc6b8c3e/decline.
- Transport/method: `POST`
- Endpoint: `/api/message-requests/6ab77d300e77271fcc6b8c3e/decline`
- Mutation used: Controlled message requests authorization/state permutation: message-request-recipient-transition.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-241 — decline replay is rejected

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User H (unrelated controlled identity)

**Action performed:**
Authenticated as User H (unrelated controlled identity), sent a POST request to /api/message-requests/6ab77d310e77271fcc6b8c40/decline.
- Transport/method: `POST`
- Endpoint: `/api/message-requests/6ab77d310e77271fcc6b8c40/decline`
- Mutation used: Controlled message requests authorization/state permutation: message-request-replay.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-242 — accepted request enables the new DM pair

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled message requests authorization/state permutation: message-request-accepted-DM-binding.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-243 — declined request does not enable a DM

**Security area:** Message-request Authorization

**Module/context:** Message Requests — E–H are controlled identities with different institutions and no shared space. Pending E→F, declined E→G, blocked F→G, and accepted E→H model each relationship state.

**What this test checks:**
Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.

**Test setup:**
- Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.
- The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.
- User F (unrelated controlled identity)

**Action performed:**
Authenticated as User F (unrelated controlled identity), sent a POST request to /api/channels/dm.
- Transport/method: `POST`
- Endpoint: `/api/channels/dm`
- Mutation used: Controlled message requests authorization/state permutation: message-request-declined-DM-binding.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-244 — channel update admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/channels/7ec000000000000000000003.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-245 — channel archive admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/channels/7ec000000000000000000003.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-246 — channel creation membership and ownership

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/spaces/7ec000000000000000000001/channels.
- Transport/method: `POST`
- Endpoint: `/api/spaces/7ec000000000000000000001/channels`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-247 — channel update admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/channels/7ec000000000000000000003.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-248 — channel archive admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/channels/7ec000000000000000000003.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-249 — channel creation membership and ownership

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/spaces/7ec000000000000000000001/channels.
- Transport/method: `POST`
- Endpoint: `/api/spaces/7ec000000000000000000001/channels`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-250 — channel update admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a PUT request to /api/channels/7ec000000000000000000003.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-251 — channel archive admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a DELETE request to /api/channels/7ec000000000000000000003.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-252 — channel creation membership and ownership

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a POST request to /api/spaces/7ec000000000000000000001/channels.
- Transport/method: `POST`
- Endpoint: `/api/spaces/7ec000000000000000000001/channels`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-253 — channel update admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/channels/7ec000000000000000000003.
- Transport/method: `PUT`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-254 — channel archive admin boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/channels/7ec000000000000000000003.
- Transport/method: `DELETE`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-255 — channel creation membership and ownership

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/spaces/7ec000000000000000000001/channels.
- Transport/method: `POST`
- Endpoint: `/api/spaces/7ec000000000000000000001/channels`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-256 — search message isolation public group

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/search?q=SearchCanary&type=messages.
- Transport/method: `GET`
- Endpoint: `/api/search?q=SearchCanary&type=messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"canaryDisclosed":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-257 — search message isolation public group

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/search?q=SearchCanary&type=messages.
- Transport/method: `GET`
- Endpoint: `/api/search?q=SearchCanary&type=messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"canaryDisclosed":false}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-258 — search message isolation private group

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/search?q=SearchCanary&type=messages.
- Transport/method: `GET`
- Endpoint: `/api/search?q=SearchCanary&type=messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"canaryDisclosed":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-259 — search message isolation private group

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/search?q=SearchCanary&type=messages.
- Transport/method: `GET`
- Endpoint: `/api/search?q=SearchCanary&type=messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"canaryDisclosed":false}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-260 — search message isolation foreign DM

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User D (same-institution medical peer)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a GET request to /api/search?q=SearchCanary&type=messages.
- Transport/method: `GET`
- Endpoint: `/api/search?q=SearchCanary&type=messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"canaryDisclosed":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-261 — search message isolation foreign DM

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/search?q=SearchCanary&type=messages.
- Transport/method: `GET`
- Endpoint: `/api/search?q=SearchCanary&type=messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"canaryDisclosed":false}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-262 — search message isolation foreign space

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/search?q=SearchCanary&type=messages.
- Transport/method: `GET`
- Endpoint: `/api/search?q=SearchCanary&type=messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"canaryDisclosed":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-263 — search message isolation foreign space

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/search?q=SearchCanary&type=messages.
- Transport/method: `GET`
- Endpoint: `/api/search?q=SearchCanary&type=messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"canaryDisclosed":false}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-264 — handoff draft inbox privacy ?type=sent

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/handoffs?type=sent.
- Transport/method: `GET`
- Endpoint: `/api/handoffs?type=sent`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"draftDisclosed":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-265 — handoff draft inbox privacy ?type=received

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/handoffs?type=received.
- Transport/method: `GET`
- Endpoint: `/api/handoffs?type=received`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"draftDisclosed":false}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-266 — handoff draft inbox privacy 

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a GET request to /api/handoffs.
- Transport/method: `GET`
- Endpoint: `/api/handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"draftDisclosed":false}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-267 — handoff draft inbox privacy ?type=received&status=draft

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/handoffs?type=received&status=draft.
- Transport/method: `GET`
- Endpoint: `/api/handoffs?type=received&status=draft`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"draftDisclosed":true}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-268 — handoff draft direct receiver privacy

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `GET`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: response exposed a success data payload.
- Semantic check: passed.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-269 — search draft handoff privacy

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/search?q=DraftCanary&type=handoffs.
- Transport/method: `GET`
- Endpoint: `/api/search?q=DraftCanary&type=handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"draftDisclosed":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-270 — search draft handoff privacy

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/search?q=DraftCanary&type=handoffs.
- Transport/method: `GET`
- Endpoint: `/api/search?q=DraftCanary&type=handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"draftDisclosed":true}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-271 — search draft handoff privacy

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.

**Test setup:**
- User D (same-institution medical peer)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User D (same-institution medical peer), sent a GET request to /api/search?q=DraftCanary&type=handoffs.
- Transport/method: `GET`
- Endpoint: `/api/search?q=DraftCanary&type=handoffs`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"draftDisclosed":true}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-272 — private group excluded member read 

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000003.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: response exposed a success data payload.
- Semantic check: passed.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-273 — private group excluded member read /members

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000003/members.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/members`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: response exposed a success data payload.
- Semantic check: passed.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-274 — private group excluded member read /messages

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User B (normal space member), sent a GET request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `GET`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-275 — direct body foreign thread binding 7ec000000000000000000007

**Security area:** Resource Isolation / IDOR

**Module/context:** Cross-module — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks whether the API rejects a valid identifier when it belongs to a different controlled resource or identity context.

**Test setup:**
- User A owns the controlled space.
- The referenced field is replaced with a valid controlled value from another identity or space context.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 or 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"foreignBindingPersisted":true,"foreignParentReplyCount":1}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-276 — direct body foreign thread binding 7ec00000000000000000000e

**Security area:** Resource Isolation / IDOR

**Module/context:** Cross-module — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks whether the API rejects a valid identifier when it belongs to a different controlled resource or identity context.

**Test setup:**
- User A owns the controlled space.
- The referenced field is replaced with a valid controlled value from another identity or space context.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 or 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"foreignBindingPersisted":true,"foreignParentReplyCount":1}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-277 — REST authentication expired

**Security area:** Authentication

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-278 — REST authentication wrong-key

**Security area:** Authentication

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-279 — REST authentication inactive

**Security area:** Authentication

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-280 — REST authentication refresh

**Security area:** Authentication

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.

**Test setup:**
- No valid authenticated identity is supplied.

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/users/me.
- Transport/method: `GET`
- Endpoint: `/api/users/me`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-281 — notification read recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/notifications/6ab77d491827ac48254372b6/read.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/6ab77d491827ac48254372b6/read`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-282 — notification read recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/notifications/6ab77d4a1827ac48254372cb/read.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/6ab77d4a1827ac48254372cb/read`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-283 — notification read recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/notifications/6ab77d4a1827ac48254372e0/read.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/6ab77d4a1827ac48254372e0/read`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-284 — notification unread recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/notifications/6ab77d4b1827ac48254372f5/unread.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/6ab77d4b1827ac48254372f5/unread`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-285 — notification unread recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/notifications/6ab77d4b1827ac482543730a/unread.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/6ab77d4b1827ac482543730a/unread`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-286 — notification unread recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/notifications/6ab77d4c1827ac482543731f/unread.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/6ab77d4c1827ac482543731f/unread`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-287 — notification delete recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/notifications/6ab77d4d1827ac4825437334.
- Transport/method: `DELETE`
- Endpoint: `/api/notifications/6ab77d4d1827ac4825437334`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-288 — notification delete recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/notifications/6ab77d4d1827ac4825437349.
- Transport/method: `DELETE`
- Endpoint: `/api/notifications/6ab77d4d1827ac4825437349`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-289 — notification delete recipient boundary

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/notifications/6ab77d4e1827ac482543735e.
- Transport/method: `DELETE`
- Endpoint: `/api/notifications/6ab77d4e1827ac482543735e`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-290 — notification inbox scoped to recipient

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/notifications.
- Transport/method: `GET`
- Endpoint: `/api/notifications`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-291 — notification count scoped to recipient

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a GET request to /api/notifications/unread-count.
- Transport/method: `GET`
- Endpoint: `/api/notifications/unread-count`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-292 — notification bulk recipient binding /api/notifications/read-all

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/notifications/read-all.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/read-all`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-293 — notification bulk recipient binding /api/notifications/read-by-channel/7ec000000000000000000003

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/notifications/read-by-channel/7ec000000000000000000003.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/read-by-channel/7ec000000000000000000003`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-294 — notification bulk recipient binding /api/notifications/read-by-channel/7ec000000000000000000004

**Security area:** Authorization / Ownership

**Module/context:** Extended API — Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/notifications/read-by-channel/7ec000000000000000000004.
- Transport/method: `PUT`
- Endpoint: `/api/notifications/read-by-channel/7ec000000000000000000004`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-295 — local upload context message

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-296 — local upload context avatar

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-297 — local upload context handoff

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-298 — local upload context unknown

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-299 — upload rejects anonymous

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":0,"uploadStatus":401}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-300 — upload rejects missing file

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":0,"uploadStatus":400}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-301 — upload rejects wrong field

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 500
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":0,"uploadStatus":500}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-302 — upload rejects multiple files

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 500
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":0,"uploadStatus":500}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-303 — upload rejects forbidden MIME

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 500
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":0,"uploadStatus":500}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-304 — upload rejects octet forbidden suffix

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 500
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":0,"uploadStatus":500}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-305 — upload rejects oversized

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":0,"uploadStatus":400}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-306 — upload rejects empty bytes

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-307 — upload rejects inert MIME extension mismatch

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-308 — media deletion ownership A

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410073692-45b63c23e977.png.
- Transport/method: `DELETE`
- Endpoint: `/api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410073692-45b63c23e977.png`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-309 — media deletion ownership B

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)

**Action performed:**
Authenticated as User B (normal space member), sent a DELETE request to /api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410074295-c34771b9facb.png.
- Transport/method: `DELETE`
- Endpoint: `/api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410074295-c34771b9facb.png`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-310 — media deletion ownership C

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)

**Action performed:**
Authenticated as User C (authenticated outsider), sent a DELETE request to /api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410074890-1affe2b90db7.png.
- Transport/method: `DELETE`
- Endpoint: `/api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410074890-1affe2b90db7.png`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-311 — media deletion ownership anonymous

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)

**Action performed:**
Without a valid Authorization header, sent a DELETE request to /api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410075487-85090e032082.png.
- Transport/method: `DELETE`
- Endpoint: `/api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410075487-85090e032082.png`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-312 — media deletion replay

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410076081-8b01b7f6d4e5.png.
- Transport/method: `DELETE`
- Endpoint: `/api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410076081-8b01b7f6d4e5.png`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 404
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-313 — media canonical owner containment single

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F..%2F6ab77ca013d6c93b9e7bb2c7%2F1790410076686-788b18935d29.png.
- Transport/method: `DELETE`
- Endpoint: `/api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F..%2F6ab77ca013d6c93b9e7bb2c7%2F1790410076686-788b18935d29.png`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 or 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200,"foreignFileSurvived":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-314 — media canonical owner containment double

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/media/medcollab%252Fmessages%252F6ab77ca013d6c93b9e7bb2b8%252F..%252F6ab77ca013d6c93b9e7bb2c7%252F1790410077286-d09ab2f3b897.png.
- Transport/method: `DELETE`
- Endpoint: `/api/media/medcollab%252Fmessages%252F6ab77ca013d6c93b9e7bb2b8%252F..%252F6ab77ca013d6c93b9e7bb2c7%252F1790410077286-d09ab2f3b897.png`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 or 403 or 404 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: response exposed a success data payload.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200,"foreignFileSurvived":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-315 — anonymous static media and owner revocation

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a DELETE request to /api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410077884-e19b2cf08471.png.
- Transport/method: `DELETE`
- Endpoint: `/api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F1790410077884-e19b2cf08471.png`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200,"publicStaticControl":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-316 — message media URL trusted HTTPS

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 201
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-317 — message media URL foreign host

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-318 — message media URL host suffix lookalike

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-319 — message media URL invalid URL

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-320 — message media URL protocol relative

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-321 — message media URL FTP trusted host

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-322 — message media URL HTTP trusted host

**Security area:** Input Validation

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 400 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-323 — local upload to authorized message integration

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000003/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000003/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 201 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 400
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-324 — uploaded media does not grant foreign channel access 7ec000000000000000000004

**Security area:** Authorization / Ownership

**Module/context:** Cross-module — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec000000000000000000004/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec000000000000000000004/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-325 — uploaded media does not grant foreign channel access 7ec00000000000000000000a

**Security area:** Authorization / Ownership

**Module/context:** Cross-module — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Authenticated as User A (space owner/admin), sent a POST request to /api/channels/7ec00000000000000000000a/messages.
- Transport/method: `POST`
- Endpoint: `/api/channels/7ec00000000000000000000a/messages`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-326 — handoff attachment sender ownership A

**Security area:** Authorization / Ownership

**Module/context:** Cross-module — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User A (space owner/admin)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User A (space owner/admin), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-327 — handoff attachment sender ownership B

**Security area:** Authorization / Ownership

**Module/context:** Cross-module — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User B (normal space member)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User B (normal space member), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-328 — handoff attachment sender ownership C

**Security area:** Authorization / Ownership

**Module/context:** Cross-module — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Authenticated as User C (authenticated outsider), sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 403 under the endpoint’s current security contract and must not change the controlled state.

**Actual result:**
- HTTP status: 403
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-329 — handoff attachment sender ownership anonymous

**Security area:** Authorization / Ownership

**Module/context:** Cross-module — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- Anonymous caller (unauthenticated)
- The controlled handoff was sent from User A to User B in the controlled space.

**Action performed:**
Without a valid Authorization header, sent a PUT request to /api/handoffs/7ec000000000000000000008.
- Transport/method: `PUT`
- Endpoint: `/api/handoffs/7ec000000000000000000008`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should reject the request with HTTP 401 because no valid authenticated session is presented.

**Actual result:**
- HTTP status: 401
- Request succeeded: no
- State check: controlled database/application state remained unchanged.
- Rejection payload check: no success data returned.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-330 — local PDF bytes retained application/pdf

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)

**Action performed:**
Authenticated as User C (authenticated outsider), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-331 — local PDF bytes retained application/octet-stream

**Security area:** Authorization / Ownership

**Module/context:** Media — Real local multipart upload and filesystem; no external media URL is fetched.

**What this test checks:**
Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.

**Test setup:**
- User C (authenticated outsider)

**Action performed:**
Authenticated as User C (authenticated outsider), sent a POST request to /api/media/upload.
- Transport/method: `POST`
- Endpoint: `/api/media/upload`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The API should return HTTP 200 for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.

**Actual result:**
- HTTP status: 200
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"filesAdded":1,"uploadStatus":200}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-332 — socket authentication missing

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket authentication missing. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"rejected":true,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-333 — socket authentication malformed

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket authentication malformed. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"rejected":true,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-334 — socket authentication expired

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket authentication expired. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"rejected":true,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-335 — socket authentication wrong-key

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket authentication wrong-key. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"rejected":true,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-336 — socket authentication inactive

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket authentication inactive. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"rejected":true,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-337 — socket handshake identity forgery

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket handshake identity forgery. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-338 — socket denied join prevents channel edit delivery foreign space

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket denied join prevents channel edit delivery foreign space. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":0,"authorizedControl":true,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-339 — socket unauthorized typing_start foreign space

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket unauthorized typing_start foreign space. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":1,"serverAttributedAttacker":true,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-340 — socket unauthorized typing_stop foreign space

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: socket unauthorized typing_stop foreign space. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":1,"serverAttributedAttacker":true,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-341 — socket denied join prevents channel edit delivery foreign DM

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User C is not a member of that space.

**Action performed:**
Executed actual Socket.IO scenario: socket denied join prevents channel edit delivery foreign DM. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":0,"authorizedControl":true,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-342 — socket unauthorized typing_start foreign DM

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User C (authenticated outsider)

**Action performed:**
Executed actual Socket.IO scenario: socket unauthorized typing_start foreign DM. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":2,"serverAttributedAttacker":true,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-343 — socket unauthorized typing_stop foreign DM

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User C (authenticated outsider)

**Action performed:**
Executed actual Socket.IO scenario: socket unauthorized typing_stop foreign DM. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state remained unchanged.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":2,"serverAttributedAttacker":true,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-344 — socket denied join prevents channel edit delivery private group

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Executed actual Socket.IO scenario: socket denied join prevents channel edit delivery private group. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":0,"authorizedControl":true,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-345 — socket unauthorized typing_start private group

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User B (normal space member)

**Action performed:**
Executed actual Socket.IO scenario: socket unauthorized typing_start private group. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":2,"serverAttributedAttacker":true,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-346 — socket unauthorized typing_stop private group

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User B (normal space member)

**Action performed:**
Executed actual Socket.IO scenario: socket unauthorized typing_stop private group. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":2,"serverAttributedAttacker":true,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-347 — private REST message personal-room audience

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User B (normal space member)
- The target message is in the controlled A/B channel.

**Action performed:**
Executed actual Socket.IO scenario: private REST message personal-room audience. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":1,"fullCanaryDisclosed":true,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-348 — membership revocation stale channel room before sync

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Executed actual Socket.IO scenario: membership revocation stale channel room before sync. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":1,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-349 — membership revocation stale channel room after sync

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User B (normal space member)

**Action performed:**
Executed actual Socket.IO scenario: membership revocation stale channel room after sync. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: did not pass.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"unauthorizedEvents":1,"authorizedControl":true,"invariantHeld":false}`.

**Result:** OBSERVATION

**Why this result matters:**
The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.

**Potential security impact:**
If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.

**Recommended follow-up:**
Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.

### VOCLE-350 — explicit leave removes channel-only delivery

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: explicit leave removes channel-only delivery. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"eventsAfterLeave":0,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-351 — server event injection cannot relay or persist messages

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A (space owner/admin)
- The target message is in the controlled A/B channel.

**Action performed:**
Executed actual Socket.IO scenario: server event injection cannot relay or persist messages. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"injectedEvents":0,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.

### VOCLE-352 — fresh reconnect rechecks revoked membership

**Security area:** Authorization

**Module/context:** Realtime — Actual websocket clients, real REST producers, authenticated controls; 1500 ms quiet window.

**What this test checks:**
Checks actual realtime authentication, room authorization or recipient isolation using socket clients and controlled REST producers. Missing delivery controls fail the infrastructure prerequisite.

**Test setup:**
- User A owns the controlled space.
- User B is a normal member of that space.
- User A (space owner/admin)

**Action performed:**
Executed actual Socket.IO scenario: fresh reconnect rechecks revoked membership. See sanitized event evidence in results.json.
- Transport/method: `SOCKET`
- Endpoint: `/socket.io/`
- Mutation used: None; this is a baseline authorization or ownership request.

**Expected security behaviour:**
The named realtime invariant must hold with an authenticated delivery control; backend health is checked separately. No HTTP status is assigned to a socket event.

**Actual result:**
- Separate backend health status: 200; socket events have no HTTP response status.
- Request succeeded: yes
- State check: controlled database/application state changed.
- Rejection payload check: not applicable.
- Semantic check: passed.
- Sanitized scenario evidence: `{"quietWindowMs":1500,"eventsAfterReconnect":0,"invariantHeld":true}`.

**Result:** PASS

**Why this result matters:**
The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.
