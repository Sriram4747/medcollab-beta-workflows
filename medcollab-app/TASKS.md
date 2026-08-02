# MedCollab Flutter — Task Tracker

## Phase 1 — Foundation ✅

| Task | Status | Notes |
|------|--------|-------|
| Study backend API contracts | ✅ Done | Routes, models, socket events inferred from backend |
| `pubspec.yaml` + dependencies | ✅ Done | flutter_bloc, dio, socket_io_client, go_router |
| Feature-first folder structure | ✅ Done | `lib/core`, `lib/features/*`, `lib/shared` |
| `main.dart` + `app.dart` | ✅ Done | DI bootstrap, `MaterialApp.router` |
| Theme (clinical / trustworthy) | ✅ Done | Material 3, emergency accent colors |
| Router (`go_router`) | ✅ Done | Route constants + auth redirect |
| Constants (API, socket, enums) | ✅ Done | Mirrors backend `src/constants/index.js` |
| API client (`dio`) | ✅ Done | Typed responses, auth interceptor, multipart upload |
| Socket client | ✅ Done | JWT handshake, channel rooms, presence events |
| Secure storage service | ✅ Done | Access/refresh tokens, session persistence |
| Base repository | ✅ Done | `ApiResponse` parsing, error mapping |
| Auth models | ✅ Done | User, session, OTP request/response DTOs |
| Auth repository | ✅ Done | requestOtp, verifyOtp, refresh, logout |

## Phase 2 — Auth UI ✅

| Task | Status | Notes |
|------|--------|-------|
| `AuthBloc` + events/states | ✅ Done | Session restore, OTP, profile, logout |
| Splash screen | ✅ Done | Dispatches `AuthStarted` |
| Phone entry screen | ✅ Done | E.164 validation, loading, errors |
| OTP verification screen | ✅ Done | Resend, change phone |
| Profile setup screen | ✅ Done | Name, role, speciality, institution |
| Wire router redirect to auth state | ✅ Done | `GoRouterRefreshStream` |
| Persistent login | ✅ Done | Secure storage + `getMe` on launch |
| Logout | ✅ Done | API + local session clear |

## Phase 3 — Core navigation ✅ MVP

| Task | Status | Notes |
|------|--------|-------|
| Spaces list + create/join | ✅ Done | `SpacesHomePage` |
| Channel list per space | ✅ Done | `SpaceDetailPage` |
| Message thread + send | ✅ Done | `ChannelChatPage` + `ChannelChatCubit` |
| Socket real-time messages | ✅ Done | `new_message` listener |

## Phase 4 — Threaded discussions ✅ MVP

| Task | Status | Notes |
|------|--------|-------|
| Thread models + repository | ✅ Done | `ThreadDetail`, `ThreadRepository` |
| Thread screen + reply UI | ✅ Done | `ThreadPage`, `ThreadCubit` |
| Parent preview + reply badge | ✅ Done | `message_widgets.dart` |
| Channel integration | ✅ Done | `MessageBubble`, thread route |
| Realtime thread updates | ✅ Done | Socket `new_message` + `threadId` |

## Phase 5 — Rich communication and media ✅ MVP

| Task | Status | Notes |
|------|--------|-------|
| Image upload (Cloudinary) | ✅ Done | `MediaRepository` + backend `POST /api/media/upload` |
| Gallery picker + camera capture | ✅ Done | `image_picker`, `MediaPickerService` |
| Image message bubbles + preview | ✅ Done | `cached_network_image`, pinch-zoom |
| PDF / file attachments | ✅ Done | `file_picker`, document bubbles |
| Download / open attachments | ✅ Done | `url_launcher` |
| Timestamps + delivery state | ✅ Done | Sending / sent / failed indicators |
| Sender grouping + date separators | ✅ Done | `message_list_utils.dart` |
| Empty state + auto-scroll | ✅ Done | Smart scroll when near bottom |
| Long message wrapping | ✅ Done | `softWrap` on text bubbles |
| Custom channel creation UI | ✅ Done | `CreateChannelDialog` |
| Channel description + member count | ✅ Done | `SpaceDetailPage` |
| Channel search | ✅ Done | Client-side filter |
| Space member list | ✅ Done | `SpaceMembersPage` |
| User profile card | ✅ Done | `UserProfileSheet` |
| Online/offline + presence states | ✅ Done | `PresenceCubit`, socket `presence_update` |
| Search members | ✅ Done | API `GET /api/users/search` + local filter |
| `ChannelRepository`, `MemberRepository` | ✅ Done | Wired in `AppDependencies` |

## Phase 6 — Clinical handoffs ✅ MVP

| Task | Status | Notes |
|------|--------|-------|
| Handoff create / submit / acknowledge | ✅ Done | Realtime via socket |
| Push notifications (FCM) | ✅ Done | Sprint 10 — Android QA confirmed |

## Phase 7 — Beta deployment ✅

| Task | Status | Notes |
|------|--------|-------|
| MongoDB Atlas | ✅ Live | `medcollab-beta` DB |
| Railway API | ✅ Live | https://medcollab.up.railway.app |
| Cloudinary | ✅ Live | Production media |
| GitHub mirror for Railway | ✅ Done | mathiharan29/medcollab-beta |
| MSG91 OTP Widget | ✅ Live | SDK + `verify-msg91-token` |
| Production APK | ✅ Built | `build/app/outputs/flutter-apk/app-release.apk` |

## Phase 8 — Beta polish (2026-07-05) ✅

| Task | Status | Notes |
|------|--------|-------|
| Faster login | ✅ Done | Async socket, JWT phone verify |
| Channel count refresh | ✅ Done | Spaces home reload on return |
| Presence realtime | ✅ Done | Socket + merge fixes |
| Handoff Pending/Active/Drafts | ✅ Done | Clinical tab labels |
| Private channel visibility | ✅ Done | Member-only filter |
| No handoff spam in #general | ✅ Done | Notification only |
| Chat emoji, edit/delete, thread media | ✅ Done | Realtime socket updates |

## Phase 9 — Sprint 7: Product UX & IA ✅ (2026-07-06)

| Task | Status | Notes |
|------|--------|-------|
| Clinical workspace home dashboard | ✅ Done | Greeting, shift, availability, activity, recent/pinned |
| Bottom nav (Home/Messages/Handoffs/Alerts/Profile) | ✅ Done | Spaces no longer landing page |
| Messages hub (unified inbox) | ✅ Done | All channels across spaces |
| Global handoffs tab | ✅ Done | Pending / Active / Drafts |
| In-app notification center | ✅ Done | Categories + read/unread |
| @Mentions (autocomplete, highlight, badge) | ✅ Done | Sends mentions to API |
| Read receipts UI | ✅ Done | readBy + lastSeen heuristic |
| Bookmarks (local) | ✅ Done | Messages, threads, handoffs |
| Pinned messages in channel | ✅ Done | Pin/unpin + pinned bar |
| Global search | ✅ Done | Spaces, channels, handoffs, patients, doctors |
| UX polish (cards, skeletons, clinical IA) | ✅ Done | Material 3 clinical language |

## Phase 9b — Sprint 7 QA bugfix ✅ (2026-07-13)

| Task | Status | Notes |
|------|--------|-------|
| Realtime messaging after reconnect | ✅ Done | Socket `enableForceNew()` |
| @mention suggestions | ✅ Done | Members load independent of channel detail |
| Mark all notifications read | ✅ Done | `executeVoid` (requireData bug) |
| Profile availability + presence | ✅ Done | AuthBloc + socket + PresenceCubit |
| Handoff ack live for assigner | ✅ Done | Global handoffs socket reload |
| Notification deep link | ✅ Done | Navigate before awaiting mark-read |
| Roles + custom Other | ✅ Done | Profile setup |
| Space type labels / back / avatar / QA polish | ✅ Done | Caps, chat back, Home→Profile |
| Production APK rebuild | ✅ Done | 2026-07-13 bugfix build |

## Phase 10 — Sprint 8: Communication Completeness ✅ (2026-07-20)

| Task | Status | Notes |
|------|--------|-------|
| Direct messages (1:1) | ✅ Done | `GET/POST /api/channels/dm`, hub Direct tab, `/dm/:id` |
| Search doctors → start DM | ✅ Done | `StartDmPage` + `createOrGetDM` |
| DM presence / typing / receipts / media / threads | ✅ Done | Reuses channel chat + sockets |
| Notification categories + badges | ✅ Done | Existing filters + badge cubit |
| Notification preferences | ✅ Done | Settings page + `PUT /users/me` |
| Mark notification unread | ✅ Done | `PUT /api/notifications/:id/unread` |
| Share & invite (WhatsApp, copy, QR) | ✅ Done | `space_invite_share_sheet` |
| Deep links + join from invite | ✅ Done | `/join/:code`, Android intent filters |
| Invite preview API | ✅ Done | `GET /api/spaces/invite/:code` |
| Draft messages (per channel/thread) | ✅ Done | `DraftMessageService` |
| Typing indicators (channel/thread/DM) | ✅ Done | Socket typing_start/stop |
| Better search (messages, doctors, channels, attachments) | ✅ Done | `GET /api/search` |
| flutter analyze | ✅ Done | No errors (info/warnings only) |
| Android release APK | ✅ Done | 2026-07-20 |
| Chrome/web release | ✅ Done | `build/web` |

## Phase 11 — Sprint 9: Doctor Daily Workspace ✅ (2026-07-21)

| Task | Status | Notes |
|------|--------|-------|
| Modular Home widgets | ✅ Done | `doctor_workspace_widgets.dart` |
| Configurable layout (reorder + hide) | ✅ Done | `DashboardPreferencesService` |
| Today's Shift | ✅ Done | From assigned handoffs with today's date |
| Current Availability | ✅ Done | Auth profile → Profile tab |
| Assigned Handoffs | ✅ Done | `toUser == me`, non-draft |
| Pending Tasks | ✅ Done | Mentions / threads / handoffs / invites |
| Recent Patient Discussions | ✅ Done | Channel lastMessage previews |
| Recent DMs | ✅ Done | ChannelRepository.getMyDMs |
| Quick Actions | ✅ Done | Handoff, discussion, refer, case |
| Emergency Button | ✅ Done | Confirm → emergency channel |
| Hospital / Department announcements | ✅ Done | Split by `SpaceType` |
| No backend redesign / no AI | ✅ Done | Compose existing APIs |
| flutter analyze | ✅ Done | Exit 0 (`--no-fatal-infos`) |

## Phase 12 — Sprint 10: FCM push ✅ (2026-08-01 / QA 2026-08-02)

| Task | Status | Notes |
|------|--------|-------|
| Flutter FCM + local notifications | ✅ Done | `lib/core/notifications/` |
| Token lifecycle (login / logout) | ✅ Done | `PUT /api/users/me/fcm-token` |
| Android channels + permission | ✅ Done | `messages`, `emergency`, POST_NOTIFICATIONS |
| Firebase Admin on Railway | ✅ Done | Modular `firebase-admin/app`; logs `Firebase Admin connected` |
| Deep link on notification tap | ✅ Done | Chat / handoff / Alerts |
| Release APK with FCM | ✅ Done | `MedCollab-beta.apk` ~56 MB |
| Two-phone killed-app QA | ✅ Done | Confirmed working |

## Phase 13 — Sprint 11: Beta Polish ✅ (2026-08-02)

| Task | Status | Notes |
|------|--------|-------|
| DM privacy (spaces ∪ DMs ∪ institution) | ✅ Done | Backend `knownUsers` + createOrGetDM gate |
| DM route stack spam | ✅ Done | `openDmChat` + debounce |
| Suppress alerts while in chat | ✅ Done | Channel room viewers + ActiveChatTracker |
| Offline availability status | ✅ Done | Enum + presence display |
| Onboarding / empty states | ✅ Done | Home, Spaces, Messages, Join |
| Help / FAQ / Bug / Feature / Contact | ✅ Done | Profile → support pages |
| Developer Mode (debug/beta) | ✅ Done | PIN 2468; `/api/dev/*` seeds |
| flutter analyze / unit tests | ✅ Done | See test suite |
| Docs updated | ✅ Done | Lead summary + state |

## Phase 14 — Next (Sprint 12+)

| Task | Status | Notes |
|------|--------|-------|
| Unread badges on Messages / Handoffs tabs | ⬜ Pending | Often hardcoded `false` |
| Commit / push + Railway deploy privacy fixes | ⬜ Pending | GitHub `master` for API |
| Dedicated shift/roster API | ⬜ Pending | Replace handoff-derived Today’s Shift |
| Handoff completed/missed | ⬜ Pending | New statuses + expiry |
| Server-side bookmarks + synced dashboard prefs | ⬜ Pending | Currently local |
| Play Store prep (applicationId, signing) | ⬜ Pending | Still `com.example.medcollab_app` |
| iOS APNs | ⬜ Pending | Android-first beta |

## API contract reference (inferred)

### Response envelope
```json
{ "success": true, "message": "...", "data": { } }
{ "success": false, "message": "...", "errors": [ ] }
```

### Auth
- `POST /api/auth/request-otp` → `{ phone }` → `{ phone, expiresInMinutes }`
- `POST /api/auth/verify-otp` → `{ phone, otp }` → `{ accessToken, refreshToken, isNewUser, user }`
- `POST /api/auth/refresh` → `{ refreshToken }` → `{ accessToken }`
- `POST /api/auth/logout` → `{ fcmToken? }` (protected)

### Media
- `POST /api/media/upload` (multipart `file`) → `{ url, thumbnailUrl, publicId, fileName, mimeType, ... }`

### Sprint 8 API
- `GET /api/channels/dm` → `{ channels }` (peer populated)
- `POST /api/channels/dm` → `{ userId }` → `{ channel }`
- `PUT /api/notifications/:id/unread`
- `GET /api/spaces/invite/:code` → invite preview + `joinUrl`
- `GET /api/search?q=&type=all|messages|doctors|channels|attachments`

### Socket handshake
- URL: same host as API (no `/api` prefix)
- Auth: `{ token: accessToken }` in handshake
- Events: see `lib/core/constants/socket_events.dart`
