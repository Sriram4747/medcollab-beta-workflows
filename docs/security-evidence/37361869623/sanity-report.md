# Vocle functional sanity report

Result: **FAILED**

- Expected cases: 48
- Passed: 42
- Failed: 2
- Blocked/missing: 4
- Upstream SHA: 4638682c0c930fcde3378d7e809612b6c0eab370
- Harness SHA: 4eb4c2a57bb0f47bb771321a44c2a283e546ef3e

This report records the coverage and result of every named sanity case; failures and blocked cases are gating.

## authentication-and-profiles

Exercises real MSG91 OTP interception, hashed OTP storage, token refresh, onboarding persistence, and device-token lifecycle.

- **authentication-and-profiles-01 — otp-verification-creates-user-and-tokens:** PASSED (296 ms)
- **authentication-and-profiles-02 — returning-login-preserves-identity:** PASSED (180 ms)
- **authentication-and-profiles-03 — incorrect-otp-fails-then-correct-works:** PASSED (262 ms)
- **authentication-and-profiles-04 — consumed-otp-cannot-be-reused:** PASSED (5 ms)
- **authentication-and-profiles-05 — onboarding-and-profile-persist:** PASSED (19 ms)
- **authentication-and-profiles-06 — refresh-session-and-missing-refresh-fails:** PASSED (9 ms)
- **authentication-and-profiles-07 — device-deduplication-and-logout-removal:** PASSED (26 ms)

## spaces-and-invitations

Covers default channel creation, invitation membership lifecycle, invitation rotation, and owner/member controls.

- **spaces-and-invitations-01 — space-creation-default-channels:** PASSED (15 ms)
- **spaces-and-invitations-02 — invitation-preview-join-and-membership:** PASSED (37 ms)
- **spaces-and-invitations-03 — duplicate-space-join-conflict:** PASSED (10 ms)
- **spaces-and-invitations-04 — rename-and-regenerate-invitation:** PASSED (18 ms)
- **spaces-and-invitations-05 — member-leave-owner-removal-and-owner-leave-rejection:** PASSED (34 ms)

## channels

Checks public/private channel access, duplicate prevention, updates, archive retention, and default-channel protection.

- **channels-01 — public-channel-create-read-update-and-duplicate-rejection:** PASSED (26 ms)
- **channels-02 — private-channel-creator-access:** PASSED (14 ms)
- **channels-03 — archive-custom-channel-retains-messages-and-protects-defaults:** PASSED (47 ms)

## messaging-and-needl

Checks REST persistence plus socket fan-out, pagination, quotes, threads, Needl, edits, deletion, reactions, pins, and emergency priority.

- **messaging-and-needl-01 — text-message-sender-and-sidebar-preview:** PASSED (58 ms)
- **messaging-and-needl-02 — root-pagination-order-without-overlap:** PASSED (89 ms)
- **messaging-and-needl-03 — quoted-message-retains-metadata:** PASSED (19 ms)
- **messaging-and-needl-04 — thread-reply-needl-and-preview:** PASSED (57 ms)
- **messaging-and-needl-05 — edit-soft-delete-and-socket-events:** PASSED (61 ms)
- **messaging-and-needl-06 — reaction-and-pin-persistence:** PASSED (64 ms)
- **messaging-and-needl-07 — empty-text-rejection-and-emergency-priority:** PASSED (25 ms)

## message-requests

Checks the request state machine, inbox/list/count visibility, duplicate stability, notification persistence, and DM creation after acceptance.

- **message-requests-01 — eligible-peer-request-lists-count-and-notification:** FAILED (5125 ms) — Recipient message-request notification was not persisted within 5 seconds (request state was persisted).
- **message-requests-02 — accept-request-dm-and-notification:** FAILED (15 ms) — POST /api/message-requests/6ac3f7538cc6dc981b8cc9c9/accept expected 200, received 500: {"success":false,"message":"Plan executor error during findAndModify :: caused by :: cannot infer query fields to set, path 'members' is matched twice","errors":[]}
- **message-requests-03 — decline-request-and-terminal-transition-rejection:** PASSED (34 ms)

## direct-and-group-conversations

Checks stable DM identity, message/read-receipt behavior, self notes, group membership, rename, and upstream history expansion.

- **direct-and-group-conversations-01 — accepted-dm-reopens-to-same-id:** BLOCKED (0 ms) — Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-02 — dm-message-peer-details-and-preview:** BLOCKED (0 ms) — Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-03 — read-receipt-deduplication-and-preference:** BLOCKED (0 ms) — Required request, conversation, or message fixture was not created.
- **direct-and-group-conversations-04 — notes-self-and-group-membership-rename:** PASSED (64 ms)
- **direct-and-group-conversations-05 — conversation-expansion-none-and-all:** BLOCKED (0 ms) — Required request, conversation, or message fixture was not created.

## handoffs

Checks drafts, submission/acknowledgement/reassignment lifecycle, write-backs, history, events, notification state, and immutable submitted records.

- **handoffs-01 — handoff-draft-create-edit-read:** PASSED (39 ms)
- **handoffs-02 — empty-draft-rejection-and-disposable-delete:** PASSED (24 ms)
- **handoffs-03 — submit-handoff-inbox-history-notification-event:** PASSED (45 ms)
- **handoffs-04 — acknowledge-handoff-and-duplicate-rejection:** PASSED (119 ms)
- **handoffs-05 — writeback-reassign-reset-and-new-assignee-acknowledge:** PASSED (44 ms)

## media

Checks local storage bytes and deletion, PDF attachment persistence, and accepted inert Cloudinary metadata without fetching external URLs.

- **media-01 — png-upload-download-delete:** PASSED (31 ms)
- **media-02 — pdf-upload-and-handoff-attachment:** PASSED (34 ms)
- **media-03 — inert-image-ecg-document-message-metadata:** PASSED (52 ms)

## notifications

Checks message/mention/emergency notification generation, personal socket delivery, deep-link metadata, counts, and all read-state operations.

- **notifications-01 — ordinary-message-inbox-count-metadata-socket:** PASSED (36 ms)
- **notifications-02 — mention-and-emergency-notification-types:** PASSED (46 ms)
- **notifications-03 — notification-read-unread-channel-read-all-delete:** PASSED (56 ms)

## realtime-and-availability

Checks authenticated sockets, reconnect/rejoin, typing signals, availability persistence, space-room synchronization, and final offline presence.

- **realtime-and-availability-01 — socket-auth-join-message-reconnect:** PASSED (69 ms)
- **realtime-and-availability-02 — typing-start-stop-peer-delivery:** PASSED (2 ms)
- **realtime-and-availability-03 — availability-persistence-broadcast-room-sync-presence:** PASSED (28 ms)

## search

Checks known-user discovery and fully scoped global results for messages, doctors, channels, attachments, handoffs, and no-match behavior.

- **search-01 — known-user-search-and-phone-lookup:** PASSED (22 ms)
- **search-02 — global-search-and-empty-query-result:** PASSED (54 ms)

## support

Checks authenticated bug-report creation, stored author/content fields, and required-field validation.

- **support-01 — bug-report-persistence-and-required-title:** PASSED (62 ms)

## startup

Checks the isolated backend health contract: connected MongoDB, test environment, and disabled Firebase/Cloudinary.

- **startup-01 — health-connected-test-and-disabled-providers:** PASSED (0 ms)
