# Lunch-break fix pack — regression notes (1.0.0+20)

**Date:** 2026-09-20  
**Commit target:** GitHub `master` → Railway  

## Fixes

| # | Issue | Fix |
|---|--------|-----|
| 1 | Bgless PNG pixels on splash / OTP / install surfaces | Branding uses opaque `vocle_full_logo.jpeg` / `vocle_icon.jpeg`; launcher icons regenerated from opaque asset |
| 2 | OTP auto-read from SMS | `AutofillGroup` + `AutofillHints.oneTimeCode` catcher + first-box autofill |
| 3 | Pending handoff still “Not attended” after ack | Home pending list = **submitted only**; overdue CTA = “Mark as attended” |
| 4–6 | DM privacy / lookup / spinner / profile | Open DM only after accept or existing DM; mutual group → **request** (not free DM); toggle allows strangers to request; lookup clears busy spinner; tap profile card |
| 7 | Thread reply count ×2 / empty thread | Socket channel+user fan-out deduped; thread reload after send; threadId query tolerant |
| 8 | Edit profile → home with Profile tab lit | `/profile/*` treated as authenticated route |

## Automated gate

| Check | Result |
|-------|--------|
| `flutter analyze --no-fatal-infos` (changed pkgs) | ✅ pass (info-only: prefer_const / trailing commas) |
| `flutter test` | ✅ **33 passed** |
| Release APK `Vocle-beta.apk` (1.0.0+20) | ✅ built |
| Push GitLab `origin/master` + GitHub `github/master` | ✅ `79ff755` |
| `GET /health` after deploy | ⏳ pre-redeploy still up (Railway will pick up `79ff755`) |

## Device smoke (after APK)

- [ ] Splash / OTP logo: no checkerboard pixels  
- [ ] OTP SMS suggestion fills digits (Android)  
- [ ] Ack handoff → leaves Home pending list  
- [ ] Phone lookup stranger + toggle off → Requests closed + profile tap works, no infinite spinner  
- [ ] Toggle on → Send request visible with name  
- [ ] Shared group colleague → Send request (not instant Message) until accept  
- [ ] Thread reply count +1; replies visible immediately  
- [ ] Edit profile stays on edit screen / returns to Profile tab correctly  
