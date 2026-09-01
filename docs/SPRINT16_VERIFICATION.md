# Sprint 16 — DM by phone & DM-first UX (2026-08-31)

## Issues addressed (doctor beta feedback #4, #14)

| # | Feedback | Fix |
|---|----------|-----|
| 4 | Cannot DM by phone; strangers need approval | `GET /api/users/lookup?phone=`, message-request API, accept → DM |
| 14 | DMs should be central | Messages tab **Direct first**; pending requests at top of Direct tab |

## Backend

- `MessageRequest` model + `/api/message-requests`
- `canMessageUser` allows accepted requests
- `GET /api/users/lookup?phone=` (E.164 or 10-digit)

## App version

`1.0.0+17`

## Verify

- [ ] New message → enter colleague's 10-digit number → found on Vocle
- [ ] Stranger → Send request → recipient sees in Messages → Direct → Message requests
- [ ] Accept → opens DM chat
- [ ] Known colleague (shared group) → Message directly, no request
- [ ] Messages tab opens on **Direct** by default

## Deploy

Push **backend** to GitHub `master` → Railway before phone lookup works in production.
