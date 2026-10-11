# Detailed regression reporting implementation

## 11 October 2026 — implementation checkpoint

- Existing backend/sanity/Flutter/device JSON/JUnit, catalog, decision ledger, CI gates, provenance/cleanup, and developer QA/strict comparison infrastructure were audited. Tests, IDs, assertions and application source are unchanged.
- Shared `tests/reporting/report.mjs` normalizes legacy and current evidence and writes the five requested reports. `scenarios.mjs` supplies structured synthetic prerequisites, ordered catalog actions, business scenarios, boundaries, literal executable definitions and limitations for all 187 existing IDs. No AI runs in Actions.
- Offline dashboard implements status/module breakdown, text search, status/module/priority/change filters, expandable details, reproduction, expected/actual, uncertainty, revisions/durations, sanitized evidence links and conservative history highlights.
- Functional regression and sanity workflows generate reports/stage sanitized evidence with `always()`, preserve original gates and success-history behavior, and independently collect final reports after failures/skips. Backend success-manifest hashes now reference sanitized published report bytes. Developer orchestration reuses the generator.
- Validation: 15 reporter contracts PASS; eight existing CI contracts PASS; eight developer evidence/coverage contracts PASS; catalog 187/48/139 B147/F32/D8 PASS; workflow YAML syntax PASS. These are tooling checks, not new functional testcases.
- Offline Chrome execution PASS for all 147 historical backend rows, search, status/module/priority filters, expansion/lazy details, hostile markup inertness and absence of external resource requests. Screenshot inspected. Local Edge launcher produced no stdout/DOM; Chrome supplied the actual browser execution evidence.
- Historical example evidence retains its original counts: upstream `da2baff`, harness `ce082e5`, backend PASS109/FAIL17/BLOCKED4/NEEDS_DECISION17, ERROR/SKIP0. These examples are older than the latest application run and must not be presented as current coverage.
- Hosted execution/artifact verification: pending implementation push and real isolated run. Do not claim hosted reporting verified yet.
- Remaining limitations: original runners lack per-step traces/intermediate values; reports explicitly mark those unknown. Old baselines missing environment evidence are not comparable. Forced runner termination/platform outage may prevent artifacts. No real provider, production, iOS or physical-device coverage is added.
- Exact next action: push this implementation only to fork `origin/master`, inspect the triggered functional workflow, force the existing sanity workflow, download generated artifacts, validate counts/redaction/gates and update this checkpoint with run URLs and evidence.

User Flutter/Android modifications and `docs/VOCLE_PRODUCT_UNDERSTANDING.md` remain excluded. Upstream is read-only and production services are untouched.
