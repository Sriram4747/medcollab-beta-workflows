# Vocle API Coverage Report

This generated inventory is derived from the Express route files and their mounts in `src/app.js`. It shows the security-suite run status for every currently discovered HTTP API. `NOT YET EXERCISED` means the endpoint is known but has not been tested by the current deterministic suite; it does not imply the endpoint is safe or unsafe.

## Run summary

- APIs discovered: 77
- API method/path combinations exercised by the discovery suite: 66
- Discovery cases executed: 579/579
- Discovery cases passed: 528
- Discovery observations: 51
- Discovery infrastructure status: healthy

## API inventory by feature

### Authentication

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| POST | `/api/auth/logout` | EXERCISED — 4 pass (Phase 1 Authentication and Session Lifecycle: 4) | `src/features/auth/auth.routes.js` |
| POST | `/api/auth/refresh` | EXERCISED — 8 pass (Phase 1 Authentication and Session Lifecycle: 8) | `src/features/auth/auth.routes.js` |
| POST | `/api/auth/request-otp` | EXERCISED — 5 pass (Phase 1 Authentication and Session Lifecycle: 5) | `src/features/auth/auth.routes.js` |
| POST | `/api/auth/verify-msg91-token` | EXERCISED — 3 pass, 2 observation (Phase 1 Authentication and Session Lifecycle: 5) | `src/features/auth/auth.routes.js` |
| POST | `/api/auth/verify-otp` | EXERCISED — 9 pass (Phase 1 Authentication and Session Lifecycle: 9) | `src/features/auth/auth.routes.js` |

### Channel Messages

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/channels/:channelId/messages` | EXERCISED — 17 pass (Baseline group, space, and handoff security: 9; Direct Messages: 5; Extended API: 1; Phase 3 Space Lifecycle: 2) | `src/features/messages/message.routes.js` |
| POST | `/api/channels/:channelId/messages` | EXERCISED — 34 pass, 3 observation (Baseline group, space, and handoff security: 20; Direct Messages: 5; Cross-module: 4; Media: 8) | `src/features/messages/message.routes.js` |
| DELETE | `/api/channels/:channelId/messages/:id` | EXERCISED — 16 pass (Baseline group, space, and handoff security: 10; Direct Messages: 6) | `src/features/messages/message.routes.js` |
| PUT | `/api/channels/:channelId/messages/:id` | EXERCISED — 24 pass, 2 observation (Baseline group, space, and handoff security: 20; Direct Messages: 6) | `src/features/messages/message.routes.js` |
| POST | `/api/channels/:channelId/messages/:id/react` | NOT YET EXERCISED | `src/features/messages/message.routes.js` |
| POST | `/api/channels/:channelId/messages/:id/reply` | EXERCISED — 2 pass, 4 observation (Baseline group, space, and handoff security: 2; Direct Messages: 4) | `src/features/messages/message.routes.js` |
| GET | `/api/channels/:channelId/messages/:id/thread` | EXERCISED — 9 pass (Baseline group, space, and handoff security: 3; Direct Messages: 6) | `src/features/messages/message.routes.js` |
| POST | `/api/channels/:channelId/messages/read` | EXERCISED — 4 pass (Direct Messages: 4) | `src/features/messages/message.routes.js` |

### Channels & Direct Messages

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| DELETE | `/api/channels/:id` | EXERCISED — 4 pass (Extended API: 4) | `src/features/channels/channel.routes.js` |
| GET | `/api/channels/:id` | EXERCISED — 4 pass, 1 observation (Direct Messages: 4; Extended API: 1) | `src/features/channels/channel.routes.js` |
| PUT | `/api/channels/:id` | EXERCISED — 4 pass (Extended API: 4) | `src/features/channels/channel.routes.js` |
| GET | `/api/channels/:id/members` | EXERCISED — 3 pass, 2 observation (Direct Messages: 4; Extended API: 1) | `src/features/channels/channel.routes.js` |
| DELETE | `/api/channels/:id/pin/:messageId` | EXERCISED — 1 pass (Direct Messages: 1) | `src/features/channels/channel.routes.js` |
| POST | `/api/channels/:id/pin/:messageId` | EXERCISED — 3 pass (Direct Messages: 3) | `src/features/channels/channel.routes.js` |
| GET | `/api/channels/dm` | EXERCISED — 4 pass (Direct Messages: 4) | `src/features/channels/channel.routes.js` |
| POST | `/api/channels/dm` | EXERCISED — 10 pass, 2 observation (Direct Messages: 9; Message Requests: 2; Phase 3 Consent and Handoffs: 1) | `src/features/channels/channel.routes.js` |
| POST | `/api/channels/dm/group` | EXERCISED — 12 pass, 3 observation (Phase 3 Consent and Handoffs: 15) | `src/features/channels/channel.routes.js` |

### Development Tools

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| POST | `/api/dev/seed-conversation` | NOT YET EXERCISED | `src/features/dev/dev.routes.js` |
| POST | `/api/dev/seed-handoff` | NOT YET EXERCISED | `src/features/dev/dev.routes.js` |
| POST | `/api/dev/seed-notifications` | NOT YET EXERCISED | `src/features/dev/dev.routes.js` |

### Handoffs

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/handoffs` | EXERCISED — 3 pass, 1 observation (Extended API: 4) | `src/features/handoffs/handoff.routes.js` |
| POST | `/api/handoffs` | EXERCISED — 15 pass, 1 observation (Baseline group, space, and handoff security: 16) | `src/features/handoffs/handoff.routes.js` |
| DELETE | `/api/handoffs/:id` | EXERCISED — 8 pass (Baseline group, space, and handoff security: 8) | `src/features/handoffs/handoff.routes.js` |
| GET | `/api/handoffs/:id` | EXERCISED — 5 pass, 1 observation (Baseline group, space, and handoff security: 5; Extended API: 1) | `src/features/handoffs/handoff.routes.js` |
| PUT | `/api/handoffs/:id` | EXERCISED — 12 pass (Baseline group, space, and handoff security: 8; Cross-module: 4) | `src/features/handoffs/handoff.routes.js` |
| POST | `/api/handoffs/:id/acknowledge` | EXERCISED — 5 pass (Baseline group, space, and handoff security: 5) | `src/features/handoffs/handoff.routes.js` |
| POST | `/api/handoffs/:id/notes` | EXERCISED — 22 pass, 1 observation (Phase 3 Consent and Handoffs: 23) | `src/features/handoffs/handoff.routes.js` |
| POST | `/api/handoffs/:id/reassign` | EXERCISED — 24 pass, 2 observation (Phase 3 Consent and Handoffs: 26) | `src/features/handoffs/handoff.routes.js` |
| POST | `/api/handoffs/:id/submit` | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | `src/features/handoffs/handoff.routes.js` |

### Media

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| DELETE | `/api/media/:publicId` | EXERCISED — 6 pass, 2 observation (Media: 8) | `src/features/media/media.routes.js` |
| POST | `/api/media/upload` | EXERCISED — 9 pass, 6 observation (Media: 15) | `src/features/media/media.routes.js` |

### Message Requests

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/message-requests` | EXERCISED — 6 pass (Message Requests: 6) | `src/features/message-requests/messageRequest.routes.js` |
| POST | `/api/message-requests` | EXERCISED — 19 pass, 1 observation (Message Requests: 17; Phase 0 Repair Controls: 3) | `src/features/message-requests/messageRequest.routes.js` |
| POST | `/api/message-requests/:id/accept` | EXERCISED — 5 pass (Message Requests: 5) | `src/features/message-requests/messageRequest.routes.js` |
| POST | `/api/message-requests/:id/decline` | EXERCISED — 3 pass (Message Requests: 3) | `src/features/message-requests/messageRequest.routes.js` |
| GET | `/api/message-requests/pending-count` | EXERCISED — 3 pass (Message Requests: 3) | `src/features/message-requests/messageRequest.routes.js` |

### Notifications

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/notifications` | EXERCISED — 1 pass (Extended API: 1) | `src/features/notifications/notification.routes.js` |
| DELETE | `/api/notifications/:id` | EXERCISED — 3 pass (Extended API: 3) | `src/features/notifications/notification.routes.js` |
| PUT | `/api/notifications/:id/read` | EXERCISED — 3 pass (Extended API: 3) | `src/features/notifications/notification.routes.js` |
| PUT | `/api/notifications/:id/unread` | EXERCISED — 3 pass (Extended API: 3) | `src/features/notifications/notification.routes.js` |
| PUT | `/api/notifications/read-all` | EXERCISED — 1 pass (Extended API: 1) | `src/features/notifications/notification.routes.js` |
| PUT | `/api/notifications/read-by-channel/:channelId` | EXERCISED — 2 pass (Extended API: 2) | `src/features/notifications/notification.routes.js` |
| GET | `/api/notifications/unread-count` | EXERCISED — 1 pass (Extended API: 1) | `src/features/notifications/notification.routes.js` |

### Platform API

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/` | NOT YET EXERCISED | `src/app.js` |
| GET | `/api` | NOT YET EXERCISED | `src/app.js` |
| GET | `/join/:code` | NOT YET EXERCISED | `src/app.js` |

### Platform Health

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/health` | NOT YET EXERCISED | `src/app.js` |

### Search

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/search` | EXERCISED — 9 pass, 2 observation (Extended API: 11) | `src/features/search/search.routes.js` |

### Space Channels

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/spaces/:spaceId/channels` | EXERCISED — 6 pass (Baseline group, space, and handoff security: 4; Phase 3 Space Lifecycle: 2) | `src/features/channels/channel.routes.js` |
| POST | `/api/spaces/:spaceId/channels` | EXERCISED — 4 pass (Extended API: 4) | `src/features/channels/channel.routes.js` |

### Space Handoffs

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/spaces/:spaceId/handoffs` | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | `src/features/handoffs/handoff.routes.js` |

### Spaces & Membership

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/spaces` | EXERCISED — 6 pass (Baseline group, space, and handoff security: 4; Phase 3 Space Lifecycle: 2) | `src/features/spaces/space.routes.js` |
| POST | `/api/spaces` | EXERCISED — 7 pass (Phase 3 Space Lifecycle: 7) | `src/features/spaces/space.routes.js` |
| GET | `/api/spaces/:id` | EXERCISED — 8 pass (Baseline group, space, and handoff security: 6; Phase 3 Space Lifecycle: 2) | `src/features/spaces/space.routes.js` |
| PUT | `/api/spaces/:id` | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | `src/features/spaces/space.routes.js` |
| POST | `/api/spaces/:id/invite` | EXERCISED — 7 pass (Phase 3 Space Lifecycle: 7) | `src/features/spaces/space.routes.js` |
| POST | `/api/spaces/:id/leave` | EXERCISED — 6 pass (Phase 3 Space Lifecycle: 6) | `src/features/spaces/space.routes.js` |
| GET | `/api/spaces/:id/members` | EXERCISED — 4 pass (Baseline group, space, and handoff security: 4) | `src/features/spaces/space.routes.js` |
| DELETE | `/api/spaces/:id/members/:userId` | EXERCISED — 9 pass (Baseline group, space, and handoff security: 4; Phase 3 Space Lifecycle: 5) | `src/features/spaces/space.routes.js` |
| GET | `/api/spaces/invite/:code` | EXERCISED — 6 pass (Phase 3 Space Lifecycle: 6) | `src/features/spaces/space.routes.js` |
| POST | `/api/spaces/join` | EXERCISED — 10 pass (Phase 3 Space Lifecycle: 10) | `src/features/spaces/space.routes.js` |

### Support & Feedback

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| POST | `/api/support/bug` | NOT YET EXERCISED | `src/features/support/support.routes.js` |
| POST | `/api/support/feature` | NOT YET EXERCISED | `src/features/support/support.routes.js` |
| POST | `/api/support/feedback` | NOT YET EXERCISED | `src/features/support/support.routes.js` |

### Users & Profiles

| Method | API endpoint | This run | Route source |
| --- | --- | --- | --- |
| GET | `/api/users/:id` | EXERCISED — 11 pass, 1 observation (Phase 2 Users and Profiles: 12) | `src/features/users/user.routes.js` |
| GET | `/api/users/lookup` | EXERCISED — 16 pass (Phase 2 Users and Profiles: 16) | `src/features/users/user.routes.js` |
| GET | `/api/users/me` | EXERCISED — 10 pass (Baseline group, space, and handoff security: 6; Extended API: 4) | `src/features/users/user.routes.js` |
| PUT | `/api/users/me` | EXERCISED — 13 pass (Phase 2 Users and Profiles: 13) | `src/features/users/user.routes.js` |
| PUT | `/api/users/me/availability` | EXERCISED — 6 pass (Phase 2 Users and Profiles: 6) | `src/features/users/user.routes.js` |
| PUT | `/api/users/me/fcm-token` | EXERCISED — 6 pass (Phase 2 Users and Profiles: 6) | `src/features/users/user.routes.js` |
| GET | `/api/users/me/needl` | EXERCISED — 7 pass, 4 observation (Phase 2 Users and Profiles: 9; Phase 3 Space Lifecycle: 2) | `src/features/users/user.routes.js` |
| GET | `/api/users/search` | EXERCISED — 14 pass, 1 observation (Phase 2 Users and Profiles: 13; Phase 3 Space Lifecycle: 2) | `src/features/users/user.routes.js` |

## Status definitions

- **EXERCISED**: one or more current security cases called this exact HTTP method and route pattern; the status includes their pass/observation count and module labels, so shared group/DM message routes remain distinguishable.
- **NOT YET EXERCISED**: the route was found in the backend but has no case in the current security suite.
- **NOT RUN**: the discovery suite could not complete, so route-level execution status is unavailable.