# Restore upstream manual workflow execution

## Verified cause and prepared fix — 3 November 2026

The owner changed upstream's default branch to master; read-only Git inspection confirms it. Upstream master still points to4c01dc2, whose migrated routine workflows accept PR events only. That configuration explains the missing Run workflow button. This patch is prepared in Sriram4747/medcollab-beta-workflows on temp/needl-functional-regression-20261103. Upstream remains read-only from this workspace.

Manual entry points after integration: Functional Regression, Functional Sanity, API & Realtime Security, MongoDB Data Security, Offline Media Security, Developer QA Integration and Secret Scan. Existing Real Cloudinary Security stays separately restricted and unchanged. Security Environment and Shared Visual Reporting remain reusable-only; their context validation now also accepts an authorized manual parent invocation. No standalone environment trigger or real-provider operation was added.

Existing PR events targeting master still execute. Manual runs accept upstream branch refs and pin GITHUB_SHA; functional/sanity source resolution records kind commit and always selects backend-all. Manual Flutter provenance uses the same captured commit. Fork repositories, fork PRs, tags, malformed SHAs and unsupported events remain rejected. Push/schedule/path/history skipping was not introduced. Current assertions, cleanup, provider isolation, failure gates and LOCAL_ONLY Android accounting remain intact.

## Owner action required

1. Integrate the prepared changes into mathiharan29/medcollab-beta master. The temporary branch also includes the earlier241-case Needl expansion and its evidence; review that full scope. For PR validation, use a branch within upstream because the established guards reject fork PRs. Do not bypass genuine failing functional checks.
2. Once the workflow code is on upstream's default master branch, refresh Actions, select an owning workflow, choose Run workflow and select master or another upstream development branch. The operator needs repository Write access.
3. Inspect the actual hosted run and artifacts. The standalone workflows run their configured complete suites; Android remains developer-local. Real Cloudinary still requires its separate authorization/settings/secrets and must not be run as part of routine verification.

Changing only the default branch does not modify workflow YAML or PR-only guards. Until this patch is integrated, the missing button is expected. This session does not create an upstream branch/PR, merge, change permissions/settings or trigger upstream workflows.

## Validation and remaining limits

- All10 workflow YAML files parsed.
- **82/82 local workflow/reporting/coverage contracts PASS**, including execution of all14 actual Bash guards over154 accepted/rejected context scenarios and exact manual/PR SHA selection tests.
- Catalog validator PASS:241 total,177 backend,56 Flutter,8 device,48 retained sanity IDs.
- Application source, dependencies and real-provider workflow unchanged.
- Hosted execution is not claimed: owner integration is still required. Local contracts cannot prove hosted runner setup or account permissions.
- Earlier complete241-case local execution remains235 PASS,5 FAIL,1 NEEDS_DECISION at its recorded revisions; this workflow-only change does not relabel or rerun it. The known Needl defects and NDL-D1 still gate functional success.

Evidence: workflow-manual-evidence/2026-11-03/validation.json and contracts.txt. Changed definition checksums and the pre-change harness commit are recorded there. Run the contracts with Node and Git Bash on Windows (bash on Linux):

```powershell
node --test tests/developer-workflow/manual-workflows.test.mjs tests/developer-workflow/migration.test.mjs tests/functional-regression/scripts/ci-contracts.test.mjs
```

GitHub requirements: https://docs.github.com/en/actions/how-tos/manage-workflow-runs/manually-run-a-workflow
