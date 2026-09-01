# Vocle Beta Test Plan — Tonight (2026-08-31)

**Build:** `1.0.0+18` · **APK:** `D:\MedCollab\vocle-beta.apk`  
**API:** https://medcollab.up.railway.app  
**Pilot feedback source:** Ranjith (first closed-beta session) + Sprints 15A–17 fixes

---

## Before you start (blockers)

| Step | Who | Done? |
|------|-----|-------|
| **Backend deployed to Railway** — push `medcollab-backend` Sprint 15A–16 changes to **GitHub `master`** (GitLab commit alone does **not** deploy) | Dev | ☐ |
| Confirm `/health` OK: `curl https://medcollab.up.railway.app/health` | Dev | ☐ |
| Install fresh APK `vocle-beta.apk` on **3 Android phones** (uninstall old build first) | Testers | ☐ |
| All 3 phones on **same Wi‑Fi** (reproduces hospital NAT scenario) | Testers | ☐ |
| Profile footer shows **`1.0.0 (18)`** | Testers | ☐ |
| 3 test accounts onboarded (intern, PG resident, consultant roles if possible) | Testers | ☐ |

**If backend is not deployed:** tests **P0-1**, **P0-2**, and **P1-4** (phone DM) will fail or behave like the old build.

---

## Test team

| Role | Name | Phone |
|------|------|-------|
| Tester A | | |
| Tester B | | |
| Tester C | | |
| Note-taker | | |

---

## P0 — Must pass (trust / blockers)

These map directly to Ranjith’s first-session failures.

### P0-1 · Three-user group chat (same Wi‑Fi) — Feedback #1, #11

**Goal:** No “too many requests from this IP” and messages stay timely for 5+ minutes.

| # | Step | Expected | A | B | C |
|---|------|----------|---|---|---|
| 1 | All 3 join the **same group** channel | All see each other | ☐ | ☐ | ☐ |
| 2 | A sends 10 text messages quickly | B and C receive all | ☐ | ☐ | ☐ |
| 3 | All 3 alternate sending for **5 minutes** | No 429 errors, no long stalls | ☐ | ☐ | ☐ |
| 4 | B sends an **image** while chat is active | A and C receive it | ☐ | ☐ | ☐ |
| 5 | Kill app on C, send from A, reopen C | Push or inbox shows message | ☐ | ☐ | ☐ |

**Pass criteria:** Zero rate-limit errors; latency feels “normal WhatsApp-like” (not 30s+ delays).

**Fail notes:** _______________________________________________

---

### P0-2 · Back gesture / swipe back — Feedback #2, #3

| # | Step | Expected | Pass? |
|---|------|----------|-------|
| 1 | Profile → **My Groups** → swipe/back | Returns to Profile (app stays open) | ☐ |
| 2 | My Groups → open a group → back | Returns to group list | ☐ |
| 3 | Create group flow → back mid-flow | Returns to previous screen, not exit app | ☐ |
| 4 | On **Home** tab only: back twice within 2s | App exits (double-back-to-exit) | ☐ |

**Fail notes:** _______________________________________________

---

### P0-3 · Sign-in & splash — Feedback #5

| # | Step | Expected | Pass? |
|---|------|----------|-------|
| 1 | Cold start app | Splash logo on **white card**, no checkerboard pixels | ☐ |
| 2 | OTP sign-in with real SIM | SMS received, login succeeds | ☐ |

---

## P1 — Sprint 15B profile (Feedback #7–10)

### P1-1 · Onboarding (new account or clear data)

| # | Step | Expected | Pass? |
|---|------|----------|-------|
| 1 | Role = **MBBS Intern** | Speciality **not required**; optional NEET PG subject shown | ☐ |
| 2 | Role = **PG Resident** | Speciality dropdown **required** (19 NEET subjects) | ☐ |
| 3 | Institution field | Tamil Nadu college **autocomplete** suggests matches | ☐ |
| 4 | Complete setup | Lands in Home | ☐ |

### P1-2 · Edit profile

| # | Step | Expected | Pass? |
|---|------|----------|-------|
| 1 | Profile → **Edit profile** | Form opens with current data | ☐ |
| 2 | Change role intern → PG resident, pick speciality, save | Header/role line updates | ☐ |

---

## P1 — Sprint 16 DM (Feedback #4, #14)

**Requires backend deploy (lookup + message-requests APIs).**

### P1-3 · DM-first UX

| # | Step | Expected | Pass? |
|---|------|----------|-------|
| 1 | Open **Messages** tab | **Direct** tab is first (left) | ☐ |
| 2 | Direct tab default view | DMs or empty state with **New message** | ☐ |

### P1-4 · Phone lookup & message requests

Setup: Tester A and B share **no group** and are **not** same institution (or use a 4th account).

| # | Step | Expected | Pass? |
|---|------|----------|-------|
| 1 | A → Messages → New message → enter B’s **10-digit mobile** | B’s profile found on Vocle | ☐ |
| 2 | A taps **Send request** | Success snackbar; status “Request pending” | ☐ |
| 3 | B → Messages → Direct | **Message requests** section shows A | ☐ |
| 4 | B taps **Accept** | DM chat opens | ☐ |
| 5 | A sends a message | B receives it | ☐ |
| 6 | A searches **known colleague** (shared group) by name | **Message** directly, no request | ☐ |

**Fail notes:** _______________________________________________

---

## P1 — Sprint 17 (Feedback #6, #13)

### P1-5 · Live QR join

| # | Step | Expected | Pass? |
|---|------|----------|-------|
| 1 | Group admin opens invite QR | QR visible | ☐ |
| 2 | New user: Join → **Scan invite QR** | Live camera preview appears | ☐ |
| 3 | Point at QR (no manual photo tap) | Auto-detects and joins group | ☐ |
| 4 | Fallback: **From photo** (screenshot) | Still works | ☐ |
| 5 | Fallback: type invite code manually | Still works | ☐ |

### P1-6 · Handoff repositioning — Feedback #6

| # | Step | Expected | Pass? |
|---|------|----------|-------|
| 1 | Create handoff | Banner explains **critical/cross-cover only**, not full ward list | ☐ |
| 2 | Shift note field | Hint text for quick handover (e.g. ward + bed) | ☐ |
| 3 | Help & FAQ → handoffs | Copy matches narrow use case | ☐ |
| 4 | Create handoff with 1–2 **critical** patients | Submit → assignee acknowledges | ☐ |

**Discussion (not pass/fail):** Is this the right mental model vs 60-patient notebook?  
Notes: _______________________________________________

---

## P2 — Regression smoke (15 min)

Quick checks so nothing else broke.

| # | Flow | Pass? |
|---|------|-------|
| 1 | Group message + PDF attachment | ☐ |
| 2 | Thread reply on a message | ☐ |
| 3 | Handoff create → acknowledge | ☐ |
| 4 | Global search finds a message | ☐ |
| 5 | Bookmark → open from Bookmarks | ☐ |
| 6 | Alerts tab unread badge | ☐ |
| 7 | Profile → Privacy / Terms open | ☐ |
| 8 | Send feedback (no patient IDs) | ☐ |
| 9 | Sign out → sign back in | ☐ |

---

## Stop / go for wider pilot

**GO** if all **P0** pass and **P1** has no more than 1 waived item documented.  
**STOP** and fix if P0-1 or P0-2 fail again.

| Decision | Date | Sign-off |
|----------|------|----------|
| ☐ GO — share APK with full pilot list | | |
| ☐ NO-GO — file bugs below | | |

---

## Bug log (tonight)

| ID | Severity | Test | Steps | Expected | Actual | Device |
|----|----------|------|-------|----------|--------|--------|
| 1 | | | | | | |
| 2 | | | | | | |
| 3 | | | | | | |

---

## Deploy reminder (for dev, not testers)

```powershell
# 1. Push backend to Railway (from repo root)
git push github design/clinical-design-system:master
# OR merge to master on GitHub first, then push master

# 2. Watch Railway redeploy (~2 min)
curl https://medcollab.up.railway.app/health

# 3. APK already at D:\MedCollab\vocle-beta.apk after build
adb install -r D:\MedCollab\vocle-beta.apk
```

**Commits on GitLab `design/clinical-design-system` do not trigger Railway** — only GitHub `master` does.

---

## Related docs

- [`BETA_CHECKLIST.md`](../BETA_CHECKLIST.md) — full closed-beta gate
- [`docs/SPRINT15A_VERIFICATION.md`](SPRINT15A_VERIFICATION.md) — rate limit, back nav
- [`docs/SPRINT15B_VERIFICATION.md`](SPRINT15B_VERIFICATION.md) — profile UX
- [`docs/SPRINT16_VERIFICATION.md`](SPRINT16_VERIFICATION.md) — phone DM
- [`docs/SPRINT17_VERIFICATION.md`](SPRINT17_VERIFICATION.md) — live QR, handoffs
- Excel suite: `Test suite/Vocle_Beta_test.xlsx` (optional detailed cases)
