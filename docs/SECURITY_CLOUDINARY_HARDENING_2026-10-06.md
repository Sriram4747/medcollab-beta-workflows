# Final Cloudinary hardening review — 2026-10-06

Completed review of [real evidence](security-evidence/37355451614/execution.json), [offline contracts](SECURITY_MEDIA_OFFLINE_2026-10-04.md), unchanged media/config source and provider documentation. No new live requests were necessary: existing VOCLE-765/773/776 already measure the immediate post-delete condition with exact byte hashes and independent authenticated origin absence. Historical run 37355451614 remains **34/34, 25 passes/nine observations; 13/13 recorded assets cleaned in finally and post-job**, zero pending intents. Do not re-credit this as a new run or assume production behavior.

## Cache and invalidation conclusion

Original image/video/raw URLs returned 200 with the original bytes immediately after non-invalidating destruction. This is expected provider cache behavior, not failed origin deletion. Standard delivery can cache for up to 30 days; invalidation is asynchronous, typically seconds to minutes, and external browser/proxy caches may persist. Version changes help clients retrieve replacements; they do not revoke an old copied URL. Signed URL invalidation has additional account/legacy conditions. [Cloudinary cache documentation](https://cloudinary.com/documentation/invalidate_cached_media_assets_on_the_cdn).

`media.controller.js` calls image/raw destroy without `invalidate:true`; the independent integration janitor requests it for all recorded types. Existing evidence proves request intent and origin cleanup, **not worldwide eviction, an eviction deadline, derived-cache purge or client copy erasure**. A single runner/CDN location cannot deterministically prove global revocation. No arbitrary sleep followed by a strict “must be 404 now” gate was added.

For ordinary public assets this behavior is compatible with CDN delivery. If Vocle promises confidential clinical-media access or withdrawal on membership revocation/deletion, origin deletion and unguessable public IDs are insufficient. Decide the requirement, then separately remediate delivery authorization and deletion semantics. This is an application/policy concern, not a newly discovered provider vulnerability. Upload request signatures authenticate uploads; they do not make the returned `upload` delivery URL private. Review protection of originals **and derivatives**, token expiry and the application's user/resource check. [Cloudinary access controls](https://cloudinary.com/documentation/control_access_to_media).

Deletion is also distinct from backup/version erasure: backed-up assets may be restorable; the absence of a current origin is not proof of complete retention removal. No backup deletion, restoration, account enumeration or account-policy mutation was attempted. [Cloudinary backup lifecycle](https://cloudinary.com/documentation/backups_and_version_management).

## Developer/account-owner attestation

Record owner, date, approved policy and redacted evidence references; leave unknown items open. No elevated credentials should be supplied to CI/Codex just to automate these checks.

- [ ] Verify production and TEST product environments, keys, dashboard access and billing resources are separate. Independently attest the existing TEST allowlist variable matches only the approved synthetic cloud; preserve fail-closed equality and exact-resource cleanup.
- [ ] Review Console users/roles, MFA/SSO where available, service-key privilege/scope, owners of shared keys, rotation/revocation and key storage. CI must not receive account-administrator credentials for this exercise.
- [ ] Inventory enabled upload presets and unsigned upload entry points. Disable unused ones; restrict allowed formats, sizes, folders and transformations as appropriate. Confirm app signed uploads are governed by the intended policy; don't infer this from preset defaults alone.
- [ ] Decide confidentiality of message/handoff media and avatars. Verify effective delivery type/access controls, originals/derivatives, signed or expiring access, download sharing and membership revocation. Merely enabling strict transforms or signing a public URL does not establish per-user authorization.
- [ ] Verify strict-transform/eager-transform policy, permitted PDF/raw delivery/preview settings, remote fetch/upload restrictions and resource limits. The test-account typed PDF controls do not attest production settings.
- [ ] Record CDN hostname/configuration, legacy invalidation rules (versioned/unversioned and IDs containing slashes), signed-URL invalidation eligibility, original/derived URL variants and acceptable deletion propagation. Validate a small synthetic asset only if a specific configured contract needs verification; retain exact allowlist/journal cleanup.
- [ ] Verify automatic backups, retained versions, restore permissions, retention periods, deletion/export procedures and recovery/support policy. Include unattached uploads, shared handoff assets and URL-builder partial failures in the application's lifecycle decision.
- [ ] Define who monitors failed/cancelled integration cleanup. Inspect exact manifests if finally/post-job execution is interrupted; forced runner loss has no guaranteed remote janitor. No broad prefix/bulk deletion is authorized.
- [ ] Confirm relevant account activity/logging, alerting and contractual/data-location requirements with the account owner. Repository code does not prove those settings.

## Regression readiness

After fixes and assertion review, promote video deletion **736/762**, octet dispatch **724/725/782/783**, named PDF attachment **770**, typed PDF preview **771**, and video-message compatibility **746** to blocking functional/security-contract gates. Maintain successful upload/typed-delivery controls and exact cleanup. Real-provider gates stay manual/periodic because they consume a provider and require TEST credentials.

Keep **737/765/773/776** cache behavior nonblocking pending an explicit revocation contract; check request-level invalidation separately from eventual provider behavior. Shared handoff deletion **721/740/784**, namespace dispatch **739**, partial-failure compensation **743**, backup/retention and asset-reference lifecycle still need scoped remediation or policy decisions. Do not turn all observations into gates. [Consolidated registry](SECURITY_REGRESSION_GATES.md).

Production Cloudinary, MongoDB/Atlas, Railway, Firebase, MSG91, real users/media and upstream were untouched. The existing Cloudinary positive allowlist, broker and cleanup implementation remain unchanged.
