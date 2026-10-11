# Actual downloaded report examples

## Final reporting revision

`regression-38123414193/` contains the five exact report members from the final hosted [run 38123414193](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38123414193), source/harness `29b56e4`. All 179 backend/Flutter cases were attempted: 133 PASS, 27 FAIL, 19 NEEDS_DECISION; other outcomes zero. All reporting steps passed, while original application gates correctly failed. ZIP digests, original outcome fidelity, all five deliverables, JUnit, embedded HTML counts and publication secret checks passed. Offline Chrome executed against downloaded backend data successfully; exact evidence is in `docs/reporting-evidence/`.

Download `vocle-regression-dashboard-38123414193-1`, extract it and open `vocle-regression-dashboard.html` locally. Download `vocle-functional-report-38123414193-1` and `vocle-flutter-report-38123414193-1` for sanitized logs and lane comparisons; reports are under `detailed/`. Flutter has a compatible baseline: 15 STILL_PASSING, 14 STILL_FAILING, 3 UNCHANGED_NONPASS. Backend history is explicitly unavailable when its harness differs. No device execution is implied.

## Earlier verified snapshots

`regression-38120757524/` contains the five exact report members from the complete hosted [backend/Flutter run](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38120757524): 179 attempted cases, 133 PASS, 27 FAIL, 19 NEEDS_DECISION, other outcomes zero. Device cases are outside this hosted inventory. The original gates remain failed. Download the lane artifacts for sanitized logs; the combined artifact preserves their names and metadata. This snapshot retains the exact HTML originally uploaded before the later presentation-only artifact link improvement.

`sanity-38120454586/` contains the five exact detailed report members downloaded from the failed hosted sanity run [38120454586](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38120454586). ZIP digests, original classifications/counts, JUnit and HTML embedded data were independently verified; evidence is under `docs/reporting-evidence/`.

These are real historical execution reports: 42 PASS, 2 FAIL, 4 BLOCKED, with zero ERROR/NEEDS_DECISION/SKIP. They are not 48 passed and do not establish current backend/Flutter/device correctness. The execution source and harness revisions remain in the report. Read reproduction definitions as procedures, not per-step traces.

Open `vocle-regression-dashboard.html` locally in Chrome or Edge after downloading/extracting the directory. It has no server/CDN dependency. This initial sanity example has no linked run logs; the original artifact contains the sanitized backend log separately. The updated sanity workflow collects logs before generation so later dashboards link their sanitized copies.

The later sanity [38120856995](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38120856995) was downloaded and verified with both backend/provenance log links present. Exact verification records are in `docs/reporting-evidence/`.
