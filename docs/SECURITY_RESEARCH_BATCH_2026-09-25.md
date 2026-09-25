# Security research batch — 2026-09-25

Source reviewed: `a0b1f722160b0a8df94780d10ebc3c1dca46d45a`. Application fixes are outside this batch. Historical findings and rejection assertions remain unchanged.

## Execution evidence and classification

[Successful backend run 36168079327](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/36168079327), created 2026-09-25T17:35:25Z, ran the current source on master. Artifact 10879465186 was downloaded and inspected; archive digest `bba66a8e6621f20b0edc777ba42d2617d923911c12de1fac1d90617cfa00bf25`. The preserved [results.json](security-evidence/36168079327/results.json) SHA-256 is `71f82996e27152cac7c0d68e10e62cdcc741d7bfe096f0ec4585b86f1ed3b9fc`. All four generated reports were inspected. This session reviewed that execution; it did not rerun the backend.

| Module | Executed | Passed | Observations |
| --- | ---: | ---: | ---: |
| Baseline | 146 | 139 | 7 |
| Direct Messages | 61 | 56 | 5 |
| Message Requests | 36 | 35 | 1 |
| Total | 243 | 230 | 13 |

Infrastructure healthy. Workflow success means the runner completed, not that every security invariant passed. The earlier run 36167635281 failed before the inactive target fixture loading correction; it is superseded for execution completeness, not erased as history.

| Cases | Evidence | Reviewed interpretation |
| --- | --- | --- |
| 094, 098 | foreign group replies: 201, success, tracked state changed | CONFIRMED existing parent/channel binding defect |
| 099 | foreign handoff channel: 201, tracked state changed | CONFIRMED existing space/channel reference integrity defect |
| 109, 110, 111, 112 | number/object text create/edit accepted, 201/200 | Validation/hardening; same sanitizer coercion behavior, no demonstrated privilege bypass |
| 159 | nonparticipant D reads AB DM members: 200, success | CONFIRMED new missing member-list authorization; disclosure fields inferred from controller, not captured response body |
| 168, 169, 242 | permitted fresh DM creation: 500, success=false, semantic check false, tracked state unchanged | Unresolved functional/robustness observations; no authorization bypass established |
| 193, 197 | foreign DM root replies: 201, success, tracked state changed | CONFIRMED extension of 094/098; same root cause, not two new vulnerabilities |

There are six security-defect observations representing **three distinct confirmed roots**, four hardening observations and three unresolved errors. None of the current 13 is established as expected behavior. Corrected 137 now actually passes: valid absent ObjectId yields 404 with state unchanged. The historical malformed 25-character input correctly yielded 400; that was a test defect, not a vulnerability.

### New DM finding and limits

`channel.routes.js` applies protect, requireOnboarding and MongoId syntax validation to GET `/api/channels/:id/members`. `getChannelMembers` loads the channel and queries its member IDs without testing caller membership. D is a same-institution peer, not an AB participant. Case 159 proves successful access to the protected operation; source identifies the returned selection as name, displayTitle, role, speciality, avatarUrl and availability (plus default user ID). The artifact stores envelope/status, not returned member values; do not claim a measured field-by-field leak. Follow-up should assert exact controlled member identities and minimize stored evidence. Anonymous denial and participant positive cases passed. This is distinct from the reply defect.

Cases 193/197 use `replyToThread -> sendMessage`, which checks the URL DM but accepts the foreign root ID. As with group replies, the response and state-change evidence confirm an invalid relationship; completed asynchronous root changes or victim-visible thread contamination still need explicit observation.

Fresh DM failures all converge on `createOrGetDM` and its MongoDB upsert using a members `$all`/`$size` filter and `$setOnInsert`. This is a shared investigation target, **not a proven error cause**. Existing-pair case passes. Raw errors were not preserved in results, and the successful job's diagnostics step does not publish the backend log. Next isolated run should capture a sanitized error class/code and stage for only these three cases. Do not repair the app, relax expectations, or interpret a 500 as protection. Acceptance-to-DM positive binding remains unproven; recipient transitions and declined-to-DM denial have independent passing evidence.

## Cross-module attack paths

Every path below requires a controlled identifier source. Fixture-known foreign IDs demonstrate containment failures, not practical enumeration.

| Confidence | Path / source evidence | Required next proof |
| --- | --- | --- |
| CONFIRMED at reference acceptance only | permitted group/DM URL + controlled foreign message ID -> accepted reply (094/098/193/197) | Observe foreign root counters, victim GET thread, notification recipients and socket fan-out after async completion; test direct body threadId too |
| CONFIRMED at reference acceptance only | A's space + B recipient + foreign channel -> handoff draft (099) | Follow submit/detail/navigation; unused postHandoffSystemMessage helper is not evidence of foreign-channel delivery |
| CONFIRMED operation access; chain HYPOTHESIS | known DM ID -> nonparticipant member endpoint -> user IDs/avatar URLs -> profile/media operations | Assert minimal member data then independently test downstream authorization; no proven source of arbitrary DM IDs |
| STRONGLY SUSPECTED | private channel message REST send -> recipientIds includes every space member -> user-room new_message fallback | Subscribe excluded ordinary member's personal socket, send unique private canary, compare REST denial; includes potentially sensitive full message content |
| STRONGLY SUSPECTED | membership removal/leave -> sync only joins current space rooms, never leaves old rooms; channel joins have no later recheck | Removed user's established socket must receive no later space/channel canary; test before and after sync/recovery |
| STRONGLY SUSPECTED | known foreign channel/DM ID -> typing_start/stop -> socket.to(room) without canAccessChannel | Victim observes attacker-attributed typing despite failed join; identity is server-derived, so this is room authorization, not user impersonation |
| STRONGLY SUSPECTED | own media path substring + encoded traversal -> deleteLocalUpload path.join without containment | Only disposable sentinel files under a dedicated scratch root; prove foreign file survival/deletion, never target repository/config files |
| HYPOTHESIS / REQUIRES TESTING | shared/public media URL -> another conversation or handoff attachment -> unauthorized content exposure | Establish intended public/share policy, ownership and actual recipient access; URL reuse alone is not a vulnerability |
| HYPOTHESIS / REQUIRES TESTING | accepted request -> new DM -> media/realtime | 500s currently block positive end-to-end API-created pair; use explicitly seeded DM only for independent tests and disclose setup |
| HYPOTHESIS / REQUIRES TESTING | handoff draft -> received inbox status override/search -> attachment URL | GET inbox with type=received&status=draft and search with controlled canary; draft visibility policy needs confirmation |

## Prioritized execution roadmap

All phases use the existing **vocle-backend-environment-test.yml** with real loopback Express and Docker MongoDB 7/vocle_ci, NODE_ENV=test, sequential reset, synthetic identities and no external credentials. The similarly named security-environment workflow is only a tools smoke test. Preserve the 243-case discovery suite and its observations. No application remediation belongs in these phases.

| Order | Objective / scope | Fixtures and prerequisites | Invariant, observation and non-finding criteria |
| --- | --- | --- | --- |
| 0 | Evidence quality: 159 member assertions; 168/169/242 sanitized failure diagnosis; settled 094/193 effects | Existing A–I; private controlled error capture; bounded DB polling; no raw logs/tokens | Preserve existing observations. A diagnostic class or 500 alone is not exploit evidence. Resolve positive DM prerequisites before claiming creation coverage |
| 1 | Realtime privacy/authorization: private fan-out, typing, stale rooms | Add private channel, nonmember within same space, separate admin; socket.io-client matching server; event collectors | Excluded users never receive canary payloads; full recipe in realtime manifest. Legitimate participant delivery/duplicates alone are not access bypass |
| 2 | Local media upload/delete and URL-to-resource binding | Small PNG/PDF and inert MIME mismatch fixtures; uploader A/B/C, unonboarded/inactive users; scratch file tree | Auth and canonical ownership enforced; follow media manifest. Public-by-policy URL and reuse by owner are not findings |
| 3 | Confirm cross-module impacts | A/B general + separate C space + independent E/F DM; unique root/attachment canaries; notification/user snapshots | Accepted foreign relation must not mutate victim state or disclose across contexts. Do not turn source-derived impact into confirmed execution |
| 4 | Remaining high-value REST privacy | GET /api/search; all notification routes; GET /api/handoffs; channel CRUD/private pins; users lookup/profile; membership leave/invites | Separate owner/admin/member/outsider and draft/submitted/deactivated fixtures | Enforce per-resource audience, recipient-only notification writes, stale membership revocation. Discoverability and admin audit policy need explicit scope |
| 5 | Session/abuse/environment boundaries | Auth five routes, dev tools three routes, support routes; expired/wrong-key/deleted identities; isolated production-like limiter configuration | No real OTP/MSG91/FCM delivery. Test-mode limiter skips cannot establish production throttling; logout FCM removal alone does not promise token revocation |

Prerequisites are execution blockers for that phase only. Continue independent phases. Cloudinary live execution is intentionally deferred: current rules prohibit security traffic to external services. Cloudinary SDK behavior, hosted deletion and CDN access remain UNKNOWN until a separately authorized disposable account/environment is available. No mocks can substitute for that evidence. Broad fuzzing, load tests, production testing and mobile rendering remain deferred.

## Handoff and verification

Read this review, the route map, both manifests and the retained evidence before extending the runner. New tests should record case/module, actor labels, route/event, expected invariant, sanitized actual result, canonical resource relations, and positive-control completion. Quiesce async effects before resetting fixtures. For sockets, use bounded observation windows with a successful allowed-recipient control; timeout alone is not proof of denial. Persist observations unchanged even when CI is green.

This batch changes security documentation and retains sanitized evidence only. Local checks are manifest enumeration, artifact arithmetic/hash/unique IDs, route attribution and source syntax; no local mocked or real API run and no new hosted execution were performed. Existing unit files require a Jest-style harness while package.json test is a placeholder; neither is counted as executed API coverage.
