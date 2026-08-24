# MedCollab — Project State

**Last updated:** 2026-08-22  
**Sprint:** 12 — Beta Completion ✅  
**Product UI name:** Vocle  
**Production API:** https://medcollab.up.railway.app  
**Latest APK:** `D:\MedCollab\vocle-beta.apk` (Sprint 12 — unread badges + UX polish)

Share: [`PROJECT_LEAD_SUMMARY.md`](../PROJECT_LEAD_SUMMARY.md) · Tech: [`AI_HANDOFF.md`](../AI_HANDOFF.md)

---

## Product in one line

Clinical collaboration for doctors — Home, spaces, DMs, handoffs, invites, Android push — beta-ready UX with real nav badges and polished onboarding.

---

## Sprint 12 — Beta Completion (2026-08-22) ✅

| Area | Status |
|------|--------|
| Real nav unread badges (Alerts / Messages / Handoffs) | ✅ |
| Messages hub per-row unread counts | ✅ |
| Home search + alerts chip + welcome QR onboarding | ✅ |
| Global search empty/skeleton states | ✅ |
| Member profile cards + Message action | ✅ |
| Invite sheet copy-code + clearer copy | ✅ |
| Profile / notification settings polish | ✅ |
| Nav accessibility + badge animations | ✅ |
| Chat list performance (`cacheExtent`) | ✅ |
| `flutter analyze` + release APK | ✅ |

**Deploy note:** Flutter + backend Sprint 11b rounds 2–3 remain **uncommitted** on branch `design/clinical-design-system`. Push to GitHub `master` before relying on production API for seen-by, PDF filenames, pin responses.

---

## Prior sprints

| Sprint | Status |
|--------|--------|
| 1–10 | ✅ |
| 11 Beta polish | ✅ |
| 11b Beta feedback fixes | ✅ (APK local) |
| 12 Beta completion UX | ✅ |

---

## Open items (post-Sprint 12)

| Priority | Item |
|----------|------|
| High | Git commit/push + Railway deploy backend |
| Medium | Dedicated unread API (optional — currently notification-derived) |
| Medium | Roster / handoff lifecycle / synced prefs |
| Medium | Play Store applicationId |

---

## Local dev

```powershell
cd medcollab-backend
npm run dev

cd medcollab-app
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5000
```

Release APK:

```powershell
cd medcollab-app
powershell -ExecutionPolicy Bypass -File .\scripts\build-release-apk.ps1 `
  -ApiBaseUrl https://medcollab.up.railway.app `
  -Msg91WidgetId <from scripts/dart-defines.release.json> `
  -Msg91WidgetToken <from scripts/dart-defines.release.json>
# Output: D:\MedCollab\vocle-beta.apk
```
