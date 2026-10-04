'use strict';
// Read reviewed evidence only. This registry never enables blocking tests.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '../..');
const reviewPath = path.resolve(root, process.argv[2] || 'docs/security-evidence/37144805902/reviewed-observations.json');
const review = JSON.parse(fs.readFileSync(reviewPath));
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
};
const confirmed = 'confirmed security defect';
const entries = review.observations.map(item => {
  const candidate = item.classification === confirmed;
  if (candidate) assert.ok(requirements[item.rootCause], `Missing secure requirement: ${item.rootCause}`);
  return { testcaseId: item.caseId, name: item.name, rootCause: item.rootCause,
    securityRequirement: requirements[item.rootCause] || item.review,
    classification: item.classification, currentStatus: 'observed', evidenceRunId: review.runId,
    applicationFixStatus: candidate ? 'unfixed in executed source; no application fix made by this project' : 'not established; separate developer or policy review required',
    regressionCandidate: candidate, blocking: false,
    activation: candidate ? 'After an identified application fix lands, audit status/state/semantic assertions against this requirement, verify a healthy isolated run with positive and denial controls, then explicitly enable a versioned strict gate for this requirement.' : 'Excluded from strict gates pending resolution; no automatic activation from classification or a passing run.',
    assertionMigration: candidate ? 'Preserve historical evidence and frozen manifests. Some legacy callbacks capture disclosure on unexpected success and need a separately versioned secure assertion after the fix; do not gate them unchanged without review.' : null,
  };
});
const registry = { schemaVersion: 1, reviewSource: path.relative(root, reviewPath).replace(/\\/g, '/'), evidenceRunId: review.runId,
  mode: 'candidate-registry-only', blockingEnabled: false, applicationFixesPerformed: false,
  activationRequires: ['identified fix commit and linked requirement', 'reviewed versioned secure assertions, including denial payload/state checks', 'healthy isolated execution with deterministic successful controls', 'explicit developer activation; policy/hardening remain excluded'],
  candidates: entries.filter(x => x.regressionCandidate).length, excluded: entries.filter(x => !x.regressionCandidate).length, entries };
fs.writeFileSync(path.join(root, 'docs/SECURITY_REGRESSION_GATES.json'), JSON.stringify(registry, null, 2) + '\n');
const lines = ['# Security regression gate registry', '', `Evidence run: ${review.runId}. **${registry.candidates} confirmed-case candidates; ${registry.excluded} observations excluded; zero active gates.**`, '',
  'This is a requirement registry, not an active gating configuration. The discovery runner still records application differences as observations. No application fix is known in the executed source. Existing policy, hardening and ambiguous cases cannot become blocking automatically.', '',
  'After a fix: identify its commit; review the status, denial payload, state and semantic assertion; run the real isolated workflow with successful controls; then explicitly activate a versioned strict requirement gate. A passing run alone never activates a gate. Preserve old evidence and frozen IDs; append or deliberately version corrected secure assertions where a legacy disclosure callback cannot pass a denial response.', '',
  'The JSON registry maps every observed testcase to requirement, current status, fix status and activation rule. Realtime gates also need positive producer/delivery controls; malformed-payload gates must allow the fixed handler to return safely rather than waiting for a failure diagnostic.', '',
  '| Testcase | Root | Candidate | Current status / fix |', '| --- | --- | --- | --- |',
  ...entries.map(x => `| ${x.testcaseId} | ${x.rootCause} | ${x.regressionCandidate ? 'yes, after fix/assertion audit' : 'excluded'} | observed / ${x.regressionCandidate ? 'unfixed' : 'unresolved review'} |`), '',
  'Machine-readable details: [SECURITY_REGRESSION_GATES.json](SECURITY_REGRESSION_GATES.json).', ''];
fs.writeFileSync(path.join(root, 'docs/SECURITY_REGRESSION_GATES.md'), lines.join('\n'));
console.log(`Regression registry: ${registry.candidates} candidates, ${registry.excluded} excluded, zero active gates.`);
