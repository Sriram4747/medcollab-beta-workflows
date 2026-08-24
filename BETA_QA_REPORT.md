# Vocle Beta QA Report — Sprint 13

**Date:** 2026-08-24  
**Audited:** 166 Flutter files (`medcollab-app/lib/`) + 55 backend files (`medcollab-backend/src/`)

---

## Critical Issues Fixed

### Backend

| # | Severity | File | Issue | Fix |
|---|----------|------|-------|-----|
| 1 | **Critical** | `src/socket/index.js` | Socket listener accumulation on `connectionStateRecovery` — handlers re-registered on recovered connections causing duplicate events | Guard with `socket.recovered` flag |
| 2 | **Critical** | `src/features/channels/channel.controller.js` | DM creation TOCTOU race — two concurrent `createOrGetDM` calls create duplicate channels | Replaced find+create with atomic `findOneAndUpdate` + upsert |
| 3 | **High** | `src/features/messages/message.controller.js` | Unvalidated `content.mediaUrl` — any URL accepted, enabling injection | Added domain allowlist validation (Cloudinary only) |

### Flutter

| # | Severity | File | Issue | Fix |
|---|----------|------|-------|-----|
| 4 | **High** | `channel_chat_page.dart` | `Image.network` without caching in media grid (2 instances) — re-downloads on scroll | Replaced with `CachedNetworkImage` |
| 5 | **High** | `push_notification_router.dart` | No deduplication on rapid notification taps — routes stack | Added 1-second same-route dedup guard |
| 6 | **High** | `channel_chat_page.dart` | `_loadChannelContext` fires 3 sequential API calls | Parallelized members + detail fetch |
| 7 | **Medium** | Multiple ListView instances | No item keys — incorrect widget reuse on insert/delete | Added `ValueKey`s to GroupRow, SubgroupRow, DMRow, media grid |
| 8 | **Medium** | `spaces_home_page.dart` | `TextEditingController` in dialogs never disposed | Added `dispose()` after dialog closes |
| 9 | **Low** | `bookmarks_page.dart` | No loading/error state in FutureBuilder | Added ConnectionState.waiting + error handling |
| 10 | **Low** | `app_nav_bar.dart` | Semantics double-announcing child widgets | Added `excludeSemantics: true` |

---

## Known Issues (Low Priority — Not Fixed)

### Accessibility
- Only 4 files use `Semantics` across 166 dart files. Full a11y pass deferred to post-beta.

### Code Quality
- `VocleColors` class duplicates `AppColors` tokens (used in 3 files) — consolidate post-beta.
- 17 compatibility aliases in `AppColors` with no deprecation markers.
- Repeated `if (!mounted) return` pattern across 30+ locations — extract to mixin post-beta.
- Dialog `TextEditingController` creation pattern repeated in 6 places — extract utility post-beta.

### Backend
- Dev-mode endpoints (`/health/debug`) accessible if `NODE_ENV` misconfigured — acceptable for beta with Railway env lock.
- `joinSpace` has no idempotency guard (duplicate join attempts return error, not conflict).

---

## Summary

| Category | Critical | High | Medium | Low | Total |
|----------|----------|------|--------|-----|-------|
| Fixed | 2 | 4 | 2 | 2 | **10** |
| Deferred | 0 | 0 | 2 | 6 | 8 |

**Verdict:** Beta is stable for the 15-doctor pilot. Critical socket and race condition bugs are resolved. Performance improved with image caching and parallel API calls.
