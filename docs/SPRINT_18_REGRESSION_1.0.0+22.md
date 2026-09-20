# Sprint 18 — Handoff write-back, group DM, Needl (1.0.0+22)

**Date:** 2026-09-21  
**Goal:** Make handoffs two-way; Slack-style multi-person DMs; Needl thread inbox.

## Shipped

| Feature | Detail |
|---------|--------|
| Handoff write-back | `POST /handoffs/:id/notes` — note / can’t cover / covered late |
| Handoff reassign | `POST /handoffs/:id/reassign` — pick group member, resets to submitted |
| Group DM | `POST /channels/dm/group` + rename via `PUT /channels/:id` |
| Start DM multi-select | Checkbox peers → Create group DM |
| Needl hub | Messages tabs: **Direct · Needl · Groups**; `GET /users/me/needl` |

## Automated gate

| Check | Result |
|-------|--------|
| `flutter test` | ✅ 33 passed |
| Analyze (touched) | ✅ info/warning only |
| Push | ✅ |
| APK | ✅ `Vocle-beta.apk` 1.0.0+22 |

## Device smoke

- [ ] Add write-back note on pending handoff; reassign to another group member
- [ ] Multi-select 2+ doctors → Create group DM; rename from chat if wired later
- [ ] Needl tab lists threads after a channel reply
