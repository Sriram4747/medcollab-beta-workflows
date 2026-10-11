# Vocle visual reporting across workflows

## 11 October 2026 — completed reporting enhancement

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

Implementation pushed: `9c22847` (visual reporting) and `75ac368` (preserve recorded security module labels and compare linked original artifacts). No testcase assertions or application source were changed by these commits. Existing concurrent upstream merge/security/fixture changes were preserved.

Hosted evidence at `9c22847`:
- [Secret Scan 38132630328](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132630328): original job and visual reporter PASS; three recorded workflow checks, not three new testcases. Visual ZIP digest/five files/JUnit/HTML counts/redaction verified. Raw SARIF never downloaded by reporting.
- [Developer QA 38132630313](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132630313): Linux/Windows jobs and final reporter PASS. Three profile reports remain separate (13/17/13 recorded checks), combined job inventory 15 PASS/3 SKIP. All ZIPs verified.
- [Data Security 38132656677](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132656677): 31 cases, 23 PASS/8 OBSERVATION, original gate SUCCESS; reporter PASS. New artifact verified against the linked original result ZIP.
- [Offline Media 38132658266](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132658266): 97 cases, 67 PASS/30 OBSERVATION, original gate SUCCESS; reporter PASS. Artifact verified against original result ZIP.
- [Functional Regression 38132630150](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132630150): backend 119 PASS/10 FAIL/18 NEEDS_DECISION; Flutter 15 PASS/14 FAIL/3 NEEDS_DECISION. Combined 179 attempts: 134 PASS/24 FAIL/21 NEEDS_DECISION, other outcomes zero. All reporting/staging/uploads/collection PASS; original gates FAILURE. All three ZIPs verified. Offline Chrome against the downloaded combined report PASS, screenshot inspected. These current results differ from older historical examples because execution revisions differ; the reporter does not change the outcomes.
- [Sanity 38132949165](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132949165), harness `75ac368`: 48 records, 44 attempts, 42 PASS/2 FAIL/4 BLOCKED; reporter/uploads/collector PASS, original workflow FAILURE. Both ZIPs verified.

Real Cloudinary: existing [38131356746](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38131356746), source `b0471ba`, was read from GitHub and rendered with the enhanced adapter: 26 PASS/8 OBSERVATION/34 attempted. Reporter provider calls: zero. `visual-cloudinary-38131356746/` is explicitly historical. The new reporting job is integrated, but no new provider workflow was dispatched or claimed verified at `75ac368`.

Final hosted checkpoints at `75ac368`:
- [Functional Regression 38132939568](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132939568) completed with reporting/staging/uploads/collector PASS and original functional gates FAILURE. All three ZIPs verified. Counts remain backend 119 PASS/10 FAIL/18 NEEDS_DECISION and Flutter 15 PASS/14 FAIL/3 NEEDS_DECISION; combined 179 attempts, 134 PASS/24 FAIL/21 NEEDS_DECISION. Exact uploaded five-file example: `docs/reporting-examples/visual-hosted-regression-38132939568/`.
- [Backend Environment Test 38132947030](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132947030) completed SUCCESS including the new reporter. 691 attempts, 635 PASS/56 OBSERVATION, other outcomes zero. Both source/visual ZIPs downloaded; digest, all five reports, original status/count fidelity, JUnit, HTML and redaction PASS. Every recorded module label and original passed boolean independently matched the original result. Evidence: `visual-discovery-module-verification.json`.
- Secret Scan [38132939827](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132939827) and Developer QA [38132939702](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132939702) also completed SUCCESS at this revision.

The final artifact verifier initially flagged six Markdown-escaped `\[REDACTED\]` markers as bearer values. Inspection proved all six were exact masking markers, not exposed tokens. The audit now accepts only exact plain/escaped masks and still detects unmasked values; an executable contract preserves that distinction. Final local reporter/adapter contracts: 26/26 PASS. This correction changes the independent artifact auditor, not generated test evidence, outcomes or gates.

Delivery status: COMPLETE for reporting implementation across the eight included workflows. Seven workflows have current hosted report verification; Real Cloudinary is integrated and validated with original recorded GitHub evidence plus offline contracts, without a new provider execution. Security Environment Test is excluded and unchanged. Original application defects, security observations and product decisions remain unresolved where recorded; reporting success does not make these pass.

Final changes are committed only to origin/master. The final evidence/documentation commit also contains the independent masking-marker audit fix/contract; report generator and hosted artifact revision remain explicitly `75ac368`. Find the final commit with `git log -1 --format=%H -- docs/VOCLE_ALL_WORKFLOWS_REPORTING_PROGRESS.md`.

Exact next action for users: open a run summary, sign into GitHub, click **Download report ZIP**, extract it and open `vocle-regression-dashboard.html`. Functional example download: https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38132939568/artifacts/11700271157. Existing original uploaded artifacts remain immutable; use the refreshed example directories or `refresh.mjs` for older evidence. No implementation remains pending. Existing user Flutter/Android work and the product understanding document remain excluded from commits. Upstream and production services were untouched by this task.
