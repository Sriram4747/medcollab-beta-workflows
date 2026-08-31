# Sprint 15A — First doctor beta hotfixes (2026-08-31)

## Issues addressed

| # | Feedback | Fix |
|---|----------|-----|
| 1 | 3 users on same network → “too many requests from this IP”, messages fail | API rate limit keys **authenticated** traffic by JWT `userId` (not shared IP); default max raised to **600 / 15 min** |
| 2–3 | Swipe back while creating group closes entire app | Central [`AppNavigationBackHandler`](../medcollab-app/lib/core/router/app_navigation_back_handler.dart): pop stack when possible; double-back-to-exit only on shell tabs |
| 5 | Splash logo shows transparent pixel blocks | White card behind logo on splash only |
| 11 | (likely) latency under load | Same as #1 — throttled requests felt like slowness |

## Deploy

1. Push **backend** `rateLimiter.js` to GitHub `master` → Railway (required for #1 in production).
2. Rebuild APK for back + splash fixes.

## Verify

- [ ] 3 phones, same Wi‑Fi, active group chat 5+ minutes
- [ ] Profile → My Groups → back returns to Profile
- [ ] Home tab: swipe back twice within 2s exits app
