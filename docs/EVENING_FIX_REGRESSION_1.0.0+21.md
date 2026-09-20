# Evening fix pack — regression notes (1.0.0+21)

**Date:** 2026-09-20  
**Research:** `docs/PRODUCT_RESEARCH_HANDOFFS_CHAT.md`

## Shipped this iteration

| # | Issue | Fix |
|---|--------|-----|
| 1 | Slow page loads | Home dashboard loads APIs in parallel + silent socket refresh |
| 2 | Not attended → “Mark as attended” | **Resolve overdue** sheet: “I covered late” / “Close as missed” |
| 5 | NEET PG label / student | **MBBS Student** role (no specialty); Intern label → Clinical interest (optional) |
| 6 | Intern specialty not saving | Always PUT `speciality` (incl. clear); sync dropdown → controller |
| 7 | Crop subtitle | Removed; title stays “Change photo” |
| 8 | Group handoffs no Done | Added **Done** tab (mirrors global) |
| 10 | DM lag + mid-chat scroll | Don’t await `push`; per-channel PageStorageKey; jump-to-end on first paint |
| 11 | Group Message → fail | Falls back to message-request dialog |
| 12 | Self notes | Phone/name → Notes to self DM (1-member channel) |
| 13 | Toggle + phone lookup | Merge notification prefs on server so toggle can’t wipe siblings |
| 14 | Pending list stale | Home reloads on return from detail + `handoff_acknowledged` socket |
| 15 | Forward → OS share | In-app sheet: copy `vocle://` link + pick DM/group |

## Deferred (documented in research doc)

| # | Item | Next sprint |
|---|------|-------------|
| 3 | Assignee write-back / reassign | Handoff reply thread |
| 4/18/19 | I-PASS + medico wishlist | Phased clinical handoff + Slack parity |
| 9 | Dark theme | After DM list UX polish |
| 16 | Multi-person DM | Slack-style group DM |
| 17 | Needl / hub IA | Rename threads + sectioned hub |

## Automated gate

| Check | Result |
|-------|--------|
| `flutter analyze --no-fatal-infos` (touched) | ✅ info-only |
| `flutter test` | ✅ 33 passed |
| Push GitHub `master` | ☐ |
| APK `Vocle-beta.apk` | ☐ |
