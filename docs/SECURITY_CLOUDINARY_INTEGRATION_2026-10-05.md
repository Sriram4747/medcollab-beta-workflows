# Real Cloudinary integration security — 2026-10-05

Implementation pushed; **external execution blocked because `CLOUDINARY_TEST_CLOUD_NAME` is missing**. Dedicated registered manual workflow: `.github/workflows/vocle-cloudinary-security.yml`. New frozen manifest: **34 cases, VOCLE-752–785**, appended after unchanged catalog751. Combined registered catalog: **785**. The original general691/offline97 suites were not rerun, replaced or rewritten; their historical evidence remains unchanged.

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

Only tiny synthetic PNG, authored one-page PDF and versioned 1,509-byte Stage2 MP4 (SHA-256 `d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7`). No real users/phones/clinical data. Owned overwrite probes use identical synthetic bytes; they do not approve production overwrite or prove retained-version/backup semantics. Raw storage/delivery and image PDF preview are separate results; preview support is not assumed. Exact authenticated origin absence is independent of CDN/cache behavior.

Expected/actual application/provider mismatches remain non-gating observations with existing-case links. Environment, credentials/permissions/transport, identity/namespace/contract, exact-read, secret-reporting and cleanup failures block. Valid upload controls must succeed. Broker safety failures cannot be swallowed as controller500 observations. Response status is controller response, not route execution.

## Cleanup and evidence

Every upload has a durable credential-free intent: planned operation folder/type, synthetic bytes/hash and original/effective options. Success journals actual public ID, asset ID, type and version before application URL work. Independent cleanup in `finally` then workflow `if: always()` destroys **only explicitly recorded current-run resources**, actual image/video/raw and delivery type, `invalidate:true`. Exact metadata reads confirm absence with bounded retry. Cleanup continues across failures; remaining/unverified resources fail the job. No account-wide enumeration, prefix search or bulk deletion.

App deletion tests preserve image→raw guesses for registered IDs, including video; janitor uses actual recorded type. Lost upload response leaves a pending intent and **unproven cleanup**. No identity guesses or broad reconciliation. SIGINT/SIGTERM request orderly stopping between bounded operations; forced runner loss can defeat finally/post-job cleanup. Cancellation handling is best effort, not a guaranteed remote janitor. Review exact manifests in the isolated test account before declaring such a run clean.

Artifacts: safety/resources/manifest/results/cleanup/post-job-cleanup JSON and summary/per-case Markdown. Full SDK responses/errors, signatures, headers, cloud name and credentials are excluded. Separate artifact hygiene must pass before upload. Reports bind run/attempt/source and source fingerprint; historical evidence is preserved.

Local verification: syntax/frozen manifests, workflow YAML/manual-trigger/allowlist/artifact gate, **49 offline safety checks**, real-SDK/controller/broker offline transport roundtrip (**77 intercepted requests**, all manifest types cleaned, zero network I/O). These prove wiring only and contribute **zero real-provider passes/observations**.

## Execution status

After pushing source `14eb050e2a6af98569ea1b8fd34d75fdfabc03fc` to origin/master, GitHub's exact variable lookup returned 404; the repository variable list succeeded with **zero variables**. Secret-name metadata confirms the three required secrets exist; values were not requested. [Vocle Real Cloudinary Security](https://github.com/Sriram4747/medcollab-beta-workflows/actions/workflows/vocle-cloudinary-security.yml) is registered (workflow375677595). **No dispatch was issued**, as required by the positive-allowlist boundary.

Latest hosted integration run ID/link: **none**. Live executed/pass/observation counts: **0/0/0**; this is an enablement blocker, not a provider outcome. Image/video/raw upload, retrieval, transformations, delete/disappearance, naming/overwrite/isolation and live cleanup remain **unverified**. No real-provider application/configuration findings claimed. No assets created, so no remote cleanup needed or attempted. **No Cloudinary access, including production, occurred**.

Add the independent repository variable using the steps above, then continue hosted execution/evidence review and infrastructure repair. Effective test-account role/retention/strict-transform/Console settings remain explicit attestation limitations. [Sanitized blocked-execution metadata](security-evidence/cloudinary-blocked-2026-10-05/execution.json). Upstream and unrelated Flutter/Android changes were untouched.

The integration PNG is newly authored with correct CRCs; the earlier offline-only PNG's invalid IDAT CRC and historical results are preserved. No offline fixture was upgraded or re-credited as decoder-valid provider evidence.

Files: dedicated workflow; modular `scripts/security-cloudinary/{guard,broker,fixtures,cases,check,self-test,transport-test,run}.js` and frozen `manifest.json`; this report and continuity pointers. Backend application source and unrelated Flutter/Android changes remain untouched. Historical Stage1/2/general evidence is authoritative for its own scope.
