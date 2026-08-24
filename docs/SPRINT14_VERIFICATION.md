# Sprint 14 — Production / FCM / Analytics Verification

**Date:** 2026-08-24  
**Release engineer:** closed-beta prep  

## Production API

| Check | Result |
|-------|--------|
| `GET https://medcollab.up.railway.app/` | ✅ `status: online` |
| `GET https://medcollab.up.railway.app/health` | ✅ `status: ok`, `environment: production`, `database: connected` |
| Uptime at check | ~15.7 days (`1356192s`) |

**Note:** Sprint 14 adds `firebase`, `cloudinary`, and `analytics` fields to `/health`. Those appear only after deploying `medcollab-backend` to GitHub `master` → Railway. Until then, FCM readiness is confirmed via Railway logs (`Firebase Admin connected`) and prior two-phone QA documented in `PUSH_NOTIFICATIONS.md`.

## FCM

| Check | Result |
|-------|--------|
| Prior production QA (app killed → banner) | ✅ Documented live |
| Client FCM module present | ✅ `FcmService` + `google-services.json` (local) |
| Deep-link router with tap dedupe | ✅ Sprint 13 |
| Dev Mode shows FCM ready after login | ✅ Surface added Sprint 14 |

**Pilot action:** On each new physical device — Allow notifications; send a DM from a second phone while Vocle is backgrounded.

## Analytics

| Check | Result |
|-------|--------|
| Third-party analytics SDK in Flutter | ✅ None (by policy) |
| `AnalyticsPolicy.thirdPartyEnabled` | `false` |
| Privacy Policy discloses no ad/analytics SDKs | ✅ |
| `/health` `analytics: "none"` | Pending Railway deploy of Sprint 14 backend |

## Legal / support in APK

Privacy, Terms, FAQ, Feedback, Bug report, Feature request, Contact — shipped in app version `1.0.0+14`.
