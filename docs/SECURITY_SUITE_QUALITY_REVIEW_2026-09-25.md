# Automated security-suite quality review — 2026-09-25

Scope: the existing 243-case HTTP security suite, deterministic fixtures, runner, generated reports and successful CI artifact from run 36168079327. No application behavior, Media tests, Socket.IO tests or additional API cases were added. Case count remains 243.

## Findings and disposition

| Classification | Weakness | Disposition |
| --- | --- | --- |
| TEST DEFECT | Post-response `setImmediate` message/handoff side effects could still be running when the next case deleted and recreated fixed IDs. This could mutate the next fixture or make an immediate snapshot miss delayed state. | Runner now waits for tracked state to remain stable across an observation window after reset and after each request. |
| TEST DEFECT | Notification documents were excluded from cleanup and snapshots. They accumulated between cases, and a denied operation that only produced a notification would look state-preserving. | Notification state for fixture users/actors/references is reset, checked for an exact zero baseline and included in before/after snapshots. |
| TEST DEFECT | Space creation used generated IDs, but reset, snapshots and baseline verification tracked only the two fixed space IDs. The created space and its channels leaked into later cases, making the two space-list checks order dependent. | Reset now discovers every space created by a fixture identity, removes its related resources before rebuilding the baseline, includes generated fixture spaces in snapshots and counts all fixture-owned spaces in the exact baseline check. |
| TEST DEFECT | Denial cases checked status, `success:false` and selected database state but did not reject a response carrying a `data` payload. An endpoint could disclose protected data while returning an allowed 403/404. | Every expected denial now requires no success `data` payload. JSON and human reports expose this result as `deniedResponseDataAbsent`. |
| TEST DEFECT | Two invalid-content variants shared the same test name, and two auth cases differed only by capitalization. Reports could not reliably distinguish them. | Names now identify null versus array content and the exact auth-header condition. No cases were added or removed. |
| TEST DEFECT | A future failure of the client-controlled message ownership-field test could be auto-labelled as input hardening by the category regex, even though persisted forged ownership would be an authorization defect. | That case has an explicit security-finding failure classification. Existing text/schema coercion cases retain their reviewed hardening classification. |
| TEST HARDENING | Many allowed reads and writes passed on status/envelope alone. A 200/201 without correct persistence, identity or resource relation could pass. | Every currently successful case now has a semantic check. Reads assert exact controlled IDs and containment. Writes assert response identity plus database persistence/deletion/transition. Static audit reports zero successful cases without a semantic check. |
| TEST HARDENING | Replay/idempotency checks sometimes proved only that an old ID was returned. | Existing/pending DM and request checks now assert exact pair/document counts; reciprocal requests assert no reverse duplicate; accept/decline/acknowledge prerequisites assert their persisted state. |
| TEST HARDENING | Foreign-reply and foreign-handoff observations only proved “some tracked state changed.” | If unexpectedly accepted, their semantic checks load the created document and verify both URL parent and referenced child/space/user relationship. Legitimate observations remain observations. |
| TEST HARDENING | Reset correctness was assumed after writes completed. | Each case now verifies exact broad counts for spaces, channels, messages, handoffs and requests plus zero fixture notifications, catching leftovers beyond fixed IDs. |
| NO ACTION | Foreign-resource cases allow 403/404, and handoff reference cases allow 400/403/404. | These encode the security invariant “reject without mutation or protected data,” not a public status-code contract. Exact anti-enumeration behavior needs a product policy before narrowing. |
| NO ACTION | Owner/member and symmetric DM cases look repetitive. | They exercise materially different privilege or sender identities. No true duplicate manifest identities remain after naming corrections. |
| NO ACTION | The four text-coercion observations remain validation/hardening rather than vulnerabilities. | The artifact demonstrates coercion and persistence, not authorization bypass or unsafe interpretation. Classification is preserved explicitly. |
| COVERAGE GAP | Some endpoint families lack every useful identity permutation: e.g. a second unrelated DM outsider, anonymous accept/decline, and a third-party decline attempt. | Leave for the next API-coverage phase; adding them here would expand scope/count rather than repair existing tests. |
| COVERAGE GAP | Snapshots still do not observe Socket.IO delivery, FCM delivery, client rendering or hosted external services. | Media and realtime manifests already define those future phases. No mocks or additional cases were introduced here. |
| COVERAGE GAP | Message-request success does not guarantee its intended notification was created; source review shows notification persistence is independently fallible. | Keep distinct from request authorization. Cover notifications in their own phase and do not silently turn request success into notification evidence. |
| COVERAGE GAP | Concurrency, token expiry/revocation, error-message enumeration policy and complete response-field minimization remain outside this 243-case run. | Preserve for later focused work; current broad status acceptance is not evidence for these properties. |

## Validation

- JavaScript syntax checks passed for the runner and both modular suites.
- Manifest generation passed at exactly 243 cases.
- Static manifest audit: zero successful cases without semantic checks; zero exact duplicate manifest identities.
- `git diff --check` passed for the security changes.
- A local real-API execution was unavailable because Docker/MongoDB are not installed on this workstation. The existing Actions workflow is the required practical execution environment.

The pre-change evidence remains run 36168079327: 243 executed, 230 passed and 13 observations. Strengthening assertions does not reclassify that historical artifact.

The first post-change execution, run 36210647832, completed successfully and exposed the generated-space cleanup defect: 243 executed, 228 passed and 15 observations. The two additional observations were the A and B space-list cases whose semantic checks saw the leaked space. That run is retained as evidence that the strengthened assertion detected the order dependency rather than silently passing it. The cleanup correction requires a second post-change execution for the final totals.
