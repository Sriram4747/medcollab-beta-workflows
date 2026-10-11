# Vocle detailed QA reports

This shared Node.js reporter extends the existing catalog, runners, JSON/JUnit evidence and conservative developer comparison contract. It does not run tests, change assertions, route bugs to people, provide AI inference, change test classifications, or produce workflow success/skip markers. Node 22+, standard HTML/CSS/JavaScript, and Python's standard `zipfile` library for optional GitHub artifact reads are sufficient. No Allure server, package install or CDN is needed; Allure would add tooling without filling the missing legacy per-step observations.

## Download and open

1. Open a functional regression or sanity Actions run, including a failed run.
2. Download `vocle-regression-dashboard-<run>-<attempt>` for the combined workflow inventory. For sanitized logs and baseline comparison, download `vocle-functional-report-<run>-<attempt>`, `vocle-flutter-report-<run>-<attempt>`, or `vocle-sanity-diagnostics-<run>-<attempt>`.
3. Extract the ZIP. Open `vocle-regression-dashboard.html` in Chrome or Edge. In a lane artifact, the five reports are under `detailed/`, with sanitized logs under `detailed/logs/`. No server or network is needed.
4. Search by ID, feature, scenario or diagnostic. Filter status/module/priority/change, then expand cases. The Markdown and JSON report contain the same facts. JUnit retains `vocle.status` and `vocle.attempted` properties because JUnit has fewer standard outcome categories than Vocle.

The five deliverables are `vocle-regression-dashboard.html`, `vocle-regression-detailed-report.md`, `vocle-regression-results.json`, `vocle-regression-junit.xml`, and `vocle-regression-summary.md`. Existing report names, assertions, gate commands and success-history contracts remain in place. Reporting/setup errors cannot turn a workflow green. A job killed before any reporting step, failed checkout, or platform-wide Actions outage cannot guarantee an artifact; the independent summary job is a fallback when it can run.

## Generate locally

```powershell
node --test tests/reporting/report.test.mjs
node tests/reporting/report.mjs --suite backend --input path/to/results.json --evidence-dir path/to/run --output tests/reporting/output/backend
node tests/reporting/report.mjs --suite flutter --input path/to/report.json --evidence-dir path/to/flutter-output --output tests/reporting/output/flutter
node tests/reporting/report.mjs --suite sanity --input path/to/sanity-report.json --output tests/reporting/output/sanity
node tests/reporting/report.mjs --suite device --input docs/functional-regression-evidence/device-batch7-final/results.json --output tests/reporting/output/device
```

Use `--baseline path/to/vocle-regression-results.json` for a local comparison. Hosted lane reporting uses bounded, read-only lookup of the three most recent matching fork artifacts via the job token. It never searches or writes upstream artifacts. ZIP members are read as JSON; arbitrary ZIP paths are never extracted. Credentials stay in memory and are not forwarded to artifact storage. Unavailable history is displayed explicitly and does not change existing workflow skip-history decisions.

## Data and accuracy contract

- `scenarios.mjs` composes structured fixture roles, ordered catalog actions/expectations and source definitions for all 187 immutable IDs. Curated overrides explain complicated consent/recovery/notification scenarios. The catalog remains the source of truth; current test definitions supply literal API routes, payloads, boundary variants and assertions. Catalog fixture profiles U/C/H/N/M/F0/D0 retain their documented synthetic restrictions.
- A source excerpt is **a procedure, not an execution trace**. Its file SHA-256 and line reference are recorded. Excerpts may include helper references; owning files supply their full implementation. Fixture seeding reported by the runner is explicitly separate from behavior verified by that case.
- Backend, sanity, Flutter, device and developer evidence are normalized without changing the original outcome. Unknown IDs, duplicate IDs, unexecuted PASS and tally mismatch generate a reporting validation error and non-success report. Missing required rows become ERROR with `executed: false`; planned/skipped lanes remain unexecuted SKIP. A separate infrastructure section records setup/provenance/cleanup/report problems without overwriting application FAILs.
- PASS means the original runner reported completion within the executable scope. Legacy runners do not record every intermediate HTTP/DB/socket value or assertion index. Those fields say **not captured**, rather than inventing values. Failure diagnostics are retained; an HTTP expected/got diagnostic supplies the exact operation and statuses. Root cause stays UNKNOWN unless explicitly recorded. User-facing impact is labeled inferred. Product questions and safe subassertions remain visible.
- Owners come only from approved `tests/developer-workflow/ownership.json`; otherwise UNASSIGNED. Nothing assigns or notifies a developer.
- Compatible comparison requires matching suite/scope, source kind, definitions, harness fingerprint, known environment fingerprint, and exact source/harness SHA evidence. It reuses `compareReports` for FIXED, NEW_REGRESSION, STILL_FAILING and STILL_PASSING. Changed definitions/environment, missing execution and undecided outcomes do not silently become regressions/fixes. Older reports lacking sufficient environment evidence cannot be compared.
- HTML data escapes `<`, `>`, `&` and Unicode separators. Dynamic UI uses DOM `textContent`, never diagnostic `innerHTML`. Links reject schemes, absolute paths and traversal. A CSP prohibits connections, external resources and forms. Source/log text is redacted recursively; opaque credential fields, bearer tokens, JWTs, OTPs, synthetic secrets and signed URL queries are excluded. Original local runner files remain intact; uploads use a sanitized text-only publication copy. Full-backend success checksums refer to the published report bytes.
- Combined workflow reports include only hosted backend/Flutter or sanity lanes. Device results are generated locally from actual device evidence; they are not fabricated as hosted runs. Android coverage does not imply iOS or production/provider coverage.

## Maintaining scenarios

Edit catalog actions/expected results only through the approved testcase specification process. Reporting improvements belong in `scenarios.mjs` fixture/context/overrides or the generator. Keep procedure text factual; do not convert known application defects into expected results. Add a contract fixture for every new input shape, and preserve the actual runner's outcome. No runtime AI inference is used.
