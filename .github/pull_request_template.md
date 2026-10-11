## Behavior and regression coverage

Describe the behavior change and expected result.

- [ ] Existing IDs and assertions are preserved; new cases are registered in the functional/security catalogs.
- [ ] Application changes include `.github/regression-coverage.json` using the documented schema.
- [ ] Attach or link `results.json` and `manifest.json`; paste generated `submission.md` and replace REPORT_URL.
- [ ] Source SHA matches the submitted commit; dirty-tree evidence is clearly identified.
- [ ] Required hosted gates independently verify this commit; required failures/omissions prevent approval.
- [ ] Security relevance and case selection reviewed; independent QA checks cross-feature effects.
- [ ] Owner and any exceptions confirmed by an authorized maintainer; unknown owners remain UNASSIGNED.

Reviewers must judge assertion quality and missing scenarios; automation cannot infer all required testcases.
