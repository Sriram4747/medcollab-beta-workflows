# MedCollab (Vocle) — Project Lead Summary

**Date:** 2026-08-22  
**Product name (app):** Vocle · **Repo / API name:** MedCollab  
**Purpose:** Replace WhatsApp for department chat, DMs, threads, and clinical shift handoffs  
**Beta target:** ~15 doctors (MBBS interns, PG residents, junior consultants)  
**Production API:** https://medcollab.up.railway.app  
**Health:** https://medcollab.up.railway.app/health  
**Latest APK:** `D:\MedCollab\vocle-beta.apk` (build script copies here automatically)  
**Active branch:** `design/clinical-design-system` (large uncommitted delta — not all pushed)  
**Last pushed commit:** `59da551` — chat pins, threads/reply, reactions, attach UX, QR scan, avatar crop  

---

## 1. Product overview

| Area | Detail |
|------|--------|
| Mobile | Flutter (bloc, Dio, go_router, Socket.io) — Android beta |
| Backend | Node.js + Express + MongoDB Atlas + Socket.io |
| Hosting | Railway — GitHub `mathiharan29/medcollab-beta` **`master`** (root: `medcollab-backend`) |
| Media | Cloudinary (PDFs use attachment-friendly URLs on new uploads) |
| Auth | Phone OTP via MSG91 widget → JWT |
| Push | **FCM LIVE** (Android) — see `PUSH_NOTIFICATIONS.md` |
| Official contact | `vocle.official@gmail.com` · Instagram `@thevocle` |

**Architecture (stable):** REST persists; Socket.io broadcasts. Envelope `{ success, message, data }`.

**Build APK:**
```powershell
$defs = Get-Content D:\MedCollab\medcollab-app\scripts\dart-defines.release.json -Raw | ConvertFrom-Json
cd D:\MedCollab\medcollab-app
powershell -ExecutionPolicy Bypass -File .\scripts\build-release-apk.ps1 `
  -ApiBaseUrl $defs.API_BASE_URL `
  -Msg91WidgetId $defs.MSG91_WIDGET_ID `
  -Msg91WidgetToken $defs.MSG91_WIDGET_TOKEN
# Output: D:\MedCollab\vocle-beta.apk
```

---

## 2. Sprint status

| Sprint | Outcome | Status |
|--------|---------|--------|
| 1–10 | Auth → Home, FCM, core chat | ✅ Shipped |
| **11** | Beta polish, DM privacy, support pages | ✅ Shipped (`5aeff9a` + `b2330dc`) |
| **11b** | Beta doctor feedback — three fix rounds | ✅ In `vocle-beta.apk` locally |
| **12** | Beta completion UX polish | ✅ **`vocle-beta.apk` built 2026-08-22** |

### Sprint 12 — Beta Completion ✅ (2026-08-22)
| # | UX deliverable |
|---|----------------|
| 1 | **Real unread badges** — `NavBadgesCubit` wires Alerts count + Messages/Handoffs dots |
| 2 | **Home dashboard** — search shortcut, unread alerts chip, welcome + QR join |
| 3 | **Global search** — skeleton loading, empty states, result semantics |
| 4 | **Profile cards** — clinical member sheet + Message from member list |
| 5 | **Invite experience** — copy code button, clearer share guidance |
| 6 | **Onboarding** — profile setup context; Home welcome empty state |
| 7 | **Navigation polish** — animated badges, screen-reader labels |
| 8 | **Empty states** — `AppEmptyState.compact` variant |
| 9 | **Loading skeletons** — search, notification settings |
| 10 | **Animations** — nav badge/dot `AnimatedSwitcher` |
| 11 | **Settings** — Profile sections; notification settings grouped |
| 12 | **Accessibility** — nav + search semantics |
| 13 | **Performance** — chat `cacheExtent` |
| 14 | **Screen polish** — messages hub unread on every row |

**Quality gate:** `flutter analyze --no-fatal-infos` (0 errors) · release APK `D:\MedCollab\vocle-beta.apk`

### Sprint 11 (shipped)
- Onboarding / empty states, Help & FAQ, Report bug, Feature request, Contact team
- DM privacy (shared spaces / institution only)
- FCM + alert suppression while user is in active chat room
- Developer Mode (Profile long-press → PIN `2468`)

### Sprint 11b — Round 1 (commit `59da551`, on Railway `master`)
| # | Fix |
|---|-----|
| 1 | Pin messages — any DM/space member (was admin-only) |
| 2 | Long-press Reply in thread + Forward (system share); swipe-to-reply |
| 3 | One emoji reaction per user (replace, not stack) |
| 4 | Attach button beside Send |
| 5 | Thread replies in DMs |
| 6 | Official email + Instagram in Contact |
| 7 | Join QR — camera/photo scan (zxing2; no `mobile_scanner` — Kotlin break) |
| 8 | Avatar crop before upload; tap avatar → view profile → change photo |

### Sprint 11b — Round 2 (local only — **commit + push needed**)
| # | Fix |
|---|-----|
| 1 | Emergency **alerts** fade after read (not chat bubbles) |
| 2 | Admin long-press remove member from group |
| 3 | Removed “Your status” picker from member list |
| 4 | In OT status → blue (not grey/offline) |
| 5 | Double back-swipe to exit app on root tabs |
| 6 | Toggle **Read receipts (Seen by)** in notification settings |
| 7 | DM Seen-by uses real names (backend populates `readBy.userId`) |
| 8 | PDF open in-chat (`open_filex` + temp download + filename) |
| 9 | Pin marker on bubble (removed broken top bar); menu → pinned list → jump |
| 10 | Tap channel title → channel/space details sheet |

### Sprint 11b — Round 3 regressions (local only)
| # | Fix |
|---|-----|
| 1 | **Emergency badge on every #emergency message** — removed per-message Emergency label (channel auto-sets `priority: emergency` on all messages server-side) |
| 2 | **Pin not visible / not sticking** — optimistic pin state, robust ID parsing, backend returns `pinnedMessages` on pin/unpin |

---

## 3. Features delivered (summary)

Home workspace, Messages (+ DMs + threads), Handoffs, Alerts, Profile, spaces/channels, media/PDF, mentions, read receipts (DM, optional), invites + QR join, search, FCM push, reactions, pins, member admin remove, Vocle clinical UI, support + onboarding polish.

---

## 4. Deploy / git gap (important for Claude)

| Item | Status |
|------|--------|
| Flutter changes (rounds 2–3) | **Uncommitted** on `design/clinical-design-system` |
| Backend round 2 (`readReceiptsEnabled`, PDF attachment URL, DM readBy populate) | **Uncommitted** |
| Backend round 3 (pin returns `pinnedMessages`) | **Uncommitted** |
| Railway `master` | Likely at `59da551` — **needs push** for rounds 2–3 backend |
| GitLab `origin` | Same branch; push when ready |

**Before next beta test:** commit all, `git push origin design/clinical-design-system`, `git push github HEAD:master`, rebuild `vocle-beta.apk`, verify `/health`.

---

## 5. Known limitations / open items

| Item | Notes |
|------|--------|
| Tab unread badges | ✅ Wired via `NavBadgesCubit` + notification inbox |
| Pin jump-to-message | Approximate scroll; older pins may need “load more” |
| PDFs uploaded before Cloudinary fix | Old URLs may still have random filenames |
| `#emergency` channel | All messages get emergency **priority** for notifications — UI no longer tags each bubble |
| QR scan | Photo/camera decode only (no live continuous scanner — avoids Kotlin/ML Kit build break) |
| Forward | System share of text only (no multi-chat forward picker) |
| Bookmarks / Home layout | Device-local |
| iOS / APNs | Not configured |
| App id | `com.example.medcollab_app` |
| Play Store | Not started |

---

## 6. Suggested Sprint 13+ (for Claude planning)

**Ship & stabilize (P0)**
1. Commit + push all local work; Railway redeploy; distribute fresh `vocle-beta.apk`  
2. Beta validation: unread badges, invite flow, member Message, search  

**Product (P1)**
3. Dedicated channel unread API (optional — today uses notification counts)  
4. Pin scroll-to-message with exact positioning  
5. Handoff completed/missed + expiry  
6. Shift/roster API  

**Growth (P2)**
7. Play Store prep · iOS / APNs when Android beta stable  

---

## 7. Install

```text
adb install -r D:\MedCollab\vocle-beta.apk
```

Developer Mode: Profile → long-press **Vocle beta** → PIN `2468` (debug or `ENABLE_DEV_TOOLS=true`).

---

## 8. Doc index

| File | Purpose |
|------|---------|
| `PROJECT_LEAD_SUMMARY.md` | This file — lead + Claude planning |
| `AI_HANDOFF.md` | Technical handoff |
| `medcollab-app/PROJECT_STATE.md` | App live status |
| `medcollab-app/TASKS.md` | Task tracker |
| `PUSH_NOTIFICATIONS.md` | FCM setup |
| `DEPLOYMENT.md` | Deploy guide |
| `medcollab-app/scripts/build-release-apk.ps1` | Release APK → `vocle-beta.apk` |

---

## 9. Claude prompt starter (copy-paste)

> You are continuing Vocle/MedCollab beta. Read `PROJECT_LEAD_SUMMARY.md`, `AI_HANDOFF.md`, and `medcollab-app/PROJECT_STATE.md`. Production API: https://medcollab.up.railway.app. Latest APK: `vocle-beta.apk` (Sprint 12). Branch `design/clinical-design-system` has uncommitted Sprint 11b + 12 work. Railway may still be at commit `59da551`. Priorities: (1) commit/push/deploy backend, (2) beta doctor validation, (3) Sprint 13 roster/handoff lifecycle. Do not force-push `master`.
