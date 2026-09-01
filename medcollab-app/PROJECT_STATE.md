# MedCollab — Project State

**Last updated:** 2026-08-24  
**Sprint:** 14 — Closed Beta Release ✅  
**Product UI name:** Vocle  
**Version:** `1.0.0+14`  
**Production API:** https://medcollab.up.railway.app  
**Latest APK:** `D:\MedCollab\vocle-beta.apk`  
**Checklist:** [`BETA_CHECKLIST.md`](../BETA_CHECKLIST.md) · Notes: [`RELEASE_NOTES.md`](../RELEASE_NOTES.md)

Share: [`PROJECT_LEAD_SUMMARY.md`](../PROJECT_LEAD_SUMMARY.md) · Tech: [`AI_HANDOFF.md`](../AI_HANDOFF.md)

---

## Product in one line

Clinical collaboration for doctors — Home, spaces, DMs, handoffs, invites, Android push — closed-beta ready with legal surfaces, feedback channels, and release checklist.

---

## Sprint 14 — Closed Beta (2026-08-24) ✅

| Area | Status |
|------|--------|
| Transparent brand logo | ✅ |
| Versioning `1.0.0+14` | ✅ |
| Privacy + Terms | ✅ |
| FAQ / Feedback / Bug report | ✅ |
| Analytics policy (none) | ✅ |
| Production + FCM verification docs | ✅ |
| Release notes + beta checklist | ✅ |
| Release APK | ✅ |

**Deploy note:** Push Sprint 13–14 backend (`/health` firebase fields, support feedback, socket/DM/media fixes) to GitHub `master` for Railway before relying on new health fields in production.

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
