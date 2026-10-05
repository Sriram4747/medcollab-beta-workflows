# Vocle release security and functional checklist

Release owner/date: ______  Application commit/build: ______  Evidence links: ______

Track unresolved findings and explicit release decisions in the [regression registry](SECURITY_REGRESSION_GATES.md); green discovery means healthy execution, not absence of vulnerabilities. No current application finding was fixed or automatically made blocking by this project.

## AUTOMATED ON EVERY RELEVANT CHANGE

- [ ] Secret Scan succeeds for the candidate commit/history. Existing `secrets-scan.yml` runs on master push/PR; investigate alerts and rotate exposed secrets before release.
- [ ] Run functional sanity/regression for changed flows: authentication/onboarding, groups/DM consent, message read/send/edit/delete, handoff lifecycle, upload/display/download and notification preferences. Existing Vocle Functional Sanity is **manual** and targets an exact read-only upstream SHA: use its provenance manifest and ensure it matches the intended application commit. It is not automatically a fork-commit gate.
- [ ] Run affected security modules with positive controls and denial/state checks. For model/controller/index changes, dispatch [MongoDB Data Security](https://github.com/Sriram4747/medcollab-beta-workflows/actions/workflows/vocle-data-security.yml); for media changes, dispatch Offline Media Security. Both are currently manual discovery workflows; make their execution part of change review until a separate CI trigger/gate change is approved.
- [ ] Require all **activated** regression gates to pass against the release commit. Current count is **zero active application gates**. Infrastructure/safety/cleanup failures already block their workflows; unresolved observations remain visible. Do not advertise them as strict protection before activation.
- [ ] Preserve testcase IDs/manifests, sanitized reports and source provenance. A skipped or partial run must not replace passing evidence.

## PERIODIC / PRE-RELEASE

- [ ] Run the broader discovery suite after material auth/access/realtime changes and before release when prior evidence no longer represents the candidate. Review every new/changed observation, execution completeness and cleanup. Historical77/77 route hits are bounded coverage, not complete assurance.
- [ ] Run isolated Cloudinary integration after provider/SDK/media changes or account changes. Use only approved TEST cloud, independent positive allowlist, synthetic exact journal and finally/post-job cleanup. Review image/video/PDF delivery, typed deletion and functional observations; do not use production credentials or broad deletion.
- [ ] Review lockfile/dependency changes and security advisories; run the package manager's audit/dependency tooling during preparation as appropriate. No dependency-security gating workflow is established here, and `npm test` in backend is a placeholder: neither is evidence of a maintained unit suite or clean dependency audit.
- [ ] Verify configuration/startup safeguards from the release source (NODE_ENV, OTP bypass disabled, developer tools disabled, JWT keys/expiry, provider separation, origins, DB target). Exercise production-like guards only in isolated synthetic infrastructure; deploy smoke checks require a separately approved deployment.
- [ ] Complete device/build sanity on the candidate: login/logout/reconnect, background notifications, private-resource revocation, media playback/download, handoff reassignment and deep links. Existing server suites do not validate actual mobile secure storage, OS notifications or released APK behavior.
- [ ] Triage confirmed findings by severity and record remediation or an accountable release decision. Prioritize fabricated widget authentication, OTP concurrency, private/Needl/mention disclosure, revoked/recovered socket access and local-media ownership; include new deleted-message integrity and provider compatibility defects.

## MANUAL / ACCOUNT-LEVEL

- [ ] Account owner completes the [Cloudinary checklist](SECURITY_CLOUDINARY_HARDENING_2026-10-06.md): roles/keys/presets, delivery privacy, transformation/PDF controls, invalidation, retained versions/backups and failed-cleanup ownership.
- [ ] Account owner completes the [Atlas checklist](SECURITY_MONGODB_HARDENING_2026-10-06.md#manual-mongodb-atlas-owner-verification): network, least privilege/rotation, TLS/encryption, actual indexes, backups/restore/retention, tier-appropriate auditing and environment separation.
- [ ] Verify production secret/configuration values in their approved consoles without copying them into source, artifacts, chats or test lanes. Review JWT/MSG91/Firebase/provider identities, rotation and allowed egress. This project has not accessed production services.
- [ ] Decide clinical/media confidentiality, consent, audit retention, deletion/cascade/backup erasure, stale membership, device-account transfer and session/revocation policies. Document controls CI cannot safely inspect and owners for the remaining gaps.

## Developer fix → regression protection

1. Link the finding/testcase(s), security requirement and an application fix commit.
2. Rerun the existing focused testcase(s) against that fixed source, preserving historical IDs/evidence and successful controls. Check expected secure response **and** database/resource state, payload/audience and lifecycle effects.
3. Review that the test can pass on secure behavior. Legacy disclosure/crash callbacks may need a separately versioned assertion; do not weaken or silently rewrite frozen discovery expectations.
4. Confirm healthy isolated hosted execution, no policy ambiguity and safe cleanup. Record the secure outcome and remediation status in the registry.
5. Explicitly promote that reviewed requirement to a blocking regression gate and wire the appropriate relevant-change CI trigger. A future regression must fail CI. Do not activate unresolved policy/provider-timing observations or all current observations at once.

The flow is **finding → application fix → existing testcase rerun → secure behavior confirmed → testcase promoted → future regression fails CI**. Source fixes and gate activation are separate developer work; this task completed defensive review/tests/evidence, not remediation or release authorization.
