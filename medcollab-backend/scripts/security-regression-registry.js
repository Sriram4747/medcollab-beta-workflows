'use strict';
// Read reviewed evidence only. This registry never enables blocking tests.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '../..');
const reviewPaths = process.argv.slice(2).length ? process.argv.slice(2) : [
  'docs/security-evidence/37175207493/reviewed-observations.json',
  'docs/security-evidence/37181051425/reviewed-observations.json',
  'docs/security-evidence/37355451614/reviewed-observations.json',
  'docs/security-evidence/37358018047/reviewed-observations.json',
  'docs/security-evidence/37359326520/reviewed-observations.json',
];
const requirements = {
  S1: 'A reply parent must belong to the authorized destination channel; foreign parents and their reply counts must remain unchanged.',
  S2: 'A handoff channel must belong to the authorized handoff space.',
  S3: 'Channel member metadata may be read only by an authorized participant or private-channel administrator.',
  S4: 'Draft handoffs must remain sender-only until submission, including list/search/detail paths.',
  S5: 'Private channel details require private membership or authorized space administration.',
  S6: 'Only the canonical local-media owner may delete the file; normalization cannot bypass ownership.',
  S7: 'Typing emission requires live authorization to the referenced channel or DM.',
  S8: 'Private message body fanout may target only the authorized private-channel audience.',
  S9: 'Membership revocation must remove future protected channel delivery from existing sockets.',
  AUTH_WIDGET: 'Widget identity must be authenticated by a trusted verifier and obey token validity/expiry; decoding an unsigned fabricated token cannot establish identity.',
  N1_NEEDL_ACCESS: 'Needl previews must apply live space and private-channel access, including membership revocation.',
  N2_PRIVATE_PIN: 'Private-channel pin/unpin requires private-channel access in addition to any post-role rule.',
  N3_MENTION_AUDIENCE: 'Mentions cannot disclose message previews to unauthorized recipients via inbox or socket notifications.',
  R1_ACTIVE_SOCKET: 'Deactivated users must lose protected socket joins and database writes on existing sessions.',
  R2_SPACE_PRESENCE: 'Live presence delivery must exclude revoked space members, including after room synchronization.',
  R3_TYPING_CACHE: 'Cached DM typing recipients must exclude removed participants even after they leave the channel room.',
  R4_SOCKET_CRASH: 'Malformed authenticated socket payloads cannot terminate the backend process.',
  R5_RECOVERY_AUTH: 'Transport recovery must revalidate authorization before restoring protected rooms or replaying packets.',
  A1_OTP_CONSUMPTION: 'One stored OTP must authorize at most one successful verification request; concurrent additional requests cannot return usable application credentials.',
  DATA_DELETED_EDIT: 'Editing a deleted message must be denied and cannot repopulate blanked persisted content or emit a restored-content update.',
  'media-octet-resource-type': 'Supported synthetic PDF/video bytes delivered as application/octet-stream must select the correct provider resource type, preserve bytes and produce usable application output.',
  'media-video-delete': 'The canonical owner can delete a video using its actual provider resource type; exact authenticated origin lookup confirms absence.',
  'media-video-message': 'A supported uploaded video can be attached to an authorized message, with valid metadata and no orphan from validation mismatch.',
  CLOUDINARY_PDF_ATTACHMENT: 'The application-generated PDF attachment URL must deliver the exact uploaded synthetic PDF when a successful typed provider control establishes support.',
  CLOUDINARY_PDF_PREVIEW: 'The PDF preview must address a valid, correctly typed image-derived resource and return a decodable image where a provider control establishes support.',
};
const confirmed = 'confirmed security defect';
const functionalCases = new Set(['VOCLE-724', 'VOCLE-725', 'VOCLE-736', 'VOCLE-746', 'VOCLE-762', 'VOCLE-770', 'VOCLE-771', 'VOCLE-782', 'VOCLE-783']);
const cloudRoots = { 'VOCLE-762': 'media-video-delete', 'VOCLE-765': 'media-invalidation-intent', 'VOCLE-770': 'CLOUDINARY_PDF_ATTACHMENT', 'VOCLE-771': 'CLOUDINARY_PDF_PREVIEW', 'VOCLE-773': 'media-invalidation-intent', 'VOCLE-776': 'media-invalidation-intent', 'VOCLE-782': 'media-octet-resource-type', 'VOCLE-783': 'media-octet-resource-type', 'VOCLE-784': 'media-shared-handoff' };
const cloudNames = new Map(JSON.parse(fs.readFileSync(path.join(__dirname, 'security-cloudinary/manifest.json'))).cases.map(c => [c.caseId, c.name]));
const collected = new Map(), provenance = [];
for (const relative of reviewPaths) {
  const reviewPath = path.resolve(root, relative);
  assert.ok(reviewPath.startsWith(root + path.sep), 'Review must be in this repository');
  const review = JSON.parse(fs.readFileSync(reviewPath));
  provenance.push({ reviewSource: path.relative(root, reviewPath).replace(/\\/g, '/'), runId: review.runId, executedSource: review.executedSource || null });
  for (const item of review.observations) {
    const previous = collected.get(item.caseId);
    collected.set(item.caseId, { ...item, classification: item.classification || item.reviewedDisposition,
      rootCause: item.rootCause || cloudRoots[item.caseId] || 'CLOUDINARY_POLICY', evidenceRunId: review.runId,
      evidenceSources: [...(previous?.evidenceSources || []), provenance.at(-1)] });
  }
}
const entries = [...collected.values()].sort((a, b) => a.caseId.localeCompare(b.caseId)).map(item => {
  const candidate = item.classification === confirmed || functionalCases.has(item.caseId);
  if (candidate) assert.ok(requirements[item.rootCause], `Missing secure requirement: ${item.rootCause}`);
  const requirement = requirements[item.rootCause] || (typeof item.expected === 'string' ? item.expected : item.review);
  return { testcaseId: item.caseId, relatedTestcaseIds: item.relatedCases || [], name: item.name || cloudNames.get(item.caseId) || item.caseId, rootCause: item.rootCause,
    securityRequirement: requirement, expectedSecureBehavior: requirement,
    requirementStatus: candidate ? 'confirmed requirement; remediation required' : 'proposed hardening/policy expectation; developer decision required',
    currentBehavior: item.review, classification: item.classification, currentStatus: 'observed', evidenceRunId: item.evidenceRunId, evidenceSources: item.evidenceSources,
    applicationFixStatus: candidate ? 'unfixed in executed source; no application fix made by this project' : 'not established; separate developer or policy review required',
    regressionCandidate: candidate, candidateKind: candidate ? (item.classification === confirmed ? 'security' : 'functional/provider contract') : null,
    blocking: false, blockingEligibility: candidate ? 'only after developer remediation and secure assertion audit' : 'excluded pending explicit policy/hardening resolution',
    activation: candidate ? 'After an identified application fix lands, audit status/state/semantic assertions against this requirement, verify a healthy isolated run with positive and denial controls, then explicitly enable a versioned strict gate for this requirement.' : 'Excluded from strict gates pending resolution; no automatic activation from classification or a passing run.',
    assertionMigration: candidate ? 'Preserve historical evidence and frozen manifests. Some legacy callbacks capture disclosure on unexpected success and need a separately versioned secure assertion after the fix; do not gate them unchanged without review.' : null,
  };
});
const registry = { schemaVersion: 2, reviewSources: provenance,
  mode: 'candidate-registry-only', blockingEnabled: false, applicationFixesPerformed: false,
  activationRequires: ['identified fix commit and linked requirement', 'reviewed versioned secure assertions, including denial payload/state checks', 'healthy isolated execution with deterministic successful controls', 'explicit developer activation; policy/hardening remain excluded'],
  candidates: entries.filter(x => x.regressionCandidate).length, excluded: entries.filter(x => !x.regressionCandidate).length, entries };
fs.writeFileSync(path.join(root, 'docs/SECURITY_REGRESSION_GATES.json'), JSON.stringify(registry, null, 2) + '\n');
const lines = ['# Security regression gate registry', '', `Evidence runs: ${provenance.map(x => x.runId).join(', ')}. **${registry.candidates} after-remediation candidates; ${registry.excluded} observations excluded; zero active application gates.**`, '',
  'This is a requirement registry, not an active gating configuration. The discovery runner still records application differences as observations. No application fix is known in the executed source. Existing policy, hardening and ambiguous cases cannot become blocking automatically.', '',
  'After a fix: identify its commit; review the status, denial payload, state and semantic assertion; run the real isolated workflow with successful controls; then explicitly activate a versioned strict requirement gate. A passing run alone never activates a gate. Preserve old evidence and frozen IDs; append or deliberately version corrected secure assertions where a legacy disclosure callback cannot pass a denial response.', '',
  'The JSON registry maps every observed testcase to requirement, current status, fix status and activation rule. Realtime gates also need positive producer/delivery controls; malformed-payload gates must allow the fixed handler to return safely rather than waiting for a failure diagnostic.', '',
  'The latest reviewed evidence for a reused testcase supersedes its old observation details, while all source references/history remain preserved. Related IDs share a root rather than representing new vulnerabilities. Functional provider contracts are explicitly labeled separately from confirmed security defects. Cache/retention/account and data-layer hardening questions remain excluded. No current application finding is eligible to block immediately; no remediation commit is established.', '',
  'Infrastructure, positive-cloud allowlisting, credential exclusion, transport isolation, artifact hygiene, execution prerequisites and exact cleanup already fail their respective workflows independently of application observation status. The registry itself does not implement a strict runner or change any CI trigger.', '',
  '| Testcase | Root | Candidate | Current status / fix |', '| --- | --- | --- | --- |',
  ...entries.map(x => `| ${x.testcaseId} | ${x.rootCause} | ${x.regressionCandidate ? 'yes, after fix/assertion audit' : 'excluded'} | observed / ${x.regressionCandidate ? 'unfixed' : 'unresolved review'} |`), '',
  'Machine-readable details: [SECURITY_REGRESSION_GATES.json](SECURITY_REGRESSION_GATES.json).', ''];
fs.writeFileSync(path.join(root, 'docs/SECURITY_REGRESSION_GATES.md'), lines.join('\n'));
console.log(`Regression registry: ${registry.candidates} candidates, ${registry.excluded} excluded, zero active gates.`);
