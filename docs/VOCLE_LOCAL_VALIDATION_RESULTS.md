# Local validation results — 18 October 2026

**Local setup is ready.** Existing functional, sanity, security and CI checks were
reused. All 187 functional cases have execution evidence across the initial run
and explicit setup follow-ups. Their measured outcomes are **136 PASS, 30 FAIL
and 21 NEEDS_DECISION**, with no remaining unexecuted setup cases in that scope.
The application is not release-green.

| Existing suite | Executed | PASS | FAIL | Needs decision / observation |
| --- | ---: | ---: | ---: | ---: |
| Backend functional | 147 | 119 | 10 | 18 |
| Flutter functional | 32 | 15 | 14 | 3 |
| Android functional | 8 | 2 | 6 | 0 |
| **Unique functional total** | **187** | **136** | **30** | **21** |
| Retained sanity, included in backend above | 48 | 48 | 0 | 0 |
| Retained Flutter, additional | 33 | 33 | 0 | 0 |
| Media security | 97 | 67 | 0 | 30 observations |
| Data security | 31 | 23 | 0 | 8 observations |
| API security discovery | 691 | 635 | 0 | 56 observations |
| Live Cloudinary, isolated test cloud | 34 | 26 | 0 | 8 observations |

Security observations preserve the original suites' classifications; they are
not confirmed vulnerabilities. Media and discovery share 37 original catalog ID
strings. Their 819 execution records retain distinct suite prefixes and original
`catalogId` values. Sanity is not counted twice in the 187 functional IDs.

## Read the results

These generated artifacts are retained locally on this computer:

- [Functional review dashboard: all 187 measured cases](../tests/developer-workflow/output/local-validation-review-2026-10-18/vocle-regression-dashboard.html)
- [Functional QA findings and ownership requests](../tests/developer-workflow/output/local-validation-review-2026-10-18/qa-defects.md)
- [Security dashboard: 819 suite executions](../tests/developer-workflow/output/python-2026-10-18T05-49-40Z-4e921232/evidence/detailed/vocle-regression-dashboard.html)
- [Live Cloudinary summary and cleanup](../tests/developer-workflow/output/cloudinary-2026-10-18T05-41-16Z-2b93a58f/vocle-cloudinary-results/summary.md)
- [Final Python launcher check](../tests/developer-workflow/output/python-2026-10-18T07-36-12Z-60703307/local-session.md)

The functional review combines explicitly identified measured attempts. It is not
a merged submission/release certificate. Its harness is marked
`MULTIPLE_RECORDED_ATTEMPTS`; it cannot serve as a compatible single-run baseline.
The original full attempt's ERROR and all earlier failures remain preserved.
Per-case original report paths and SHA256 checksums are saved in
[local-execution.json](developer-qa-evidence/2026-10-18-local-parity/local-execution.json).
No application behavior or original assertion was changed to obtain a pass.

Functional validation used committed application source
`9f1738809d2d0ab2bd04f5b45938ec312827bdd1`. Uncommitted application edits were
excluded. Cloudinary used `a0c15e1aa595a0b59974c6ae2bd17d685f2d53ff`, whose
application files match that functional revision. Each report records its own
harness and environment. QA ownership stays UNASSIGNED until a maintainer approves
the existing ownership mapping.

## Future complete local run

From the repository root in PowerShell:

```powershell
python .\scripts\test_vocle.py --source . --commit (git rev-parse HEAD) --all --cloudinary --test-cloud YOUR_TEST_CLOUD
```

Use the approved isolated test cloud name. The script asks for its API key and
secret with hidden terminal prompts. Credentials are not saved or entered into
Git, command arguments, worker configuration or reports. Each new provider run
requires fresh private entry. To omit the live provider lane, omit `--cloudinary`
and `--test-cloud`.

The launcher creates a disposable venv and package caches, prepares Node, Flutter,
Python packages, verified Gradle and minimal Docker, starts disposable databases
and an isolated Android emulator, runs the original suites, writes local evidence
and cleans up owned resources. Existing SDK/JDK installations and the Windows WSL
platform remain available for future runs. No Docker Desktop setup is needed on
this audited machine. Only a committed source is accepted for the native archive
runner; use `--source . --security --ci-checks` for a working-tree backend/Flutter run.

## Verification and cleanup

- 41 Node workflow/reporting contracts and 25 Python launcher/bootstrap contracts PASS.
- Original Gitleaks check: zero findings in the measured 235-commit ancestry.
- Final real Python tooling invocation: 18/18 checks PASS; source/harness bound to
  `0ee30b08447d782919a740020979da520aa2a860`; disposable cleanup PASS.
- Independent [saved-code GitHub integration](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/39108261936):
  Windows, Ubuntu and visual reporting SUCCESS. Downloaded artifact hashes,
  source/harness bindings, 18/18 tooling checks on both platforms, 22/22 Linux
  Docker smoke rows and cleanup were verified. Cold Windows Node/Flutter setup
  also completed. See
  [hosted-saved-code-validation.json](developer-qa-evidence/2026-10-18-local-parity/hosted-saved-code-validation.json).
- Full security execution: integrity and cleanup PASS. Original data artifact
  hygiene/completeness check PASS.
- Live provider safety, sanitized artifacts, initial cleanup and independent
  post-job resource-absence verification PASS.
- Both completed native sessions: provenance and cleanup PASS. Their owned AVDs
  and temporary directories were removed. Fresh startup retry used four CPU cores
  and 4 GB RAM and executed all three prior startup errors.
- Final runtime inventory: no test emulator or private WSL distro remains. Exact
  owned temporary directories are absent; see
  [final-cleanup.json](developer-qa-evidence/2026-10-18-local-parity/final-cleanup.json).

The 30 functional failures and 21 unresolved expectations need independent QA or
product review. This work establishes local execution and evidence collection;
it does not resolve those recorded outcomes or claim iOS/physical-provider delivery.
