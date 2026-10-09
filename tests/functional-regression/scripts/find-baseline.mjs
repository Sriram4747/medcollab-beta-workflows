import { execFileSync } from 'node:child_process';
import { mkdtemp, rm, writeFile, appendFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { catalogCases, environmentContractVersion, forkRepository, selectBackend, upstreamRef, upstreamRepository } from './ci-contracts.mjs';

export function validSuccessEvidence(evidence, { targetSha, fingerprint, expectedIds, reportArtifact }) {
  return evidence?.schemaVersion === 1 && evidence?.environmentContractVersion === environmentContractVersion &&
    evidence?.targetRepository === upstreamRepository && evidence?.targetRef === upstreamRef &&
    evidence?.sourceKind === 'upstream-read-only' && evidence?.scope === 'backend-all' &&
    evidence?.targetSha === targetSha && evidence?.fingerprint === fingerprint &&
    /^[a-f0-9]{40}$/.test(evidence?.harnessSha || '') &&
    evidence?.result === 'PASS' && evidence?.verifiedBackendAll === true &&
    evidence?.provenance?.status === 'PASS' && evidence?.provenance?.targetSha === targetSha &&
    evidence?.cleanup?.status === 'PASS' && evidence?.reportArtifactDigest === reportArtifact?.digest &&
    !reportArtifact?.expired && JSON.stringify(evidence?.selectedIds) === JSON.stringify(expectedIds) &&
    evidence?.tally?.PASS === 147 && ['FAIL', 'ERROR', 'BLOCKED', 'NEEDS_DECISION', 'SKIP'].every((status) => evidence.tally?.[status] === 0) &&
    /^[a-f0-9]{64}$/.test(evidence?.resultsSha256 || '');
}

const apiBase = `https://api.github.com/repos/${forkRepository}`;
export function trustedSuccessfulRun(run) {
  return ['schedule', 'workflow_dispatch'].includes(run?.event) && run?.status === 'completed' && run?.conclusion === 'success' && run?.head_repository?.full_name === forkRepository && Number.isInteger(run?.run_attempt);
}
export function successfulAttemptJobs(jobs) {
  return ['Detect', 'Execute', 'Summary'].every((name) => jobs?.some((job) => job.name === name && job.status === 'completed' && job.conclusion === 'success'));
}
export function matchingArtifacts(artifacts, runId, attempt) {
  const report = artifacts?.find((item) => item.name === `vocle-functional-report-${runId}-${attempt}`);
  const success = artifacts?.find((item) => item.name === `vocle-functional-success-${runId}-${attempt}`);
  return report && success && !report.expired && !success.expired && /^sha256:[a-f0-9]{64}$/.test(report.digest || '') ? { report, success } : null;
}
async function api(path) {
  const response = await fetch(`${apiBase}${path}`, { headers: { Authorization: `Bearer ${process.env.GITHUB_TOKEN}`, Accept: 'application/vnd.github+json', 'X-GitHub-Api-Version': '2022-11-28' }, signal: AbortSignal.timeout(30000) });
  if (!response.ok) throw new Error(`GitHub API ${path}: HTTP ${response.status}`);
  return response.json();
}
async function artifactJson(artifact) {
  const response = await fetch(artifact.archive_download_url, { headers: { Authorization: `Bearer ${process.env.GITHUB_TOKEN}`, Accept: 'application/vnd.github+json', 'X-GitHub-Api-Version': '2022-11-28' }, signal: AbortSignal.timeout(30000) });
  if ([404, 410].includes(response.status)) return null;
  if (!response.ok) throw new Error(`Success artifact download: HTTP ${response.status}`);
  const temporary = await mkdtemp(join(tmpdir(), 'vocle-evidence-'));
  try {
    const zip = join(temporary, 'artifact.zip');
    await writeFile(zip, Buffer.from(await response.arrayBuffer()));
    let contents;
    try { contents = execFileSync('unzip', ['-p', zip, 'success-manifest.json'], { encoding: 'utf8', maxBuffer: 1024 * 1024, stdio: ['ignore', 'pipe', 'ignore'] }); }
    catch (error) { if (error.code === 'ENOENT') throw error; return null; }
    try { return JSON.parse(contents); } catch { return null; }
  } finally { await rm(temporary, { recursive: true, force: true }); }
}

export async function findBaseline({ targetSha, fingerprint, expectedIds }) {
  if (!process.env.GITHUB_TOKEN) throw new Error('GITHUB_TOKEN missing for baseline lookup');
  for (let page = 1; page <= 10; page++) {
    const listing = await api(`/actions/workflows/vocle-functional-regression.yml/runs?branch=master&status=success&per_page=100&page=${page}`);
    for (const run of listing.workflow_runs || []) {
      if (!trustedSuccessfulRun(run)) continue;
      const attempt = run.run_attempt;
      const jobs = await api(`/actions/runs/${run.id}/attempts/${attempt}/jobs?per_page=100`);
      if (!successfulAttemptJobs(jobs.jobs)) continue;
      const artifacts = await api(`/actions/runs/${run.id}/artifacts?per_page=100`);
      const matching = matchingArtifacts(artifacts.artifacts, run.id, attempt);
      if (!matching) continue;
      const evidence = await artifactJson(matching.success);
      if (!evidence || evidence.harnessSha !== run.head_sha) continue;
      if (evidence.runId !== String(run.id) || evidence.attempt !== String(attempt)) continue;
      if (validSuccessEvidence(evidence, { targetSha, fingerprint, expectedIds, reportArtifact: matching.report })) return { needsRun: false, reason: 'validated matching full-backend success', baselineUrl: run.html_url };
    }
    if ((listing.workflow_runs || []).length < 100) break;
  }
  return { needsRun: true, reason: 'no validated matching full-backend success', baselineUrl: '' };
}

if (process.argv[1] && fileURLToPath(import.meta.url) === resolve(process.argv[1])) {
  const targetSha = process.env.VOCLE_TARGET_SHA;
  const fingerprint = process.env.VOCLE_FINGERPRINT;
  if (!/^[a-f0-9]{40}$/.test(targetSha || '') || !/^[a-f0-9]{64}$/.test(fingerprint || '')) throw new Error('Invalid baseline key');
  const expectedIds = selectBackend(await catalogCases(), 'backend-all').map((item) => item.id);
  const result = process.env.VOCLE_FORCE === 'true' || process.env.VOCLE_SCOPE !== 'backend-all' || process.env.VOCLE_TARGET_KIND !== 'upstream-read-only'
    ? { needsRun: true, reason: 'forced, subset or fork-change run', baselineUrl: '' }
    : await findBaseline({ targetSha, fingerprint, expectedIds });
  if (process.env.GITHUB_OUTPUT) await appendFile(process.env.GITHUB_OUTPUT, `needs_run=${result.needsRun}\nreason=${result.reason}\nbaseline_url=${result.baselineUrl}\n`);
  console.log(JSON.stringify(result));
}
