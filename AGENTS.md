# Vocle regression workspace rules

- User instruction, 3 November 2026: inspect latest upstream `master`, extend existing functional regression with Needl cases, test locally, and push a temporary branch to the testing fork.
- Verified upstream master: `4c01dc24247aa95a73e286a2b42c7f2f81257c7a`. The user's original checkout already matched this commit; its `origin` currently points upstream. That checkout and its untracked work must remain untouched.
- This isolated checkout is based on the fetched upstream master. `origin` is `Sriram4747/medcollab-beta-workflows`; `upstream` is `mathiharan29/medcollab-beta` and strictly read-only.
- Push only the temporary `temp/needl-functional-regression-20261103` branch to the fork. Do not push upstream or modify either remote master. Do not open a PR without a user request.
- Preserve the original 187 catalog IDs, assertions, and all 48 retained sanity cases. Append source-grounded cases; update validators, coverage accounting and reports so new cases cannot silently be omitted.
- Do not modify application functional/security behavior to make tests pass. Preserve genuine FAIL, ERROR, BLOCKED and NEEDS_DECISION outcomes. Do not infer product approval from implementation behavior.
- All execution uses disposable loopback MongoDB, test-owned HTTP/socket/provider/platform fakes and synthetic data. Never access production MongoDB/Atlas, real Cloudinary, Firebase, MSG91, real users or patient data.
- Record exact source/harness revisions, working-tree provenance where applicable, execution commands, cleanup, outcomes and remaining limitations in `docs/VOCLE_NEEDL_REGRESSION_PROGRESS.md`.
