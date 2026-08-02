# MedCollab — Project State

**Last updated:** 2026-08-02  
**Sprint:** 11 — Beta Polish ✅  
**Product UI name:** Vocle  
**Production API:** https://medcollab.up.railway.app  
**Latest APK:** `D:\MedCollab\MedCollab-beta.apk` (rebuild after Sprint 11)

Share: [`PROJECT_LEAD_SUMMARY.md`](../PROJECT_LEAD_SUMMARY.md) · Tech: [`AI_HANDOFF.md`](../AI_HANDOFF.md)

---

## Product in one line

Clinical collaboration for doctors — Home, spaces, DMs, handoffs, invites, Android push — with beta onboarding polish and DM privacy hardening.

---

## Sprint 11 — Beta Polish (2026-08-02) ✅

| Area | Status |
|------|--------|
| Empty states / join / invite copy | ✅ |
| Help & FAQ / Report bug / Feature request / Contact | ✅ |
| Developer Mode (debug / ENABLE_DEV_TOOLS) | ✅ |
| DM privacy (known users only) | ✅ |
| DM navigation stack fix | ✅ |
| Suppress notifications while viewing chat | ✅ |
| Offline availability | ✅ |

**Deploy note:** Backend privacy + channel-viewer notification suppress must be on Railway (`master`) for production effect.

---

## Prior sprints

| Sprint | Status |
|--------|--------|
| 1–9 | ✅ |
| 10 FCM | ✅ |
| 11 Beta polish | ✅ |

---

## Open items (Sprint 12+)

| Priority | Item |
|----------|------|
| High | Unread nav badges |
| High | Git push + Railway deploy Sprint 11 API |
| Medium | Roster / handoff lifecycle / synced prefs |
| Medium | Play Store applicationId |

---

## Local dev

```powershell
cd medcollab-backend
# Optional: ENABLE_DEV_TOOLS=true
npm run dev

cd medcollab-app
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5000
# Dev tools: --dart-define=ENABLE_DEV_TOOLS=true (or kDebugMode)
```
