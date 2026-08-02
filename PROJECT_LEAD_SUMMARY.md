# MedCollab (Vocle) — Project Lead Summary

**Date:** 2026-08-02  
**Product name (app):** Vocle · **Repo / API name:** MedCollab  
**Purpose:** Replace WhatsApp for department chat, DMs, threads, and clinical shift handoffs  
**Beta target:** ~15 doctors (MBBS interns, PG residents, junior consultants)  
**Production API:** https://medcollab.up.railway.app  
**Health:** https://medcollab.up.railway.app/health  
**Latest APK:** `D:\MedCollab\MedCollab-beta.apk` (rebuild after Sprint 11)  
**Current sprint:** **11 — Beta Polish** ✅ (local; ship APK + deploy backend privacy/notif fixes)

---

## 1. Product overview

| Area | Detail |
|------|--------|
| Mobile | Flutter (bloc, Dio, go_router, Socket.io) — Android beta |
| Backend | Node.js + Express + MongoDB Atlas + Socket.io |
| Hosting | Railway (**Hobby**) — GitHub `mathiharan29/medcollab-beta` **`master`** |
| Media | Cloudinary |
| Auth | Phone OTP via MSG91 widget → JWT |
| Push | **FCM LIVE** (Android) — `PUSH_NOTIFICATIONS.md` |

**Architecture (stable):** REST persists; Socket.io broadcasts. Envelope `{ success, message, data }`.

---

## 2. Sprint status

| Sprint | Outcome | Status |
|--------|---------|--------|
| 1–9 | Auth → Home workspace | ✅ |
| 10 | FCM Android push | ✅ QA |
| **11** | **Beta polish + bugfixes** | ✅ Ready to ship |

### Sprint 11 highlights
- Onboarding / empty states (Home, Spaces, Messages, Join invite)
- Help & FAQ, Report bug, Feature request, Contact team (Profile)
- Hidden **Developer Mode** (debug / `ENABLE_DEV_TOOLS`) — PIN `2468`
- Backend `/api/dev/*` seed routes (non-prod or `ENABLE_DEV_TOOLS=true`)

### Bugfixes in this sprint
1. **DM privacy** — search + create DM limited to shared spaces ∪ existing DMs ∪ same institution; strangers cannot discover each other  
2. **DM route stack** — debounce + no duplicate pushes when opening DMs  
3. **Alerts while chatting** — no inbox/FCM for users already in that channel room (emergency still notifies)  
4. **Offline status** — added to availability list; socket-offline peers show **Offline** (not Available)

---

## 3. Features delivered (summary)

Home workspace, Messages (+ DMs), Handoffs, Alerts, Profile, spaces/channels/threads/media, mentions, receipts, invites, search, FCM push, Vocle clinical UI, Sprint 11 support + onboarding polish.

---

## 4. Known limitations

| Item | Notes |
|------|--------|
| Tab red dots | Still partially hardcoded |
| Bookmarks / Home layout | Device-local |
| Today's Shift | Handoff-derived |
| iOS / APNs | Not configured |
| App id | `com.example.medcollab_app` |
| Backend deploy | Privacy + viewing-channel suppress need Railway deploy from `master` |

---

## 5. Suggested Sprint 12+

1. Unread badges on nav tabs  
2. Commit/push redesign + Sprint 11; keep GitHub `master` current  
3. Beta doctor onboarding pack  
4. Handoff completed/missed + expiry  
5. Shift/roster API  
6. Play Store prep  

---

## 6. Install

```text
adb install -r D:\MedCollab\MedCollab-beta.apk
```

Developer Mode: Profile → long-press **Vocle beta** → PIN `2468` (debug builds or `ENABLE_DEV_TOOLS=true`).

---

## 7. Doc index

| File | Purpose |
|------|---------|
| `PROJECT_LEAD_SUMMARY.md` | This file |
| `AI_HANDOFF.md` | Tech handoff |
| `medcollab-app/PROJECT_STATE.md` | Live status |
| `medcollab-app/TASKS.md` | Task tracker |
| `PUSH_NOTIFICATIONS.md` | FCM setup |
| `DEPLOYMENT.md` | Deploy guide |
