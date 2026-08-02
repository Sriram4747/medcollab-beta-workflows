# Vocle — Architect Handoff (2026-07-26)

**Product:** Vocle (clinical collaboration for Indian hospital doctors)  
**Repos:** GitLab `mathiharan-project/MedCollab` · GitHub Railway `mathiharan29/medcollab-beta`  
**API:** https://medcollab.up.railway.app  
**Status:** Beta live · Solo QA cycle in progress · **Next target = UI/UX redesign from design comps**

---

## What Vocle is

Slack-like clinical messaging for MBBS interns / PG residents / junior consultants. Differentiator: **structured handoffs**, space-scoped privacy (group → subgroup), not a public social network.

Core mental model (WhatsApp-simple parents):

| Parent | Meaning |
|--------|---------|
| **Home** | Daily clinical glance (shift, handoffs, emergency, lean actions) |
| **Messages** | Groups + Direct |
| **Handoffs** | Secure patient shift transfer |
| **Profile / Alerts** | Self + notifications |

Hierarchy language (shipping):

- **Group** = Space (hospital / department / college team)
- **Subgroup** = Channel (`#general`, `#emergency`, custom)

---

## Solo QA — what passed

| # | Item | Result |
|---|------|--------|
| 1 | Login / red “Validation failed” | Fixed (Sprint 8 backend on Railway + resilient Home) |
| 4 | DM list load | Works |
| 5 | Group-first Messages | Works |
| 6 | Emergency | Works |
| 9 | Mark notification unread | Works |
| 10 | Draft restore in composer | Works |
| 11 | New message → DM | Works |
| 13 | Handoff after group pick | Works |

## Solo QA — fixed in this engineering pass (await new APK)

| # | Issue | Fix |
|---|-------|-----|
| 2 | Random group name under greeting (“PG Preps”) | Removed; greeting shows doctor name only |
| 3 | Home too crowded (patient discussions, recent DMs) | Hidden by default (`dashboard_widgets_v2`); tune sheet can re-enable |
| 5 | No create subgroup inside a group | `+` / FAB on Group → subgroups screen; dialog copy = “Create subgroup” |
| 7 | Discovery leaking outside user’s groups | User search + global search doctors **scoped to shared groups only** (backend) |
| 8 | Global search buffer / dim / keyboard | ValueNotifier-based results; 550ms debounce; keep prior results; field no longer rebuilds with results |
| 10 | Draft badge late | Flush draft on Back; refresh draft set when returning to subgroup list |
| 12 | Tap DM peer name | Popup profile card (role, availability, speciality, institution, bio) — no screen change |

## Intentionally deferred (user-owned)

| Item | Notes |
|------|-------|
| **Full Home / shell UI redesign** | User will produce comps in a design app and return with pics + UX notes — **next sprint target** |
| Multi-user realtime chat / handoffs / invites | Await friends for next QA cycle |
| FCM phone push | Critical for hospital; not configured (Firebase) — prioritize after redesign or in parallel |
| Announcements / shift roster | Today’s shift is derived from handoffs; announcements need `#announcements` channels |

---

## Architecture constraints (do not break)

- Feature folders (Flutter + Node)
- API envelope `{ success, message, data }`
- REST persists messages; Socket.io broadcasts after save
- `OTP_BYPASS` blocked in production; beta login = MSG91 widget SDK
- Railway root = `medcollab-backend/`
- Privacy: users should only discover / DM people who share a **Group**

---

## Current IA (pre-redesign)

```
Home (lean widgets)
Messages
  ├─ Groups → [Group] → Subgroups (+ create) → Chat
  └─ Direct → DM chat (tap title → peer card)
Handoffs (my handoffs only)
Notifications
Profile / Spaces browse (join-invite)
Search (scoped)
```

Quick actions kept to: **New handoff · New message · Open groups** (+ Emergency widget).

---

## Branding

- Display name: **Vocle**
- Launcher: `assets/branding/vocle_icon.jpeg` (from `Logo/Just image.jpeg`)
- Splash / auth: `assets/branding/vocle_full_logo.jpeg`
- Internal package id still `medcollab_app` (do not rename casually)

---

## Deploy state

- Sprint 8 backend (DM list, search, invite preview, mark-unread) **pushed to GitHub `master`** for Railway
- Further privacy scoping (user search) must be **redeployed** with this handoff’s backend commits
- Release APK path: `D:\MedCollab\MedCollab-beta.apk` (rebuild after these fixes)

---

## Ask for the architect + designer (next target)

Please return:

1. **Wireframes / screenshots** for: Home, Messages (Group → Subgroup), DM, Handoff create, Profile  
2. **Color tokens** (primary, surfaces, emergency) — Vocle blue/teal from logo is preferred direction  
3. **Typography** choices (clinical, high-legibility; avoid generic Inter-default look if possible)  
4. **Which 3–4 root tabs** stay permanent (confirm or adjust)  
5. Explicit **do-not-show** list for Home (we already hide discussions/DMs/announcements by default)  
6. Any rename map: Space→Group, Channel→Subgroup consistency in all copy  
7. Empty states + emergency confirmation UX if changing  

Engineering will implement from those comps without redesigning product scope.

---

## Suggested verification after next APK

1. Home: name only under greeting; no PG Preps line; no recent discussions/DMs unless tuned on  
2. Messages → Group → `+` creates subgroup  
3. Global Search: type freely; no keyboard death / heavy dim flash  
4. Write draft → Back once → draft badge on subgroup row immediately  
5. DM: tap peer name → profile popup  
6. New message search: only colleagues who share a group with you  

---

*Prepared for Claude architect share-out. Next cycle: UI redesign intake → implement → multi-user QA → FCM.*
