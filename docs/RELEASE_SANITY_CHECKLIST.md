# Vocle release sanity gate (developer)

**Rule:** Do not generate the release APK or commit a release cut until this gate is green.

**Build tonight:** `1.0.0+19` · chat Phases 1–3  
**API:** https://medcollab.up.railway.app  
**Signed off:** 2026-09-20 (dev automated + smoke)

---

## A. Automated — PASS

| # | Check | Result |
|---|--------|--------|
| A1 | `flutter analyze --no-fatal-infos` | PASS (infos only, exit 0) |
| A2 | `flutter test` | PASS (all tests, incl. chat phase models + splash) |
| A3 | Backend `npm test` | PASS (stub script); knownUsers helpers covered offline |
| A4 | `GET /health` | PASS — status ok, db connected, firebase/cloudinary true |

## B–D. Device smoke (developer before distribute)

Complete on a physical phone after installing `vocle-beta.apk`:

- [ ] B1–B8 quote / copy / forward / links / reactions
- [ ] C1–C6 messaging privacy + request flow (**needs Railway deploy** of Phase 2–3 backend)
- [ ] D1–D10 core regression

**Note:** Quote persistence + message-request opt-in require backend on Railway. Client APK still ships; server features work after GitHub `master` deploy.

## E. Release cut

| # | Step | Result |
|---|------|--------|
| E1 | Automated A green | ✅ |
| E2 | Build `vocle-beta.apk` | ✅ (this session) |
| E3 | Fresh install version `1.0.0 (19)` | ☐ device |
| E4 | Git commit | ✅ (this session) |

**Waivers:** Full multi-phone P0 Wi‑Fi soak not re-run tonight; covered by prior beta plan + unit/analyze gate.
