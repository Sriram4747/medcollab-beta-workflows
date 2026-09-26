# Vocle API discovery

Executed 352/352; passed 312; observations 40.
Infrastructure: healthy.

Module breakdown:
- Baseline group, space, and handoff security: 146
- Cross-module: 8
- Direct Messages: 61
- Extended API: 49
- Media: 31
- Message Requests: 36
- Realtime: 21

Observations are candidates, not confirmed vulnerabilities. See results.json for every case and source.

- VOCLE-094: A POST /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/reply; foreign-resource; expected 403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-098: B POST /api/channels/7ec000000000000000000003/messages/7ec000000000000000000007/reply; foreign-resource; expected 403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-099: A POST /api/handoffs; foreign-resource; expected 400/403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-110: A PUT /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005; schema-text-number; expected 400, got 200; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-112: A PUT /api/channels/7ec000000000000000000003/messages/7ec000000000000000000005; schema-text-object; expected 400, got 200; validation weakness/hardening opportunity; manual confirmation worthwhile.
- VOCLE-159: D GET /api/channels/7ec000000000000000000009/members; direct-member-metadata-isolation; expected 403, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-168: A POST /api/channels/dm; direct-known-user-idempotence; expected 200, got 403; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-171: E POST /api/channels/dm; direct-self-target; expected 400, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-193: A POST /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/reply; direct-foreign-message-binding; expected 403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-197: B POST /api/channels/7ec000000000000000000009/messages/7ec00000000000000000000e/reply; direct-foreign-message-binding; expected 403/404, got 201; likely security finding; manual confirmation worthwhile.
- VOCLE-218: A POST /api/message-requests; message-request-known-user; expected 400, got 403; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-219: E POST /api/message-requests; message-request-pending-replay; expected 200, got 403; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-220: F POST /api/message-requests; message-request-reciprocal-pending; expected 200, got 403; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-221: E POST /api/message-requests; message-request-declined-transition; expected 201, got 403; ambiguous / requires manual investigation; manual confirmation worthwhile.
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
- VOCLE-313: A DELETE /api/media/medcollab%2Fmessages%2F6ab77ca013d6c93b9e7bb2b8%2F..%2F6ab77ca013d6c93b9e7bb2c7%2F1790410076686-788b18935d29.png; identity-permutation; expected 400/403/404, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-314: A DELETE /api/media/medcollab%252Fmessages%252F6ab77ca013d6c93b9e7bb2b8%252F..%252F6ab77ca013d6c93b9e7bb2c7%252F1790410077286-d09ab2f3b897.png; identity-permutation; expected 400/403/404, got 200; likely security finding; manual confirmation worthwhile.
- VOCLE-323: A POST /api/channels/7ec000000000000000000003/messages; identity-permutation; expected 201, got 400; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-339: A SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-340: A SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-342: C SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-343: C SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-345: B SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-346: B SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-347: B SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-348: B SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.
- VOCLE-349: B SOCKET /socket.io/; realtime-authorization; expected 200, got null; ambiguous / requires manual investigation; manual confirmation worthwhile.