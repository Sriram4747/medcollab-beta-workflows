# Local media storage and offline Cloudinary SDK contracts — 2026-10-04

Stages 1 and 2 implemented and validated in hosted [run 37181051425](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37181051425), executed source `dca95d019fddf792adae7fcd4c21b5bc649c2b30`: **97/97 executed, 62 passes, 35 observations; infrastructure healthy**. All job steps, artifact upload and disposable MongoDB cleanup succeeded. No application vulnerability was fixed. Only experimental `origin/master` was written. Stage 3 remains unimplemented, with no real Cloudinary account, credentials or requests.

## Counts and evidence

| Module | Stable IDs | Executed | Pass | Observation |
| --- | --- | --- | --- | --- |
| Existing Media | 295–323, 330–331 | 31 | 22 | 9 |
| Existing adjacent Cross-module | 324–329 | 6 | 6 | 0 |
| New Local Media Storage Lifecycle | 692–717 | 26 | 13 | 13 |
| New Offline Cloudinary SDK Contract | 718–751 | 34 | 21 | 13 |
| Dedicated run | 37 existing + 60 new | 97 | 62 | 35 |

Combined catalog: **751**, unchanged 691 plus 60 append-only IDs. All existing 37 pass/observation and HTTP-status outcomes match the [691-case baseline](security-evidence/37175207493/execution.json); its manifest hash remains pinned. The general API suite was not rerun: **611 passes / 80 observations, 77/77 exercised HTTP operations** remain historical evidence. Combining that baseline with 60 newly executed cases yields **645 passes / 106 observations across 751 registered cases**, a historical evidence union, not one fresh 751-case execution. No new route-discovery denominator is claimed.

Final [raw results](security-evidence/37181051425/results.json), [summary](security-evidence/37181051425/summary.md), [per-case report](security-evidence/37181051425/security-test-report.md), [frozen manifest](security-evidence/37181051425/manifest.json), [reviewed observations](security-evidence/37181051425/reviewed-observations.json) and [execution/hashes](security-evidence/37181051425/execution.json) are retained. Artifact `vocle-offline-media-security`, ID **11295208808**; verified archive SHA-256 **`5a5baa36a4ec54cc4a1076cd371aac2e1a72d41d09183c4d8ef0f3efd132df40`**. Review JSON preserves expected/actual, source paths, file hashes, SDK calls and raw classifications separately from reviewed dispositions.

First healthy [run 37180593760](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37180593760), source `6c26aadeb0bb98e21e84a3a72ccc04072ba8df87`, also completed 97/97, 62/35. Its reports/review/hash metadata remain in [37180593760](security-evidence/37180593760/execution.json). Artifact ID **11294579362**, archive SHA-256 **`197f9a6e2e156e5d199c3bd15ea7e65db4d140ed0bccac675f0ef646baeee0cc`**. Final run pins the recovered synthetic MP4 and strengthens valid controls without weakening expectations. Existing and new outcomes match across both healthy runs.

## Reviewed observations

| Cases | Expected versus actual and disposition | Relevant source |
| --- | --- | --- |
| 301–304, 699–700 | Malformed/unsupported upload should reject 400; rejects 500, no storage. Existing H2 error mapping. | Media routes/error middleware |
| 306–307, 698 | Empty/mismatched/malformed inert bytes should reject; stored 200. Existing H3 byte-validation hardening. | Media controller/local storage |
| 313–314, 704 | Canonical foreign owner file should survive; caller-substring dot-segment ID deletes exact synthetic foreign file, 200. **Confirmed S6**, extended to avatars. | `media.controller.js:deleteFile`, `localMediaStorage.js:deleteLocalUpload` |
| 323 | Valid local upload should attach to authorized message; HTTP URL fails HTTPS/Cloudinary host contract, 400. Retained U1 compatibility. | `message.controller.js:sendMessage` |
| 701 | Octet-stream MP4 should report video; exact bytes retained, format null, 200. Metadata compatibility. | Media upload MIME dispatch |
| 705 | Owner should delete handoff upload; shared folder fails ownership, 403, file remains. Lifecycle hardening. | Media folder/delete ownership |
| 709–710 | Draft/reference and storage should reconcile; draft deletion leaves bytes, media deletion leaves handoff URL. **Retention/lifecycle policy decisions required**. | Handoff/media delete and handoff model |
| 713 | Untrusted handoff URL should reject; persists 200 after valid attachment control. Validation hardening, no URL fetched. | Handoff update/model |
| 714–717 | Alternate-cloud provenance, foreign thumbnail, negative dimensions/size or absent image URL should reject; persists 201 after authorized create/read controls. Validation/provenance hardening, sharing policy unresolved. | Message controller/model |
| 721, 740 | Handoff should have owner identity/deletability; shared folder, then 403 and **zero destroy calls**. Lifecycle hardening. | Media folder/delete ownership |
| 724–725 | Valid octet-PDF/MP4 should select raw/video; **both request image**, exact bytes/hash recorded. Confirmed call-contract defects. | MIME-only upload dispatch |
| 727 | Explicit overwrite prevention expected; `overwrite:false` omitted, `unique_filename:true` present. Hardening, no actual overwrite shown. | Upload options |
| 733 | Prototype-like context should reject before SDK; `constructor` selects a function as folder and invokes upload_stream. Double rejects, 500. Input hardening; fake rejection is not real SDK behavior. | `folderMap[context]` |
| 736 | Video owner delete should dispatch video; **image then raw only**, simulated 404/video remains. Confirmed call-contract defect. | Media delete dispatch |
| 737 | Invalidation expected; `invalidate` omitted. Call hardening, no real cache test. | Destroy options |
| 739 | Foreign namespace with embedded caller should reject before SDK; dispatches two destroys for `foreign-root/messages/<caller>/unregistered-canary`, simulated 404. Namespace hardening. **No real Cloudinary IDOR/deletion proven**; review narrows raw automatic classification. | Substring ownership |
| 743 | Upload success then URL-builder failure should compensate; generic 500, one new simulated orphan, no destroy. Partial-failure hardening. | Upload catch path |
| 746 | Uploaded video should be accepted by message type; actual validator rejects `type=video`, 400. Compatibility issue. | `validate.js:validateSendMessage` |
| 747 | Soft-delete cleanup expectation fails: real message blanked, no destroy, simulated asset remains. Retention policy unresolved. | Message delete/model hook |
| 750 | Empty bytes should reject before SDK; upload_stream receives zero bytes, simulated 200. H3 application pre-SDK validation. | Media route/controller |

Source paths above are under `medcollab-backend/src/`; exact full paths and evidence are attached to every reviewed case. No observation was changed to PASS, application fix made, or strict gate activated. New observations comprise **one confirmed local S6 variant, three exact call-contract defects and 22 validation, compatibility, namespace, lifecycle or policy observations**. Existing gate registry remains historical pending separate remediation/gate work.

Passing characterization does not approve sharing/retention policy. **706/748** retain old avatars; **707** accepts a foreign avatar reference; **708/712** retain uploads after rejected profile/message writes; **749** permits a foreign-space upload URL in an authorized channel while confirming the caller cannot read the foreign channel. These establish application behavior, not confidential delivery or asset ownership. Other passes cover identity denials, duplicate/unsafe names, ordinary avatar owner/foreign deletion, duplicate references, forged SDK options ignored, exact transforms, image/raw delete dispatch, foreign-owner denial, error containment and above-limit rejection.

## Safety and proof boundary

Actual cases run in a Node container sharing disposable MongoDB's **Docker `--network none` namespace**, with explicit synthetic environment and read-only source mount. Runtime verifies **only `lo`, zero external routes**. Socket/DNS/TLS/HTTPS/fetch guards permit only `127.0.0.1:5000/27017`; fetch requires `redirect:error`. Provider/proxy environment values and credential `.env` files are prohibited. No real cloud name, API key/secret, `CLOUDINARY_URL` or provider credentials are passed. The URL path `offline-contract` is a fictitious double label. Dependencies/images are fetched before isolated case execution.

SDK replacement occurs before application imports. Actual config initially reports unconfigured; only a **test-only exported configuration predicate override** selects contract mode. Real authorization, routes, controllers, models and local filesystem execute. Every readiness/state snapshot checks injected SDK object identity, interception count, real SDK absent from require.cache, no forbidden SDK methods and zero blocked network attempts. The double records exact streamed bytes/hash/options, destroy IDs/options and URL builder IDs/options; generated IDs, URLs, callbacks and asset inventory remain simulation.

Self-test deliberately attempts six denied networking operations and blocks each before I/O. Hosted parent and all backend snapshots report **blocked:0**, SDK replaced, real SDK absent. Network isolation independently blocks external reachability. All 97 cleanup records confirm files removed/backend stopped/simulated state discarded; workflow stops MongoDB. Source fingerprint before/after matches: `5b79b2a621d639303c5201cb43de5dc8ff0c8a3df19866912ff176374eb32df5`. Backend logs/raw auth bodies/tokens are discarded; sanitized evidence contains no authorization tokens.

Fixed PNG, authored one-page PDF with calculated xref offsets and versioned black 16×16 single-frame MP4 are inert synthetic fixtures. MP4: 1,509 bytes, hash **`d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7`**. Final suite requires no FFmpeg/media download; no clinical/identifying content is present.

This proves real local behavior and exact SDK call intent for bounded synthetic scenarios. It does **not** prove actual provider storage/deletion, SDK signing/serialization, decoding/transcoding, ID/folder normalization/uniqueness, presets/account policy, confidential delivery, PDF preview success, CDN invalidation/cache eviction, remote reconciliation or production configuration. The double never decodes content; valid fixtures do not supply integration evidence.

## Infrastructure and changed files

Initial [run 37180497917](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37180497917), source `68f217c607cc801b7559c426f5c53d9ae68050e6`, stopped **before cases** because hosted Ubuntu lacked FFmpeg for fixture authoring. Syntax/manifests/self-test passed; no case result/artifact credited. Fix `6c26aad` conditionally installed the authoring tool and produced the synthetic MP4; first healthy run executed all cases. Final `dca95d0` versions/hash-pins those bytes, removes CI authoring/tool installation and smoke fallback bytes, uses a signature-tampered valid JWT, and strengthens valid upload/attachment/message-reader/fault controls. No assertion was weakened. Local Windows lacks Docker/disposable MongoDB; local syntax/manifests/offline self-test pass and hosted isolated execution supplies full evidence.

Created `.github/workflows/vocle-media-security.yml` and modular `medcollab-backend/scripts/security-media/`: `guard.js`, `sdk-double.js`, `server.js`, `fixtures.js`, `helpers.js`, `local-cases.js`, `contract-cases.js`, `catalog.js`, `check.js`, `self-test.js`, `run.js`, frozen `manifest.json`, `fixtures/canary.mp4` and its README. Updated this report, progress, coverage, findings, media manifest and Cloudinary design; retained both healthy run directories with four raw reports and review/execution hashes each, plus [the initial infrastructure failure record](security-evidence/37180497917/execution.json). Narrow `.gitattributes` rules preserve these exact evidence bytes across checkouts. Original generic suite, backend application source and unrelated Flutter/Android changes remain untouched. Final evidence commit changes documentation/reports and their byte-preservation attributes only relative to tested `dca95d0`.

## Stage 3 remains deferred

Use the separately authorized disposable non-production environment and guarded broker/attestation in [the design](SECURITY_CLOUDINARY_MEDIA_DESIGN_2026-10-04.md). Do not reuse the predicate override/double for live tests. Independent cleanup must use **actual returned public ID + resource type + delivery type**, because app deletion cannot remove videos/handoffs and upload may fail after success. Preserve wrong octet dispatch while independently measuring real acceptance. Verify PDF raw and derived-preview retrieval separately; URL building is insufficient. Resolve message `type=video` compatibility before treating upload→message as a positive end-to-end oracle. Test provider normalization, collisions/overwrite, empty-content rejection, permissions/presets, CDN invalidation and reconciliation only in an owned canary namespace. No live environment, broker, credentials or traffic was implemented.
