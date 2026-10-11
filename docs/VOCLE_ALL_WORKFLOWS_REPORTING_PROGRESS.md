# Vocle visual reporting across workflows

## 11 October 2026 — implementation checkpoint

| Existing workflow | Integration | Evidence scope |
| --- | --- | --- |
| Functional Regression | Existing collector + enhanced shared dashboard + clickable upload link | Exact case results and lane comparisons |
| Functional Sanity | Existing collector + enhanced shared dashboard + clickable upload link | Exact retained sanity outcomes |
| Developer QA Integration | Shared final report after matrix + enhanced profile dashboards | Job checks and separately linked matrix/profile evidence |
| Backend Environment Test | Shared final report | Original API security cases, recorded expected/actual, setup and job evidence |
| MongoDB Data Security | Shared final report | Original HTTP/model/handler cases and cleanup observations |
| Offline Media Security | Shared final report | Original local/SDK-double cases; no real-provider coverage implied |
| Real Cloudinary Security | Shared final report; offline adapter validation | Existing recorded provider evidence only; no provider operations by reporter |
| Secret Scan | Shared final report | Original scanner step outcomes; no matched secrets or SARIF snippets published |
| Security Environment Test | EXCLUDED and unchanged | User exclusion preserved |

Reusable `vocle-reporting.yml` is an implementation helper, not a new scheduled test workflow. Original tests, assertions, triggers, hygiene conditions and gates are retained. Only read access to the fork's existing Actions artifacts/jobs is added. No application source changes, upstream writes, production access or provider calls are part of reporting.

Visual changes: navigation, status cards, outcome donut, module bars, chart drill-down, synchronized filters, priority coverage, recorded duration bars, baseline badges, expandable case details, job outcomes, five local file downloads and real artifact hyperlinks. No external CDN, server, Power BI service or AI inference. Unknown duration, priority, root cause and ownership remain explicitly unknown.

Classification contract: security OBSERVATION remains separate and retains original boolean/classification/counts. It is not accepted broken behavior, confirmed vulnerability, or functional PASS/FAIL. Original security non-blocking behavior is preserved. JUnit uses skipped for OBSERVATION with explicit status/attempted properties. Workflow checks and developer matrix lanes are not summed as unique application cases.

Local verification: 25 reporter/adapter contracts PASS. Workflow YAML parses. Offline headless Chrome checks PASS for the actual 179-result functional report and 691-case historical discovery report: chart rendering/drill-down/reset, status/module/priority filters, search, case expansion, hostile text inertness, five download links, artifact hyperlinks and no external resources. Screenshot inspected. Chrome execution is not application UI coverage; Edge is not claimed executed.

Historical refreshed examples: `docs/reporting-examples/visual-regression-38123414193/` (133 PASS, 27 FAIL, 19 NEEDS_DECISION) and `visual-discovery-37361855710/` (611 PASS, 80 OBSERVATION). These are new presentations of old execution evidence, never new test runs. Original uploaded artifacts/snapshots are preserved.

Hosted validation: pending implementation push. Exact next action: push reporting-only changes to origin/master; inspect automatic functional/developer/scanner runs and manually run only allowlisted disposable data/media/environment workflows. Download and verify the enhanced artifacts. Do not dispatch Real Cloudinary or excluded Security Environment Test. Save hosted evidence and final checkpoint. Existing user Flutter/Android work and product understanding document remain excluded from commits.
