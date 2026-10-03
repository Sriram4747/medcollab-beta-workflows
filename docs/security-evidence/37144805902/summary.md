# Vocle API discovery

Executed 626/626; passed 566; observations 60.
Infrastructure: healthy.

Module breakdown:
- Baseline group, space, and handoff security: 146
- Cross-module: 8
- Direct Messages: 61
- Extended API: 49
- Media: 31
- Message Requests: 36
- Phase 0 Repair Controls: 3
- Phase 1 Authentication and Session Lifecycle: 31
- Phase 2 Users and Profiles: 75
- Phase 3 Consent and Handoffs: 65
- Phase 3 Space Lifecycle: 53
- Phase 4 Bounded HTTP: 47
- Realtime: 21

Observations are candidates, not confirmed vulnerabilities. See results.json for every case and source.

- VOCLE-094: A POST /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/reply; foreign-resource; expected 403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-098: B POST /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/reply; foreign-resource; expected 403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-099: A POST /api/handoffs; foreign-resource; expected 400/403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-110: A PUT /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005; schema-text-number; expected 400, got 200; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-112: A PUT /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005; schema-text-object; expected 400, got 200; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-159: D GET /api/channels/7ec000000000000000000009/members; direct-member-metadata-isolation; expected 403, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-171: E POST /api/channels/dm; direct-self-notes-isolation; expected 200, got 200; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-193: A POST /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/reply; direct-foreign-message-binding; expected 403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-197: B POST /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/reply; direct-foreign-message-binding; expected 403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-267: B GET /api/handoffs?type=received&status=draft; identity-permutation; expected 200, got 200; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-268: B GET /api/handoffs/7ec000000000000000000008; identity-permutation; expected 403/404, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-270: B GET /api/search?q=DraftCanary&type=handoffs; identity-permutation; expected 200, got 200; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-271: D GET /api/search?q=DraftCanary&type=handoffs; identity-permutation; expected 200, got 200; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-272: B GET /api/channels/7ec000000000000000000003; identity-permutation; expected 403, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-273: B GET /api/channels/7ec000000000000000000003/members; identity-permutation; expected 403, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-275: A POST /api/channels/7ec000000000000000000003/messages; foreign-resource; expected 400/403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-276: A POST /api/channels/7ec000000000000000000003/messages; foreign-resource; expected 400/403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-301: B POST /api/media/upload; media-schema; expected 400, got 500; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-302: B POST /api/media/upload; media-schema; expected 400, got 500; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-303: B POST /api/media/upload; media-schema; expected 400, got 500; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-304: B POST /api/media/upload; media-schema; expected 400, got 500; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-306: B POST /api/media/upload; media-schema; expected 400, got 200; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-307: B POST /api/media/upload; media-schema; expected 400, got 200; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-313: A DELETE /api/media/medcollab%2Fmessages%2F6ac14b3c93f495cc2e0769bd%2F..%2F6ac14b3c93f495cc2e0769cd%2F1791052789138-f9f4d38bb317.png; identity-permutation; expected 400/403/404, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-314: A DELETE /api/media/medcollab%252Fmessages%252F6ac14b3c93f495cc2e0769bd%252F..%252F6ac14b3c93f495cc2e0769cd%252F1791052789727-1f7049070d5b.png; identity-permutation; expected 400/403/404, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-323: A POST /api/channels/7ec000000000000000000003/messages; identity-permutation; expected 201, got 400; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-339: A SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-340: A SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-342: C SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-343: C SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-345: B SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-346: B SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-347: B SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-348: B SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-349: B SOCKET /socket.io/; realtime-authorization; expected not applicable, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-355: E POST /api/message-requests; message-request-opted-out-denial; expected 403, got 403; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-356: anonymous POST /api/auth/verify-msg91-token; auth-widget-unverified-token; expected 400, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-357: anonymous POST /api/auth/verify-msg91-token; auth-widget-unverified-token; expected 400, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-398: A GET /api/users/6ac14b3c93f495cc2e0769d5; profile-authorization; expected 200, got 200; hardening / public profile field policy requires review; manual confirmation worthwhile.
- VOCLE-421: A GET /api/users/search?q=Vocle&spaceId=7ec000000000000000000002; profile-authorization; expected 200, got 200; hardening / known-user foreign-space membership inference policy; manual confirmation worthwhile.
- VOCLE-429: B GET /api/users/me/needl; needl-private-authorization; expected 200, got 200; likely security finding / Needl private preview confidentiality; manual confirmation worthwhile.
- VOCLE-434: B GET /api/users/me/needl; needl-private-authorization; expected 200, got 200; likely security finding / Needl private preview confidentiality; manual confirmation worthwhile.
- VOCLE-503: B GET /api/users/me/needl; space-lifecycle-authorization; expected 200, got 200; likely security finding / Needl space revocation bypass via retained channel member IDs; manual confirmation worthwhile.
- VOCLE-509: B GET /api/users/me/needl; space-lifecycle-authorization; expected 200, got 200; likely security finding / Needl space revocation bypass via retained channel member IDs; manual confirmation worthwhile.
- VOCLE-527: A POST /api/channels/dm/group; group-dm-target-lifecycle; expected 404, got 200; likely security finding / unavailable identity accepted in group DM; manual confirmation worthwhile.
- VOCLE-528: A POST /api/channels/dm/group; group-dm-target-lifecycle; expected 404, got 200; likely security finding / unavailable identity accepted in group DM; manual confirmation worthwhile.
- VOCLE-529: F POST /api/channels/dm/group; consent-handoff-authorization; expected 200, got 200; consent policy review / request eligibility opens group message access without acceptance; manual confirmation worthwhile.
- VOCLE-530: F POST /api/channels/dm; consent-handoff-authorization; expected 403, got 200; consent policy review / group-derived one-to-one DM eligibility; manual confirmation worthwhile.
- VOCLE-572: A POST /api/handoffs/7ec000000000000000000008/reassign; consent-handoff-authorization; expected 400, got 200; likely security finding / inactive handoff assignee accepted; manual confirmation worthwhile.
- VOCLE-574: B POST /api/handoffs/7ec000000000000000000008/notes; consent-handoff-authorization; expected 200, got 200; lifecycle policy review / removed handoff party retains source-authorized write access; manual confirmation worthwhile.
- VOCLE-575: B POST /api/handoffs/7ec000000000000000000008/reassign; consent-handoff-authorization; expected 200, got 200; lifecycle policy review / removed handoff party retains source-authorized write access; manual confirmation worthwhile.
- VOCLE-594: B POST /api/channels/7ec000000000000000000003/pin/7ec000000000000000000005; http-authorization-boundary; expected 403, got 200; likely security finding / private pin authorization; manual confirmation worthwhile.
- VOCLE-595: B DELETE /api/channels/7ec000000000000000000003/pin/7ec000000000000000000005; http-authorization-boundary; expected 403, got 200; likely security finding / private unpin authorization; manual confirmation worthwhile.
- VOCLE-599: A POST /api/channels/7ec000000000000000000003/pin/7ec000000000000000000005; http-authorization-boundary; expected 403, got 200; hardening / archived-channel mutation policy; manual confirmation worthwhile.
- VOCLE-603: A POST /api/channels/7ec000000000000000000003/messages; mention-notification-authorization; expected 201, got 201; likely security finding / unauthorized mention notification disclosure; manual confirmation worthwhile.
- VOCLE-604: A POST /api/channels/7ec000000000000000000003/messages; mention-notification-authorization; expected 201, got 201; likely security finding / unauthorized mention notification disclosure; manual confirmation worthwhile.
- VOCLE-605: A POST /api/channels/7ec000000000000000000003/messages; mention-notification-authorization; expected 201, got 201; likely security finding / unauthorized mention notification disclosure; manual confirmation worthwhile.
- VOCLE-611: B POST /api/support/bug; support-schema-boundary; expected 400, got 500; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-618: B POST /api/support/feature; support-schema-boundary; expected 400, got 500; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-625: B POST /api/support/feedback; support-schema-boundary; expected 400, got 500; validation weakness/hardening opportunity; manual confirmation worthwhile.