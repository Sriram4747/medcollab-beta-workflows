# Vocle media storage and offline Cloudinary contracts

Executed 97/97; passes 62; observations 35; infrastructure healthy.

The 691-case baseline is preserved; this dedicated run executes selected existing media cases plus new append-only cases. It does not re-execute the general API suite.

No real SDK, credentials or provider requests. SDK output/asset state is simulated; only call intent and local application behavior are measured.

| Module | Executed | Pass | Observation |
| --- | --- | --- | --- |
| Media | 31 | 22 | 9 |
| Cross-module | 6 | 6 | 0 |
| Local Media Storage Lifecycle | 26 | 13 | 13 |
| Offline Cloudinary SDK Contract | 34 | 21 | 13 |

- VOCLE-301: upload rejects wrong field; expected 400, actual 500; application observation requiring review.
- VOCLE-302: upload rejects multiple files; expected 400, actual 500; application observation requiring review.
- VOCLE-303: upload rejects forbidden MIME; expected 400, actual 500; application observation requiring review.
- VOCLE-304: upload rejects octet forbidden suffix; expected 400, actual 500; application observation requiring review.
- VOCLE-306: upload rejects empty bytes; expected 400, actual 200; application observation requiring review.
- VOCLE-307: upload rejects inert MIME extension mismatch; expected 400, actual 200; application observation requiring review.
- VOCLE-313: media canonical owner containment single; expected 400/403/404, actual 200; application observation requiring review.
- VOCLE-314: media canonical owner containment double; expected 400/403/404, actual 200; application observation requiring review.
- VOCLE-323: local upload to authorized message integration; expected 201, actual 400; application observation requiring review.
- VOCLE-698: upload validates malformed JPEG bytes; expected 400, actual 200; validation/hardening issue.
- VOCLE-699: upload validates unsupported SVG; expected 400, actual 500; validation/hardening issue.
- VOCLE-700: upload validates unsupported MKV; expected 400, actual 500; validation/hardening issue.
- VOCLE-701: octet video metadata follows supported extension; expected 200, actual 200; validation/hardening issue.
- VOCLE-704: avatar canonical foreign owner file survives; expected 400/403/404, actual 200; confirmed security defect.
- VOCLE-705: shared handoff upload supports owner deletion; expected 200, actual 403; lifecycle/hardening issue.
- VOCLE-709: draft deletion orphan lifecycle; expected 200, actual 200; retention-policy review.
- VOCLE-710: explicit file deletion reference consistency; expected 200, actual 200; lifecycle-policy review.
- VOCLE-713: handoff rejects untrusted attachment URL; expected 400, actual 200; validation/hardening issue.
- VOCLE-714: message media validates alternate cloud provenance; expected 400, actual 201; validation/hardening issue.
- VOCLE-715: message media validates untrusted thumbnail; expected 400, actual 201; validation/hardening issue.
- VOCLE-716: message media validates negative size and dimensions; expected 400, actual 201; validation/hardening issue.
- VOCLE-717: message media validates missing image media URL; expected 400, actual 201; validation/hardening issue.
- VOCLE-721: SDK shared handoff has caller ownership namespace; expected 200, actual 200; Cloudinary call-contract hardening.
- VOCLE-724: SDK resource type octet PDF; expected 200, actual 200; Cloudinary call-contract hardening.
- VOCLE-725: SDK resource type octet video; expected 200, actual 200; Cloudinary call-contract hardening.
- VOCLE-727: SDK explicit overwrite prevention; expected 200, actual 200; Cloudinary call-contract hardening.
- VOCLE-733: SDK prototype-like context denied before upload; expected 400, actual 500; Cloudinary call-contract hardening.
- VOCLE-736: SDK owner video delete operation; expected 200, actual 404; Cloudinary call-contract hardening.
- VOCLE-737: SDK deletion requests CDN invalidation; expected 200, actual 200; Cloudinary call-contract hardening.
- VOCLE-739: SDK delete rejects namespace containing embedded owner; expected 400/403/404, actual 404; application namespace authorization defect.
- VOCLE-740: SDK owner handoff deletion reaches exact asset; expected 200, actual 403; Cloudinary call-contract hardening.
- VOCLE-743: SDK success then URL failure compensates upload; expected 500, actual 500; partial-failure lifecycle hardening.
- VOCLE-746: SDK video upload to message compatibility; expected 201, actual 400; media compatibility issue.
- VOCLE-747: SDK message soft-delete storage lifecycle; expected 200, actual 200; retention-policy review.
- VOCLE-750: SDK empty upload denied before stream invocation; expected 400, actual 200; Cloudinary call-contract hardening.
