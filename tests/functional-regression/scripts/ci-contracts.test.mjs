import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { test } from 'node:test';
import { catalogCases, completeBackendSuccess, environmentContractVersion, selectBackend, statuses, upstreamRef, upstreamRepository, validateResultSet } from './ci-contracts.mjs';
import { findBaseline, matchingArtifacts, successfulAttemptJobs, trustedSuccessfulRun, validSuccessEvidence } from './find-baseline.mjs';
import { affectedModules } from './affected-modules.mjs';

const targetSha = 'a'.repeat(40), harnessSha = 'b'.repeat(40), fingerprint = 'c'.repeat(64);
const cases = await catalogCases();
const selected = selectBackend(cases, 'backend-all');
const expectedIds = selected.map((item) => item.id);
const tally = Object.fromEntries(statuses.map((status) => [status, status === 'PASS' ? 147 : 0]));
const cleanup = { status: 'PASS' };
const provenance = { status: 'PASS', targetSha, harnessSha };
const reportArtifact = { digest: `sha256:${'d'.repeat(64)}`, expired: false };
const evidence = { schemaVersion: 1, environmentContractVersion, targetRepository: upstreamRepository, targetRef: upstreamRef,
  sourceKind: 'upstream-read-only', scope: 'backend-all', targetSha, harnessSha, fingerprint, result: 'PASS', verifiedBackendAll: true,
  provenance, cleanup, reportArtifactDigest: reportArtifact.digest, selectedIds: expectedIds, tally, resultsSha256: 'e'.repeat(64) };

test('catalog selection keeps all 147 backend IDs and retained 48', () => {
  assert.equal(selected.length, 147);
  const subset = selectBackend(cases, 'backend-p0');
  assert(subset.length >= 48 && subset.length < 147);
  assert.equal(subset.filter((item) => item.coverage === 'EXISTING').length, 48);
});

test('fork changes select mapped modules; unknown shared changes select all', () => {
  assert.deepEqual(affectedModules(['medcollab-backend/src/features/handoffs/handoff.controller.js']), ['NOT', 'SRCH', 'HOF', 'JRN']);
  assert.equal(affectedModules(['medcollab-backend/src/middleware/auth.js']).length, 19);
  assert.equal(affectedModules(['tests/functional-regression/suites/handoffs.mjs']).length, 19);
});

test('full success requires exact IDs, status, source and cleanup', () => {
  const results = selected.map((item) => ({ id: item.id, status: 'PASS' }));
  assert.equal(validateResultSet({ selected, results, targetSha, harnessSha, sourceKind: 'upstream-read-only', cleanup, provenance }).PASS, 147);
  assert(completeBackendSuccess({ scope: 'backend-all', selected, tally, cleanup, provenance }));
  assert(!completeBackendSuccess({ scope: 'backend-p0', selected, tally, cleanup, provenance }));
  assert.throws(() => validateResultSet({ selected, results: results.slice(1), targetSha, harnessSha, sourceKind: 'upstream-read-only', cleanup, provenance }), /Missing/);
  assert.throws(() => validateResultSet({ selected, results: [...results.slice(0, -1), results[0]], targetSha, harnessSha, sourceKind: 'upstream-read-only', cleanup, provenance }), /duplicate/);
  assert.throws(() => validateResultSet({ selected, results, targetSha, harnessSha, sourceKind: 'upstream-read-only', cleanup: { status: 'ERROR' }, provenance }), /Cleanup/);
});

test('skip history rejects partial, changed SHA, changed harness, expired and failed evidence', () => {
  const key = { targetSha, fingerprint, expectedIds, reportArtifact };
  assert(validSuccessEvidence(evidence, key));
  for (const altered of [
    [{ ...evidence, selectedIds: expectedIds.slice(1) }, key],
    [evidence, { ...key, targetSha: 'f'.repeat(40) }],
    [evidence, { ...key, fingerprint: 'f'.repeat(64) }],
    [evidence, { ...key, reportArtifact: { ...reportArtifact, expired: true } }],
    [{ ...evidence, tally: { ...tally, FAIL: 1, PASS: 146 } }, key],
    [{ ...evidence, scope: 'backend-p0' }, key],
    [{ ...evidence, selectedIds: [expectedIds[0], ...expectedIds.slice(0, -1)] }, key],
  ]) assert(!validSuccessEvidence(altered[0], altered[1]));
});

test('failed reruns, missing artifacts and incomplete jobs cannot satisfy skip history', () => {
  const run = { event: 'schedule', status: 'completed', conclusion: 'success', head_repository: { full_name: 'Sriram4747/medcollab-beta-workflows' }, run_attempt: 2 };
  assert(trustedSuccessfulRun(run));
  assert(!trustedSuccessfulRun({ ...run, conclusion: 'failure' }));
  assert(!trustedSuccessfulRun({ ...run, event: 'pull_request' }));
  const jobs = ['Detect', 'Execute', 'Summary'].map((name) => ({ name, status: 'completed', conclusion: 'success' }));
  assert(successfulAttemptJobs(jobs));
  assert(!successfulAttemptJobs(jobs.map((job) => job.name === 'Execute' ? { ...job, conclusion: 'failure' } : job)));
  const artifacts = [
    { name: 'vocle-functional-report-42-2', digest: reportArtifact.digest, expired: false },
    { name: 'vocle-functional-success-42-2', expired: false },
  ];
  assert(matchingArtifacts(artifacts, 42, 2));
  assert(!matchingArtifacts(artifacts, 42, 1));
  assert(!matchingArtifacts(artifacts.slice(0, 1), 42, 2));
  assert(!matchingArtifacts(artifacts.map((item) => ({ ...item, expired: true })), 42, 2));
});

test('GitHub API outage is an error, never a skip', async () => {
  const previousFetch = globalThis.fetch, previousToken = process.env.GITHUB_TOKEN;
  globalThis.fetch = async () => ({ ok: false, status: 503 });
  process.env.GITHUB_TOKEN = 'synthetic-contract-token';
  try { await assert.rejects(findBaseline({ targetSha, fingerprint, expectedIds }), /HTTP 503/); }
  finally { globalThis.fetch = previousFetch; if (previousToken === undefined) delete process.env.GITHUB_TOKEN; else process.env.GITHUB_TOKEN = previousToken; }
});

test('manual target pins exact upstream SHA and rejects malformed or untrusted input', () => {
  const script = fileURLToPath(new URL('./resolve-target.mjs', import.meta.url));
  const env = { ...process.env, GITHUB_EVENT_NAME: 'workflow_dispatch', GITHUB_REPOSITORY: 'Sriram4747/medcollab-beta-workflows', GITHUB_REF: 'refs/heads/master', VOCLE_INPUT_UPSTREAM_SHA: targetSha, VOCLE_INPUT_SCOPE: 'backend-all', VOCLE_INPUT_FORCE: 'true' };
  delete env.GITHUB_OUTPUT;
  const good = spawnSync(process.execPath, [script], { env, encoding: 'utf8' });
  assert.equal(good.status, 0, good.stderr);
  assert.deepEqual(JSON.parse(good.stdout), { targetKind: 'upstream-read-only', targetSha, scope: 'backend-all', force: true, targetRepository: 'mathiharan29/medcollab-beta' });
  const invalid = spawnSync(process.execPath, [script], { env: { ...env, VOCLE_INPUT_UPSTREAM_SHA: 'main;echo unsafe' }, encoding: 'utf8' });
  assert.notEqual(invalid.status, 0);
  const wrongRepo = spawnSync(process.execPath, [script], { env: { ...env, GITHUB_REPOSITORY: 'mathiharan29/medcollab-beta' }, encoding: 'utf8' });
  assert.notEqual(wrongRepo.status, 0);
});
