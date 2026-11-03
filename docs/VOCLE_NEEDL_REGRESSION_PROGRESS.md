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

## Current checkpoint

Implementation checkpoint awaiting final committed-harness execution. Exact next action: commit the test-only implementation, run new backend and full Flutter functional cases against that revision, preserve genuine failures, generate sanitized structured/detailed reports and record actual counts. Then commit evidence/documentation and push only the temporary fork branch. No claim of complete/passing device or real-provider coverage.
