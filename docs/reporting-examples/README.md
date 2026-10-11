# Actual downloaded report examples

`sanity-38120454586/` contains the five exact detailed report members downloaded from the failed hosted sanity run [38120454586](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38120454586). ZIP digests, original classifications/counts, JUnit and HTML embedded data were independently verified; evidence is under `docs/reporting-evidence/`.

These are real historical execution reports: 42 PASS, 2 FAIL, 4 BLOCKED, with zero ERROR/NEEDS_DECISION/SKIP. They are not 48 passed and do not establish current backend/Flutter/device correctness. The execution source and harness revisions remain in the report. Read reproduction definitions as procedures, not per-step traces.

Open `vocle-regression-dashboard.html` locally in Chrome or Edge after downloading/extracting the directory. It has no server/CDN dependency. This initial sanity example has no linked run logs; the original artifact contains the sanitized backend log separately. The updated sanity workflow collects logs before generation so later dashboards link their sanitized copies.
