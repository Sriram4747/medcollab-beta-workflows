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

## VOCLE-295 — local upload context message

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-296 — local upload context avatar

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-297 — local upload context handoff

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-298 — local upload context unknown

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-299 — upload rejects anonymous

PASS; expected HTTP 401, actual 401; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":0,"uploadStatus":401}`

SDK calls (simulated boundary): `[]`

## VOCLE-300 — upload rejects missing file

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":0,"uploadStatus":400}`

SDK calls (simulated boundary): `[]`

## VOCLE-301 — upload rejects wrong field

OBSERVATION; expected HTTP 400, actual 500; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":0,"uploadStatus":500}`

SDK calls (simulated boundary): `[]`

## VOCLE-302 — upload rejects multiple files

OBSERVATION; expected HTTP 400, actual 500; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":0,"uploadStatus":500}`

SDK calls (simulated boundary): `[]`

## VOCLE-303 — upload rejects forbidden MIME

OBSERVATION; expected HTTP 400, actual 500; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":0,"uploadStatus":500}`

SDK calls (simulated boundary): `[]`

## VOCLE-304 — upload rejects octet forbidden suffix

OBSERVATION; expected HTTP 400, actual 500; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":0,"uploadStatus":500}`

SDK calls (simulated boundary): `[]`

## VOCLE-305 — upload rejects oversized

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":0,"uploadStatus":400}`

SDK calls (simulated boundary): `[]`

## VOCLE-306 — upload rejects empty bytes

OBSERVATION; expected HTTP 400, actual 200; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-307 — upload rejects inert MIME extension mismatch

OBSERVATION; expected HTTP 400, actual 200; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-308 — media deletion ownership A

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-309 — media deletion ownership B

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-310 — media deletion ownership C

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-311 — media deletion ownership anonymous

PASS; expected HTTP 401, actual 401; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-312 — media deletion replay

PASS; expected HTTP 404, actual 404; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-313 — media canonical owner containment single

OBSERVATION; expected HTTP 400/403/404, actual 200; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200,"foreignFileSurvived":false}`

SDK calls (simulated boundary): `[]`

## VOCLE-314 — media canonical owner containment double

OBSERVATION; expected HTTP 400/403/404, actual 200; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200,"foreignFileSurvived":false}`

SDK calls (simulated boundary): `[]`

## VOCLE-315 — anonymous static media and owner revocation

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200,"publicStaticControl":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-316 — message media URL trusted HTTPS

PASS; expected HTTP 201, actual 201; semantic true; database unchanged false.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{}`

SDK calls (simulated boundary): `[]`

## VOCLE-317 — message media URL foreign host

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{}`

SDK calls (simulated boundary): `[]`

## VOCLE-318 — message media URL host suffix lookalike

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{}`

SDK calls (simulated boundary): `[]`

## VOCLE-319 — message media URL invalid URL

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{}`

SDK calls (simulated boundary): `[]`

## VOCLE-320 — message media URL protocol relative

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{}`

SDK calls (simulated boundary): `[]`

## VOCLE-321 — message media URL FTP trusted host

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{}`

SDK calls (simulated boundary): `[]`

## VOCLE-322 — message media URL HTTP trusted host

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{}`

SDK calls (simulated boundary): `[]`

## VOCLE-323 — local upload to authorized message integration

OBSERVATION; expected HTTP 201, actual 400; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-324 — uploaded media does not grant foreign channel access 7ec000000000000000000004

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-325 — uploaded media does not grant foreign channel access 7ec00000000000000000000a

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-326 — handoff attachment sender ownership A

PASS; expected HTTP 200, actual 200; semantic true; database unchanged false.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-327 — handoff attachment sender ownership B

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-328 — handoff attachment sender ownership C

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-329 — handoff attachment sender ownership anonymous

PASS; expected HTTP 401, actual 401; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-330 — local PDF bytes retained application/pdf

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-331 — local PDF bytes retained application/octet-stream

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"filesAdded":1,"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-692 — upload current identity denial inactive

PASS; expected HTTP 401, actual 401; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":401,"authorizedControl":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-693 — upload current identity denial unonboarded

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":403,"authorizedControl":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-694 — upload current identity denial expired

PASS; expected HTTP 401, actual 401; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":401,"authorizedControl":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-695 — upload current identity denial invalid signature

PASS; expected HTTP 401, actual 401; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":401,"authorizedControl":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-696 — duplicate local names preserve independent bytes

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"independentIds":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-697 — original filename cannot choose local output path

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-698 — upload validates malformed JPEG bytes

OBSERVATION; expected HTTP 400, actual 200; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-699 — upload validates unsupported SVG

OBSERVATION; expected HTTP 400, actual 500; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":500}`

SDK calls (simulated boundary): `[]`

## VOCLE-700 — upload validates unsupported MKV

OBSERVATION; expected HTTP 400, actual 500; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":500}`

SDK calls (simulated boundary): `[]`

## VOCLE-701 — octet video metadata follows supported extension

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"returnedFormat":null,"exactBytes":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-702 — avatar deletion owner boundary A

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-703 — avatar deletion owner boundary C

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-704 — avatar canonical foreign owner file survives

OBSERVATION; expected HTTP 400/403/404, actual 200; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"foreignFileSurvived":false}`

SDK calls (simulated boundary): `[]`

## VOCLE-705 — shared handoff upload supports owner deletion

OBSERVATION; expected HTTP 200, actual 403; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"fileSurvived":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-706 — avatar replacement retention characterization

PASS; expected HTTP 200, actual 200; semantic true; database unchanged false.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js, src/features/users/user.controller.js:updateMe.

Evidence: `{"uploadStatus":200,"previousFileRetained":true,"newFileRetained":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-707 — foreign uploaded avatar reference characterization

PASS; expected HTTP 200, actual 200; semantic true; database unchanged false.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"foreignUrlPersisted":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-708 — failed profile update retains old reference and upload

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"unlinkedUploadRetained":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-709 — draft deletion orphan lifecycle

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged false.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"draftRemoved":true,"orphanFileRetained":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-710 — explicit file deletion reference consistency

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"referenceRetained":true,"fileRemoved":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-711 — duplicate references survive forbidden foreign deletion

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[]`

## VOCLE-712 — upload survives rejected foreign destination send

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/features/media/media.routes.js, src/features/media/media.controller.js, src/utils/localMediaStorage.js.

Evidence: `{"uploadStatus":200,"unlinkedUploadRetained":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-713 — handoff rejects untrusted attachment URL

OBSERVATION; expected HTTP 400, actual 200; semantic false; database unchanged false.

Sources: src/features/handoffs/handoff.controller.js:updateHandoff, src/features/handoffs/handoff.model.js.

Evidence: `{"uploadStatus":200,"authorizedControl":true,"foreignUrlPersisted":true}`

SDK calls (simulated boundary): `[]`

## VOCLE-714 — message media validates alternate cloud provenance

OBSERVATION; expected HTTP 400, actual 201; semantic false; database unchanged false.

Sources: src/features/messages/message.controller.js:sendMessage, src/features/messages/message.model.js.

Evidence: `{"authorizedControl":true,"messagesPersisted":2}`

SDK calls (simulated boundary): `[]`

## VOCLE-715 — message media validates untrusted thumbnail

OBSERVATION; expected HTTP 400, actual 201; semantic false; database unchanged false.

Sources: src/features/messages/message.controller.js:sendMessage, src/features/messages/message.model.js.

Evidence: `{"authorizedControl":true,"messagesPersisted":2}`

SDK calls (simulated boundary): `[]`

## VOCLE-716 — message media validates negative size and dimensions

OBSERVATION; expected HTTP 400, actual 201; semantic false; database unchanged false.

Sources: src/features/messages/message.controller.js:sendMessage, src/features/messages/message.model.js.

Evidence: `{"authorizedControl":true,"messagesPersisted":2}`

SDK calls (simulated boundary): `[]`

## VOCLE-717 — message media validates missing image media URL

OBSERVATION; expected HTTP 400, actual 201; semantic false; database unchanged false.

Sources: src/features/messages/message.controller.js:sendMessage, src/features/messages/message.model.js.

Evidence: `{"authorizedControl":true,"messagesPersisted":2}`

SDK calls (simulated boundary): `[]`

## VOCLE-718 — SDK authenticated message folder

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-719 — SDK authenticated avatar folder

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/avatars/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/avatars/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-720 — SDK authenticated unknown folder

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-721 — SDK shared handoff has caller ownership namespace

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/handoffs","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/handoffs/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-722 — SDK resource type PDF

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"requestedResourceType":"raw"}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"raw","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":344,"sha256":"b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"raw","flags":"attachment:synthetic.pdf","secure":true}},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"image","format":"webp","width":400,"height":300,"crop":"fill","page":1}}]`

## VOCLE-723 — SDK resource type video

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"requestedResourceType":"video"}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"video","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":1509,"sha256":"d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"video","format":"jpg","start_offset":"0","width":400,"crop":"limit","secure":true}}]`

## VOCLE-724 — SDK resource type octet PDF

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"requestedResourceType":"image"}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":344,"sha256":"b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78"}]`

## VOCLE-725 — SDK resource type octet video

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"requestedResourceType":"image"}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":1509,"sha256":"d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7"}]`

## VOCLE-726 — SDK filename metadata sanitized and bounded

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-727 — SDK explicit overwrite prevention

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-728 — SDK caller options cannot select identity or transformation

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-729 — SDK image thumbnail exact requested transform

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-730 — SDK video thumbnail exact requested transform

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"video","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":1509,"sha256":"d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"video","format":"jpg","start_offset":"0","width":400,"crop":"limit","secure":true}}]`

## VOCLE-731 — SDK PDF raw attachment and preview call capture

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"raw","use_filename":true,"unique_filename":true,"filename_override":"synthetic report"},"bytes":344,"sha256":"b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"raw","flags":"attachment:synthetic_report.pdf","secure":true}},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"image","format":"webp","width":400,"height":300,"crop":"fill","page":1}}]`

## VOCLE-732 — SDK PDF preview builder failure is contained

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"raw","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":344,"sha256":"b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"raw","flags":"attachment:synthetic.pdf","secure":true}},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"image","format":"webp","width":400,"height":300,"crop":"fill","page":1}}]`

## VOCLE-733 — SDK prototype-like context denied before upload

OBSERVATION; expected HTTP 400, actual 500; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":500}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"[function]","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"}]`

## VOCLE-734 — SDK owner image delete operation

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"destroyTypes":["image"],"simulatedAssetRetained":false}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}},{"operation":"destroy","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"image"}}]`

## VOCLE-735 — SDK owner raw delete operation

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"destroyTypes":["image","raw"],"simulatedAssetRetained":false}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"raw","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":344,"sha256":"b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"raw","flags":"attachment:synthetic.pdf","secure":true}},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"image","format":"webp","width":400,"height":300,"crop":"fill","page":1}},{"operation":"destroy","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"image"}},{"operation":"destroy","publicId":"medcollab/messages/7ed000000000000000000001/canary-1.pdf","options":{"resource_type":"raw"}}]`

## VOCLE-736 — SDK owner video delete operation

OBSERVATION; expected HTTP 200, actual 404; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"destroyTypes":["image","raw"],"simulatedAssetRetained":true}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"video","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":1509,"sha256":"d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"video","format":"jpg","start_offset":"0","width":400,"crop":"limit","secure":true}},{"operation":"destroy","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"image"}},{"operation":"destroy","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"raw"}}]`

## VOCLE-737 — SDK deletion requests CDN invalidation

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}},{"operation":"destroy","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"image"}}]`

## VOCLE-738 — SDK foreign owner rejected without destroy

PASS; expected HTTP 403, actual 403; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-739 — SDK delete rejects namespace containing embedded owner

OBSERVATION; expected HTTP 400/403/404, actual 404; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"destroyDispatches":2}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}},{"operation":"destroy","publicId":"foreign-root/messages/7ed000000000000000000001/unregistered-canary","options":{"resource_type":"image"}},{"operation":"destroy","publicId":"foreign-root/messages/7ed000000000000000000001/unregistered-canary","options":{"resource_type":"raw"}}]`

## VOCLE-740 — SDK owner handoff deletion reaches exact asset

OBSERVATION; expected HTTP 200, actual 403; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/handoffs","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/handoffs/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-741 — SDK duplicate original names request unique identity

PASS; expected HTTP 200, actual 200; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}},{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-2","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-742 — SDK upload callback failure preserves database

PASS; expected HTTP 500, actual 500; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":500,"authorizedControl":true}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}},{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"}]`

## VOCLE-743 — SDK success then URL failure compensates upload

OBSERVATION; expected HTTP 500, actual 500; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":500,"authorizedControl":true,"simulatedOrphanCount":1}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}},{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-2","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-744 — SDK destroy callback failure preserves asset and reference

PASS; expected HTTP 500, actual 500; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}},{"operation":"destroy","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"image"}}]`

## VOCLE-745 — SDK uploaded image to authorized message persists reference

PASS; expected HTTP 201, actual 201; semantic true; database unchanged false.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js, src/features/messages/message.controller.js:sendMessage.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-746 — SDK video upload to message compatibility

OBSERVATION; expected HTTP 201, actual 400; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js, src/middleware/validate.js:validateSendMessage.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"video","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":1509,"sha256":"d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"resource_type":"video","format":"jpg","start_offset":"0","width":400,"crop":"limit","secure":true}}]`

## VOCLE-747 — SDK message soft-delete storage lifecycle

OBSERVATION; expected HTTP 200, actual 200; semantic false; database unchanged false.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js, src/features/messages/message.controller.js:deleteMessage, src/features/messages/message.model.js:pre-save.

Evidence: `{"uploadStatus":200,"messageBlanked":true,"simulatedAssetRetained":true}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-748 — SDK avatar replacement call lifecycle characterization

PASS; expected HTTP 200, actual 200; semantic true; database unchanged false.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"previousSimulatedAssetRetained":true}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/avatars/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/avatars/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}},{"operation":"upload_stream","options":{"folder":"medcollab/avatars/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/avatars/7ed000000000000000000001/canary-2","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-749 — SDK foreign-space uploaded reference characterization

PASS; expected HTTP 201, actual 201; semantic true; database unchanged false.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200,"foreignAssetUrlPersisted":true}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000003","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":68,"sha256":"9f81650ff972f04ecb98e05d93c4cc65f22fb721385b8529d3ae3c00d479f786"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000003/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-750 — SDK empty upload denied before stream invocation

OBSERVATION; expected HTTP 400, actual 200; semantic false; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":200}`

SDK calls (simulated boundary): `[{"operation":"upload_stream","options":{"folder":"medcollab/messages/7ed000000000000000000001","resource_type":"image","use_filename":true,"unique_filename":true,"filename_override":"synthetic"},"bytes":0,"sha256":"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"},{"operation":"url","publicId":"medcollab/messages/7ed000000000000000000001/canary-1","options":{"width":400,"height":400,"crop":"limit","quality":"auto","format":"webp"}}]`

## VOCLE-751 — SDK oversized upload denied before stream invocation

PASS; expected HTTP 400, actual 400; semantic true; database unchanged true.

Sources: src/config/cloudinary.js, src/features/media/media.controller.js, src/features/media/media.routes.js.

Evidence: `{"uploadStatus":400}`

SDK calls (simulated boundary): `[]`
