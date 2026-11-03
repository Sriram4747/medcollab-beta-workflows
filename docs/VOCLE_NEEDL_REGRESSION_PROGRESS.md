# Needl functional regression expansion

## Baseline and authorization — 3 November 2026

- Upstream master fetched read-only: `4c01dc24247aa95a73e286a2b42c7f2f81257c7a`. User checkout already matched it, with origin pointing upstream; that checkout/untracked work was preserved.
- Isolated checkout: `vocle-needl-regression`; branch `temp/needl-functional-regression-20261103`; origin is the authorized testing fork. No upstream writes, master pushes or PR creation.
- New AGENTS.md records current source baseline, remote topology, branch authorization and synthetic-only safety rules.

## Audit and implemented scope

Needl group conversations and the older `/users/me/needl` thread inbox were traced separately. Audited backend routes/controllers, `memberPairKey`, `knownUsers`, channel access, message/pin/receipt routes, realtime handlers and the existing conversation/thread suites. Audited Flutter ChannelRepository/ChannelModel, StartDmPage, MessagesHubPage, Needl management sheets, ChannelChatPage, route navigation, presence, drafts and notification badges. Existing FR-DM-01..09, FR-THR-01..05 and retained sanity assertions remain intact.

Added FR-NDL-01..30 backend and FR-NDL-31..54 Flutter cases, with explicit design in the main catalog and `contracts/needl-cases.json`. Coverage includes creation identity, exact/independent membership, aliases, validation, outsider/anonymous access, rename projection, expansion normalization and caps, all/today/none history, copy metadata/deletion state, recipients/persistence, pin/read behavior, restart, concurrency/recovery, real repository serialization, tab isolation, suggestions/search races, selection across creations, add-people lookup/chips/history/retry, rename, members/presence and actual chat/menu rendering.

Catalog: **241 total = original 187 + 54 Needl cases**; B177/F56/D8; hosted233/local-only8; retained sanity48. Original187 rows and IDs frozen by SHA-256/order guard in `contracts/catalog-baseline.json`. Source catalog/registry validator passes. Backend scheduler, full-success checks, Flutter gates, reporting/coverage and tooling fixtures include the expansion. Full-suite success requires all new required cases too.

## Local infrastructure and preliminary execution

- Real Express backend with disposable loopback MongoDB 7.0.14 and existing provider interception; no .env, Atlas, SMS, Firebase or Cloudinary access.
- Global Flutter 3.47.2 cannot satisfy the original lockfile. Installed isolated Flutter3.29.3 (runtime-lock commit ea121f8) and resolved the unchanged lockfile successfully; no application dependency upgrades.
- Initial backend run: 26 PASS/4 FAIL. One history fixture bypassed schema defaults and used tied timestamps; corrected to supported fields with distinct timestamps. Archived detail assumption corrected after explicit source review. Actual concurrency and history-retry failures retained.
- Flutter harness finder/asynchronous-observation issues corrected; actual stale-search result overwrite, modal navigation-context exception and members-sheet rendering overflow remain failures. Do not modify application code to green these tests.
- Infrastructure contracts: 41/41 PASS. Includes catalog completeness, report normalization/provenance, migration/coverage and developer policies; Windows CRLF handling and sandbox-only Git fixture permissions repaired.
- NDL-D1 remains NEEDS_DECISION; Q1–Q14 founder decisions unchanged.

## Final executed evidence

Tested implementation revision: **4765df8b89912dcb48f377fc184f83041f0decc0**. Application source trees and dependency lockfile Git objects are identical to upstream baseline **4c01dc24247aa95a73e286a2b42c7f2f81257c7a**. Upstream master rechecked unchanged before delivery. Evidence/documentation commits are later than the tested harness and do not relabel the execution revision.

| Scope | Executed | PASS | FAIL | NEEDS_DECISION | ERROR/BLOCKED/SKIP |
| --- | ---: | ---: | ---: | ---: | --- |
| New Needl backend FR-NDL-01..30 | 30 | 27 | 2 | 1 | 0/0/0 |
| New Needl Flutter FR-NDL-31..54 | 24 | 21 | 3 | 0 | 0/0/0 |
| Combined new Needl | 54 | 48 | 5 | 1 | 0/0/0 |
| Full Flutter catalog, including new Needl | 56 | 53 | 3 | 0 | 0/0/0 |
| Existing unchanged backend conversations/threads | 13 | 13 | 0 | 0 | 0/0/0 |
| Infrastructure/reporting contracts | 41 | 41 | 0 | 0 | 0/0/0 |

The scopes overlap: do not add the new Flutter row to the full Flutter row. The 13 related existing backend cases ran at cb8c5fc before the final badge/search strengthening; their source and harness revisions remain in their records. The full 177-backend/241-case catalog was not executed; the 48 retained sanity cases were preserved, not rerun as a complete suite. Android/iOS and real-provider execution are not claimed.

Observed application failures preserved:

- **FR-NDL-28**: concurrent expansion does not return a usable successful response for both intents. The controller's separate find/create path is a likely race location, not an independently proven root cause.
- **FR-NDL-29**: a deliberately interrupted MongoDB history copy leaves a destination that is reused on retry with zero copied messages, although one source message was requested. The fixture removes its temporary unique index before retry; no application source is patched.
- **FR-NDL-39**: an old name-search response replaces the newer result. The test explicitly proves Doctor Z was visible before completing the older response, then verifies it must remain.
- **FR-NDL-50**: successful add-people submission uses the modal context with `GoRouterState.of`, raising “There is no GoRouterState above the current context” instead of opening the returned Needl.
- **FR-NDL-53**: the actual members sheet produces a RenderFlex bottom overflow (91 px at the recorded 1200×1800 logical test surface). Member count, self-first ordering and presence checks execute; rendering failure remains FAIL.

**NDL-D1**: archived conversation detail intentionally permits authorized historical reading. Whether archived Needls may be expanded is unresolved. FR-NDL-10 verifies safe behavior, records HTTP 200 for expansion on this source, and remains NEEDS_DECISION. No founder/developer approval was invented.

All 30 final backend modules confirmed stopped backend/MongoDB and removed runtime directories. No production services or provider delivery were used. The unchanged lockfile was successfully used with Flutter3.29.3; no application source or dependency fixes were made. Windows PowerShell UTF-16 reporter stdout was losslessly converted to UTF-8 before hashing/aggregation. The Node migration contract's CRLF parser and local temporary-Git fixture sandbox permissions were repaired as harness/environment issues.

## Reports and reproducible commands

Committed evidence: `docs/needl-regression-evidence/2026-11-03-4765df8/`. Includes the five existing visual/detailed/JSON/JUnit/summary formats, full Flutter results/provenance, backend module and related-case records, exact input hashes, source-tree/cleanup verification, 41-contract output and offline Chrome dashboard receipt. The dashboard's filters/charts/drill-down and safe offline rendering PASS. Raw Flutter NDJSON and backend logs remain in ignored `test-results/`; their original local paths/checksums are recorded. The checked-in bundle contains sanitized structured evidence rather than provider inboxes or credentials.

Example commands from this checkout (use a compatible Flutter3.29.3 path):

```powershell
node tests/functional-regression/scripts/validate-catalog.mjs
npm.cmd ci --ignore-scripts --prefix medcollab-backend
npm.cmd ci --ignore-scripts --prefix tests/sanity
$env:VOCLE_OUTPUT_DIR = "$PWD/test-results/needl-backend"
node tests/functional-regression/suites/needl.mjs
# From medcollab-app; capture JSON using UTF-8 when invoking in Windows PowerShell:
flutter test --no-pub --reporter json test/functional_regression
# Aggregate the reporter using a runner-owned provenance JSON bound to event checksum and source SHA:
node tests/functional-regression/scripts/aggregate-flutter.mjs EVENTS_NDJSON FLUTTER_REPORT_BASE RUNNER_PROVENANCE_JSON
node tests/functional-regression/scripts/report-needl.mjs BACKEND_OUTPUT_DIR FLUTTER_REPORT_JSON REPORT_DIRECTORY
```

Nonzero exits are expected while the recorded failures/decision remain. No repeat-until-green mutation or weakened assertions are used. CI's existing full backend scheduler now includes NDL and requires 177 backend records; Flutter gates require 56. Full-suite reports declare 241 total / 233 hosted / 8 LOCAL_ONLY and cannot treat this 54-case subset as a full-suite success.

## Delivery and next action

All 54 new cases contain executable assertions, are registered in the existing catalog, and were executed locally. AGENTS.md updated. Implementation commits cb8c5fc and 4765df8 plus the final evidence checkpoint are pushed only to **origin/temp/needl-functional-regression-20261103**. Find the final evidence commit with `git log -1 --format=%H -- docs/VOCLE_NEEDL_REGRESSION_PROGRESS.md`.

The user's original checkout, its branch/remotes and untracked files remain untouched. Both remote master branches remain unchanged; upstream is strictly read-only. No PR, deployment, hosted provider workflow or production operation was performed.

Exact next action: review the temporary branch and the five failures; decide NDL-D1 before implementing an archival-expansion policy. Application fixes and any PR creation require a separate request. Remaining platform limits: component/widget coverage uses controlled repositories/HTTP/socket inputs; backend coverage uses real Express and disposable MongoDB; no new real-device/iOS journey execution. This is broad source-based regression coverage, not a claim of exhaustive input combinations or 241 passing cases.

## Whole-catalog local follow-up — in progress

User requested all 241 cases locally and any additional test fixes on the same temporary branch. Started all177 backend cases (including the retained48), all56 Flutter catalog cases, retained Flutter tests and all8 LOCAL_ONLY Android cases. Isolated Flutter3.29.3 and disposable Mongo7.0.14 remain in use.

Initial Windows sandbox attempt could not launch MongoDB (fassert) and Flutter child compilation stalled; these attempts are environmental evidence, not application verdicts. Host-access reruns resolve these restrictions. The initial host journey run exposed missing synthetic fixture labels J4A/J4B before its behavioral assertions. Added dedicated unique phone fixtures without changing the journey assertions; unknown fixture errors now classify ERROR rather than application FAIL. Two harness contracts verify all literal suite identity references and the ERROR/FAIL distinction.

The device launcher uses a new disposable AVD, a dedicated com.vocle.regression package and PID/serial-scoped cleanup. It does not invoke existing launchers that globally terminate shared Java/Dart/emulator processes. Full execution results and final evidence are pending; this follow-up is not complete yet.
