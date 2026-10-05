# Real Cloudinary integration security — 2026-10-05

**Stages 3/4 bounded real-provider validation completed** in [run 37355451614](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37355451614), executed source `a3432300d3827bb0f5eca1a1a2033ec48929707b`: **34/34 executed, 25 passes, nine observations, healthy infrastructure**. Independent finally and post-job cleanup confirmed **13/13 exact resources absent**. New cases **VOCLE-752–785**, combined catalog 785. General 691/offline 97 suites were not rerun, replaced or rewritten. No application vulnerability fixed. Production and upstream untouched.

## Verified provider outcomes and reviewed observations

[Final raw results](security-evidence/37355451614/results.json), [resources](security-evidence/37355451614/resources.json), [finally cleanup](security-evidence/37355451614/cleanup.json), [post-job cleanup](security-evidence/37355451614/post-job-cleanup.json), [reviewed observations](security-evidence/37355451614/reviewed-observations.json), [execution/hashes](security-evidence/37355451614/execution.json). Artifact `vocle-real-cloudinary-security`, ID 11363749221, archive SHA-256 `6d13120f75872d6fe3dbbb68de1be15417d6562e99121a195ce95a3312be6d30`. Every job step succeeded, including safety preflight, offline checks, both cleanup passes, hygiene and artifact upload.

| Boundary | Actual test-account behavior |
| --- | --- |
| Configuration/identity | Independent positive cloud-variable equality passed before SDK initialization. Signed upload accepted; returned cloud/path/type and exact resource metadata matched. All 83 main-run requests (68 API + 15 CDN), including finally cleanup, stayed within approved endpoints/cloud; zero blocked attempts. Post-job independently rechecked all 13 identities/absence. |
| Image | PNG stored as image/upload, 1×1, 70 bytes. Exact metadata and original HTTPS delivery200; returned PNG hash equals input. Unsigned image delivery200 is characterization, not confidentiality policy approval. Controller400×400 limit/quality-auto WebP thumbnail retrieves200. |
| Video | MP4 stored as video/upload,16×16, 1,509 bytes. Exact original HTTPS bytes/hash and JPG-frame transformation retrieve200. Explicit video destroy returnsok; exact origin absent; repeat notfound. |
| Raw/PDF | PDF stored raw/upload,344 bytes, format/dimensions null; direct HTTPS delivery200 exact input bytes as application/octet-stream. Plain raw attachment flag also delivers200. Application named attachment flag returns400. Raw exact delete works; replay notfound. |
| PDF transformations | Application raw-public-ID image preview returns404. Independent same synthetic PDF stored as image/pdf previews successfully as WebP200. This account supports bounded image-PDF decoding/preview; the observed application raw→image assumption fails. |
| Naming/isolation | Same-folder duplicates get distinct generated IDs and both exist; filename_override influences IDs. Unsafe original filename remains under exact run/operation folder, with no dot path segments. Image/raw may share public ID with separate resource identities. No broad enumeration. |
| Overwrite | Explicit overwrite:false returns existing:true and preserves identity/version/black-PNG bytes despite attempted white-PNG replacement. overwrite:true accepts replacement, returns later version and exact white-PNG bytes. These probes are broker/provider controls: application still omits explicit overwrite:false; no production overwrite policy claim. |
| Delete/delivery | Application image/raw deletion removes exact origins; independent typed video deletion removes video. Image/video/raw original URLs still deliver200 exact cached bytes immediately after non-invalidating deletion; origins are absent. Eventual cache purge and revocation are not proven. |
| Cleanup |16 upload intents, one explicit provider400 rejection, zero pending;13 unique records (10 image,1 video,2 raw). Finally and post-job cleanup verify13/13 origins absent, including handoff, image-PDF preview control and all naming/overwrite records. No cleanup outside manifest/root; no broad deletion. |

The nine observations are six application compatibility/lifecycle cases and three CDN/cache cases:

| Cases | Expected versus actual / disposition |
| --- | --- |
| 762 → existing736 | App owner delete should remove video;404, image/raw only, video remains. Explicit typed deletion works. Existing defect confirmed. |
| 770 → offline731 | App PDF attachment URL should retrieve stored raw PDF;400 while direct and plain-attachment controls return200 exact bytes. **Newly confirmed application/provider URL compatibility defect**, not evidence of account-wide raw-delivery denial. |
| 771 → offline731 | Raw PDF preview should retrieve image;404 while correctly typed image-PDF control returns WebP200. **Newly confirmed application raw/image preview contract defect**; no global PDF-preview restriction inferred. |
| 765,773,776 → offline737 context | Immediate delivery denial expected after removal; all three original URLs return200 exact bytes despite absent origins. Provider/cache characterization; source omits invalidation. Does not prove eventual invalidation, failed origin deletion or production access policy. |
| 782 → existing724 | Octet-PDF should selectraw; app requestsimage, provider accepts/storesimage/pdf, app200. Existing MIME-only dispatch defect confirmed. |
| 783 → existing725 | Octet-MP4 should selectvideo; requestsimage, provider400, app500, no created resource. Existing MIME-only dispatch defect confirmed. |
| 784 → existing740 | Handoff uploader should delete own asset;403 and retained because shared folder fails app ownership. Scoped independent janitor removes it. Existing lifecycle limitation confirmed. |

No separate provider defect/configuration root is inferred. Observed raw content-type, generated IDs, PDF support, cached delivery and overwrite/resource-type separation are test-account/provider behavior only. Existing app defects are linked, not duplicated; no remediation or strict gate activation.

## First run and harness refinement

[First run 37354536880](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/37354536880), source 73aa4db9f965cbaf460a35d861745ff058e9d361: 34/34,24 passes/10 observations; infrastructure healthy and12/12 origins absent in both cleanup passes. [Raw evidence/review/hash metadata](security-evidence/37354536880/execution.json) preserved unchanged. Artifact 11363648476; SHA-256 `d476d97866e056ccf68af1f7d969f17a19dca138772098da2bc5ef56d3d0784e`.

Its781 naming observation was a harness false positive: an ID basename containing `.._._` remains a normal path segment inside the exact namespace. The old substring oracle rejected it. The corrected oracle checks exact operation folder and canonical segments, retaining the frozen ID/name/expectation and safety containment. Only781 changes status across runs; all nine genuine observations persist. Overwrite controls now prove different-byte preservation/replacement and fix the offline transport double's serialized boolean handling. PDF controls distinguish provider support from app URL failures. No expectation/ID was deleted and original reports were not rewritten.

## Safety boundary and enablement

The owner authorizes only the completely separate synthetic test account and existing repository secrets `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`. Values never appear in source, logs, artifacts or documentation. Independently configure repository Actions variable **`CLOUDINARY_TEST_CLOUD_NAME`** with the exact cloud name shown for the isolated account. The harness requires **literal equality** with `CLOUDINARY_CLOUD_NAME` before importing/configuring the SDK or any provider request. Missing expected cloud, mismatch, missing credentials, non-test mode, production-like cloud/environment, unexpected provider/proxy/SDK config, credential files or unsafe namespace blocks execution.

In [the fork's Actions settings](https://github.com/Sriram4747/medcollab-beta-workflows/settings/variables/actions), choose **Settings → Secrets and variables → Actions → Variables → New repository variable**. Name: `CLOUDINARY_TEST_CLOUD_NAME`. Value: exact cloud name from the isolated non-production account, independently checked against its dashboard. Do not automatically derive it from the secret or put API credentials into variables. Save with **Add variable**. No credentials need to be pasted into Codex. Then dispatch **Vocle Real Cloudinary Security** on `master`.

Repository/ref/event/workflow are fixed to this fork, master, workflow_dispatch and the dedicated workflow. No arbitrary cloud/namespace/endpoint dispatch inputs, push/PR provider triggers or upstream operations. Permissions: contents:read. Secrets only reach preflight, real execution, scoped post-job cleanup and artifact hygiene; dependencies/offline checks receive none.

Run namespace: **`medcollab/security-test/<run-id>-<attempt>-<uuid>/`**, persisted before any provider operation. Controller folders are prefixed under independent operation children while retaining message/avatar/synthetic-owner/handoff structure. Normal app folders are never written. Returned public IDs must match the root AND operation folder; type, delivery type, immutable asset ID and version are durably recorded before URL construction. Incompatible folder behavior fails; no guessed/broad deletion. No production cloud identifier was documented or discovered. Positive allowlisting is primary; a production/live name deny guard is additional protection.

## Integration scope and prior design

The lane invokes the **unchanged real media controller**, fixed synthetic file objects/user ID, **real config predicate**, real SDK and signed provider requests. Live mode uses no SDK double/predicate override. Broker validates original option contracts, prefixes folders, journals resources and restricts transport. This is controller/provider integration: authentication, multipart parsing, rate limits and reference/database sinks remain historical Stage1/2 evidence. No new HTTP inventory credit; no MongoDB, backend server, Firebase or MSG91 startup.

Current owner authorization supersedes earlier proposed provisioning: existing repository secrets plus independently approved cloud variable bind a wholly separate test account. Optional owner-provisioned identity marker, key fingerprint, protected Environment/reviewer and Console policy attestation from the old design are **not claimed implemented**; no extra approval is inferred. Signed synthetic upload/exact resource reads verify actual credentials/provider behavior after positive local binding. Effective key roles, settings, backups/retention and strict transforms remain unverified without test-account administrator evidence.

SDK URL analytics are disabled in the test transport; CDN URLs allow no queries. API egress: HTTPS `api.cloudinary.com`, exact approved cloud path, one-request capabilities for image/video/raw upload/destroy and exact registered-resource reads. CDN: HTTPS `res.cloudinary.com`, approved cloud, exact registered IDs and bounded controller transforms only. Redirects are not followed. Unknown hosts/clouds/URLs/operations or deletion targets are denied before I/O. This process imports no production startup/dotenv. Application source is fingerprinted before/after and no vulnerability is fixed.

## Stable scenarios

| Cases | Scope |
| --- | --- |
| 752 | Positive allowlist, signed synthetic smoke, returned cloud/resource identity |
| 753–757 | PNG controller upload, exact metadata, HTTPS original, limit WebP thumbnail, unsigned delivery characterization |
| 758–766 | MP4 upload/identity, original/JPG frame delivery, app deletion limitation, explicit video delete, origin disappearance, post-delete CDN behavior/replay |
| 767–774 | Raw PDF upload/identity, original/attachment delivery, actual image-preview compatibility, app image→raw deletion, disappearance/retrieval/replay |
| 775–776 | App image deletion, exact disappearance, subsequent retrieval and replay |
| 777–781 | Same-folder duplicate filenames/generated IDs, explicit overwrite false/true, image/raw same-ID separation, unsafe filename isolation |
| 782–783 | Octet-PDF/MP4 actual image dispatch and provider acceptance/rejection; linked to 724–725 |
| 784 | Shared handoff upload/owner deletion; linked to 740 |
| 785 | Independent image/video/raw manifest cleanup and exact origin absence |

Only tiny synthetic black/white PNGs, authored one-page PDF and versioned 1,509-byte Stage 2 MP4 (SHA-256 `d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7`). No real users/phones/clinical data. Owned overwrite probes use distinguishable synthetic bytes; they do not approve production overwrite or prove retained-version/backup semantics. Raw storage/delivery and image PDF preview are separate outcomes. Exact authenticated origin absence is independent of CDN/cache behavior.

Expected/actual application/provider mismatches remain non-gating observations with existing-case links. Environment, credentials/permissions/transport, identity/namespace/contract, exact-read, secret-reporting and cleanup failures block. Valid upload controls must succeed. Broker safety failures cannot be swallowed as controller500 observations. Response status is controller response, not route execution.

## Cleanup and evidence

Every upload has a durable credential-free intent: planned operation folder/type, synthetic bytes/hash and original/effective options. Success journals actual public ID, asset ID, type and version before application URL work. Independent cleanup in `finally` then workflow `if: always()` destroys **only explicitly recorded current-run resources**, actual image/video/raw and delivery type, `invalidate:true`. Exact metadata reads confirm absence with bounded retry. Cleanup continues across failures; remaining/unverified resources fail the job. No account-wide enumeration, prefix search or bulk deletion.

App deletion tests preserve image→raw guesses for registered IDs, including video; janitor uses actual recorded type. Lost upload response leaves a pending intent and **unproven cleanup**. No identity guesses or broad reconciliation. SIGINT/SIGTERM request orderly stopping between bounded operations; forced runner loss can defeat finally/post-job cleanup. Cancellation handling is best effort, not a guaranteed remote janitor. Review exact manifests in the isolated test account before declaring such a run clean.

Artifacts: safety/resources/manifest/results/cleanup/post-job-cleanup JSON and summary/per-case Markdown. Full SDK responses/errors, signatures, headers, cloud name and credentials are excluded. Separate artifact hygiene must pass before upload. Reports bind run/attempt/source and source fingerprint; historical evidence is preserved.

Local verification: syntax/frozen manifests, workflow YAML/manual-trigger/allowlist/artifact gate, **49 offline safety checks**, final real-SDK/controller/broker offline roundtrip (**85 intercepted requests**, all manifest types cleaned, zero network I/O). These prove wiring only; hosted runs independently supply real-provider evidence.

## Historical enablement blocker (resolved before live execution)

After pushing source `14eb050e2a6af98569ea1b8fd34d75fdfabc03fc` to origin/master, GitHub's exact variable lookup returned 404; the repository variable list succeeded with **zero variables**. Secret-name metadata confirms the three required secrets exist; values were not requested. [Vocle Real Cloudinary Security](https://github.com/Sriram4747/medcollab-beta-workflows/actions/workflows/vocle-cloudinary-security.yml) is registered (workflow 375677595). **No dispatch was issued**, as required by the positive-allowlist boundary.

At that historical checkpoint, hosted run/counts were none/0 and no provider requests or resources existed. The owner subsequently added the independently approved repository variable. Its nonempty presence was checked without displaying values; both live preflights verified exact secret/variable equality. Current hosted evidence is at the top of this report. The original [blocked metadata](security-evidence/cloudinary-blocked-2026-10-05/execution.json) remains unchanged.

Remaining security work is separate application remediation/policy (video/handoff deletion, MIME dispatch, PDF URL contracts and delivery revocation), then focused regression gating after authorization. Test-account roles, backups/retention, strict-transform/Console settings, confidential media delivery policy, eventual invalidation/derived cache eviction and forced-cancellation remote reconciliation remain explicitly outside verified coverage. This bounded phase has no unresolved infrastructure failure or pending cleanup intent. **No production Cloudinary access occurred**; upstream and unrelated Flutter/Android changes remain untouched.

The integration PNG is newly authored with correct CRCs; the earlier offline-only PNG's invalid IDAT CRC and historical results are preserved. No offline fixture was upgraded or re-credited as decoder-valid provider evidence.

Files: dedicated workflow; modular `scripts/security-cloudinary/{guard,broker,fixtures,cases,check,self-test,transport-test,run}.js` and frozen `manifest.json`; this report and continuity pointers. Backend application source and unrelated Flutter/Android changes remain untouched. Historical Stage1/2/general evidence is authoritative for its own scope.
