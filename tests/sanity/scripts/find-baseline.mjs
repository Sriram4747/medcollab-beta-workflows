import { execFileSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const repository = process.env.GITHUB_REPOSITORY;
const fingerprint = process.env.SUITE_FINGERPRINT;
const expected = Number(process.env.EXPECTED_SCENARIOS || '48');
if (!repository || !fingerprint || !Number.isInteger(expected)) throw new Error('GITHUB_REPOSITORY, SUITE_FINGERPRINT, and EXPECTED_SCENARIOS are required.');

const api = async (path) => {
  const response = await fetch(`https://api.github.com${path}`, {
    headers: { Accept: 'application/vnd.github+json', Authorization: `Bearer ${process.env.GITHUB_TOKEN || ''}`, 'X-GitHub-Api-Version': '2022-11-28' },
  });
  if (!response.ok) throw new Error(`GitHub API ${path} returned ${response.status}.`);
  return response.json();
};

const output = (value) => process.stdout.write(`${JSON.stringify(value)}\n`);
let page = 1;
while (page <= 10) {
  const { workflow_runs: runs = [] } = await api(`/repos/${repository}/actions/workflows/vocle-sanity.yml/runs?status=completed&per_page=100&page=${page}`);
  if (runs.length === 0) break;
  for (const run of runs) {
    if (run.conclusion !== 'success' || run.head_branch !== 'master' || !['schedule', 'workflow_dispatch'].includes(run.event)) continue;
    const attempt = run.run_attempt;
    const jobs = await api(`/repos/${repository}/actions/runs/${run.id}/attempts/${attempt}/jobs?per_page=100`);
    if (!jobs.jobs?.some((job) => job.name === 'Sanity' && job.conclusion === 'success')) continue;
    const artifacts = await api(`/repos/${repository}/actions/runs/${run.id}/artifacts?per_page=100`);
    const artifact = artifacts.artifacts?.find((item) => item.name === `vocle-sanity-success-${run.id}-${attempt}` && !item.expired);
    if (!artifact) continue;
    const directory = mkdtempSync(join(tmpdir(), 'vocle-sanity-baseline-'));
    try {
      const archive = join(directory, 'artifact.zip');
      execFileSync('gh', ['api', `/repos/${repository}/actions/artifacts/${artifact.id}/zip`, '--output', archive], { stdio: 'ignore', env: { ...process.env, GH_TOKEN: process.env.GITHUB_TOKEN } });
      const manifestText = execFileSync('unzip', ['-p', archive, 'success-manifest.json'], { encoding: 'utf8' });
      const manifest = JSON.parse(manifestText);
      if (manifest.schemaVersion !== 1 || manifest.result !== 'PASS' || manifest.suiteFingerprint !== fingerprint || manifest.expectedScenarioCount !== expected || manifest.passedScenarioCount !== expected || !/^[a-f0-9]{40}$/.test(manifest.upstreamSha || '')) continue;
      output({ baseline: 'verified', upstreamSha: manifest.upstreamSha, runId: run.id, runUrl: run.html_url });
      process.exit(0);
    } finally {
      rmSync(directory, { recursive: true, force: true });
    }
  }
  page += 1;
}
output({ baseline: 'unavailable' });
