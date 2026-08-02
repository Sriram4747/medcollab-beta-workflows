# MedCollab (Vocle) — Tech Lead Report & AI Handoff

**Date:** 2026-08-02  
**Sprint:** 11 — Beta Polish ✅  
**Status:** Sprint 11 polish + DM privacy / notify-while-reading / Offline ready; **deploy backend to Railway** for API fixes  
**Production API:** https://medcollab.up.railway.app  
**Railway deploy source:** GitHub `mathiharan29/medcollab-beta` **`master`** (root `medcollab-backend`)  
**Latest APK:** `D:\MedCollab\MedCollab-beta.apk`  

---

## 1. Product summary

| Layer | Status |
|-------|--------|
| Backend | ✅ + Sprint 11 privacy / notify / `/api/dev` |
| Mobile | ✅ Sprint 11 polish + FCM |
| Push (FCM) | ✅ Android LIVE |

**Do not change:** feature folders, `{ success, message, data }`, REST persist / Socket broadcast.

---

## 2. Sprint 11 — Beta Polish ✅

### Bugfixes
| Bug | Fix |
|-----|-----|
| DM stranger discovery | `knownUsers.js` — spaces ∪ DMs ∪ institution; gate `createOrGetDM` |
| DM screens stacking | `openDmChat` + open debounce; replace from search |
| Alerts while in chat | Skip notify for channel room viewers; `ActiveChatTracker` client-side |
| No Offline status | `offline` availability + socket-offline display |

### Product polish
- Empty states / join invite copy  
- Help & FAQ, Report bug, Feature request, Contact team  
- Developer Mode (PIN `2468`, debug or `ENABLE_DEV_TOOLS`)  
- API seeds: `POST /api/dev/seed-notifications`, `seed-conversation`, `seed-handoff`

---

## 3. Sprint 10 — FCM ✅

Firebase Admin on Railway; Flutter FCM client; QA confirmed with app killed.

---

## 4. Known limitations

| Item | Limitation |
|------|------------|
| Tab unread badges | Often hardcoded |
| Prefs / bookmarks | Device-local |
| Today's Shift | Handoff-derived |
| iOS | No APNs |
| Deploy | Push Sprint 11 backend to GitHub `master` |

---

## 5. Suggested Sprint 12+

1. Unread badges  
2. Git push + Railway deploy  
3. Handoff lifecycle / roster / synced prefs  
4. Play Store prep  

---

## 6. Doc index

`PROJECT_LEAD_SUMMARY.md` · `medcollab-app/PROJECT_STATE.md` · `TASKS.md` · `PUSH_NOTIFICATIONS.md` · `DEPLOYMENT.md`
