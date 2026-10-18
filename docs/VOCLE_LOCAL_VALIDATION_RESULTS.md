# Local validation results — 18 October 2026

## Latest complete functional run

All **187 functional cases executed in one fresh invocation**, from 09:58:50 to
10:26:55 UTC (28 minutes). Source and harness:
`ef2c295e4dd2181f1d7d233d96faa7cd7093c5f4`. No earlier outcomes were imported.

| Suite | Executed | PASS | FAIL | Needs decision |
| --- | ---: | ---: | ---: | ---: |
| Backend | 147 | 119 | 10 | 18 |
| Flutter | 32 | 15 | 14 | 3 |
| Android | 8 | 1 | 7 | 0 |
| **Functional total** | **187** | **135** | **31** | **21** |

**Environment errors: 0. Blocked functional cases: 0. Unexecuted cases: 0.**
Cleanup and provenance passed. Application failures and unresolved expectations
retain their original classifications; the application gate is FAIL.

The resume case initially emitted PASS, then the original native runner recorded
a subsequent application exception and finalized it as FAIL. The final report
preserves that FAIL. Its seven native failures include application assertions
and asynchronous Bloc/Cubit exceptions; none was classified as a setup error.
Uncommitted application edits were excluded from this committed-source run.

## One folder for this run

Everything from this invocation is under:

`test-results/full-187/2026-10-18T09-58-50Z-17dfb426/`

- [Open the 187-case dashboard](../test-results/full-187/2026-10-18T09-58-50Z-17dfb426/vocle-regression-dashboard.html)
- [Folder guide](../test-results/full-187/2026-10-18T09-58-50Z-17dfb426/README.md)
- [Functional counts and actual execution](../test-results/full-187/2026-10-18T09-58-50Z-17dfb426/functional-summary.json)
- [QA findings and ownership requests](../test-results/full-187/2026-10-18T09-58-50Z-17dfb426/qa-defects.md)
- [Session, reproduction and cleanup](../test-results/full-187/2026-10-18T09-58-50Z-17dfb426/local-session.md)
- [Report fidelity verification](../test-results/full-187/2026-10-18T09-58-50Z-17dfb426/verification.json)

The root dashboard contains only the 187 functional IDs. Original backend,
Flutter, Android and tooling output is under the same folder's `evidence/`.
The detailed dashboard there also includes supporting checks and unselected
optional coverage. The earlier 18-check Python report was tooling validation.
It was not a run of the 187 functional cases.

Every new full run creates a new folder under `test-results/full-187/`.
`test-results/LATEST_FULL_RUN.txt` points to the latest full invocation and
records its actual executed count and cleanup. Tooling runs cannot replace this
pointer. Other scopes also use the `test-results/` parent. Existing historical
output remains preserved at its recorded location.

## Run the 187 cases again

From the repository root in PowerShell:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --android --ci-checks
```

The launcher prepares the disposable venv, packages, Docker guest, verified Gradle
and Android emulator, invokes the existing suites and removes its owned runtime.
Installed SDK/JDK and the Windows WSL platform remain available for future runs.
The exact commit is recorded; uncommitted app edits are excluded by this command.
Use `--all` in place of `--android --ci-checks` to add the isolated security suites.
Live Cloudinary requires explicit selection and private credential entry; see
[the workflow guide](VOCLE_LOCAL_WORKFLOW_PARITY.md).

## Verification

- All 187 IDs and final statuses match 71 original report files. JSON, dashboard
  embedded data and JUnit agree. Checksums and per-report references are saved in
  [single-invocation.json](developer-qa-evidence/2026-10-18-local-parity/single-invocation.json).
- Existing offline Chromium checks passed: all 187 IDs, charts, filtering,
  downloads, safe diagnostic rendering and no external resource requests.
- 15 original CI/native contracts, 41 workflow/reporting contracts and 25 Python
  contracts passed. Retained sanity: 48/48 PASS (included in backend above).
  Retained Flutter: 33/33 PASS (additional). Gitleaks: 244 commits, zero findings.
- Independent [GitHub integration for the saved runner](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/39117439256)
  passed on Windows, Ubuntu and visual reporting.
- Original native source/cleanup and overall runtime cleanup passed. The owned
  temporary directory, private WSL guest, emulator and browser profile were
  independently verified absent. The same folder retains `cleanup-verification.json`.

The 31 functional failures and 21 undecided expectations need QA/product review.
QA ownership remains UNASSIGNED pending an approved ownership mapping.

## Earlier additional suite validation

These suites were previously run separately; they were not rerun by the focused
187-case command above:

| Suite | Executed | PASS | Observations |
| --- | ---: | ---: | ---: |
| Media security | 97 | 67 | 30 |
| Data security | 31 | 23 | 8 |
| API security discovery | 691 | 635 | 56 |
| Live Cloudinary in isolated test cloud | 34 | 26 | 8 |

Their original evidence, cleanup and historical functional attempts remain
referenced in
[local-execution.json](developer-qa-evidence/2026-10-18-local-parity/local-execution.json).
Observations preserve the original classification and are not confirmed
vulnerabilities. The earlier combined 136/30/21 functional view is historical;
the fresh single-invocation result above is **135/31/21**.
