# Vocle Closed Beta Checklist

**Version:** 1.0.0 (14) · **Date:** 2026-08-24  
**APK:** `D:\MedCollab\vocle-beta.apk`  
**API:** https://medcollab.up.railway.app  

Use this before inviting doctors. Check each box when verified.

---

## A. Build & versioning

- [ ] `pubspec.yaml` is `1.0.0+14`
- [ ] Profile footer shows `Vocle closed beta 1.0.0 (14)`
- [ ] Release APK built with production dart-defines (Railway API + MSG91 widget)
- [ ] APK copied to repo root as `vocle-beta.apk`
- [ ] Launcher / splash use transparent `vocle_logo.png` (from `Logo_bgless.png`)

## B. Legal & support surfaces

- [ ] Sign-in shows Terms + Privacy Policy links
- [ ] Profile → Legal → Privacy policy opens full text
- [ ] Profile → Legal → Terms of use opens full text
- [ ] Help & FAQ covers join, DM, handoff, OTP, notifications, privacy
- [ ] Send feedback submits (or offline-saves) without patient IDs
- [ ] Report a bug works
- [ ] Feature request works
- [ ] Contact team shows `vocle.official@gmail.com` + Instagram

## C. Production verification

- [ ] `GET /` returns API online JSON
- [ ] `GET /health` returns `status: ok`, `database: connected`
- [ ] After backend deploy: `/health` includes `firebase: true`, `cloudinary: true`, `analytics: "none"`
- [ ] OTP_BYPASS is **false** in Railway (server refuses true in production)
- [ ] Cloudinary uploads succeed (image + PDF)
- [ ] MSG91 widget OTP delivers on a physical Indian SIM

## D. FCM verification

- [ ] Railway logs show `Firebase Admin connected` (post-deploy)
- [ ] Fresh install prompts notification permission
- [ ] Developer Mode → FCM client shows `ready` after login
- [ ] Phone A → Phone B: message banner while B is backgrounded / killed
- [ ] Mention / handoff / emergency push deep-link opens the right screen
- [ ] No banner while the recipient has that chat open

## E. Analytics verification

- [ ] No Firebase Analytics / Mixpanel / Amplitude dependency in `pubspec.yaml`
- [ ] `AnalyticsPolicy.thirdPartyEnabled == false`
- [ ] Developer Mode shows analytics disabled
- [ ] `/health` reports `analytics: "none"` (after Sprint 14 backend deploy)
- [ ] Privacy Policy states no third-party ad/analytics SDKs

## F. Core doctor flows (smoke)

- [ ] Sign in with OTP
- [ ] Complete profile if first launch
- [ ] Join group via code and via QR
- [ ] Send group message + image + PDF
- [ ] **3 phones on same Wi‑Fi:** group chat 5 min — no 429 / “too many requests from this IP”
- [ ] **Swipe back** from My Groups / create group — returns to previous screen (double-back only exits from shell tabs)
- [ ] Start DM with a shared-group colleague
- [ ] Create handoff → acknowledge → resolve
- [ ] Search finds a recent message
- [ ] Bookmark + open from Bookmarks
- [ ] Alerts tab unread count updates
- [ ] Sign out and sign back in

## G. Distribution

- [ ] `RELEASE_NOTES.md` shared with pilot doctors
- [ ] Invite list (~15) confirmed
- [ ] Support email monitored during first 48 hours
- [ ] Backend Sprint 14 changes pushed to GitHub `master` → Railway
- [ ] Rollback plan: previous APK + note Railway commit

## H. Stop criteria (Release Engineer)

When A–G are complete (or waivers documented), closed beta may begin.  
**STOP** further feature work until pilot feedback is triaged.
