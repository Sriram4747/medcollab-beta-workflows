import { execFileSync } from 'node:child_process';
import { appendFile } from 'node:fs/promises';
import { forkRepository, upstreamRef, upstreamRepository } from './ci-contracts.mjs';

const event = process.env.GITHUB_EVENT_NAME || 'workflow_dispatch';
const repository = process.env.GITHUB_REPOSITORY || forkRepository;
const ref = process.env.GITHUB_REF || 'refs/heads/master';
const manualSha = process.env.VOCLE_INPUT_UPSTREAM_SHA || '';
const scope = process.env.VOCLE_INPUT_SCOPE || 'backend-all';
const force = process.env.VOCLE_INPUT_FORCE === 'true';
if (repository !== forkRepository) throw new Error('Workflow must run in the authorized fork');
if (!['backend-all', 'backend-p0'].includes(scope)) throw new Error('Invalid manual scope');
if (manualSha && !/^[a-f0-9]{40}$/.test(manualSha)) throw new Error('Manual upstream SHA must be 40 lowercase hex characters');
if (event !== 'workflow_dispatch' && manualSha) throw new Error('SHA override is manual only');
let targetKind, targetSha, effectiveScope;
if (event === 'workflow_dispatch' || event === 'schedule') {
  if (ref !== 'refs/heads/master') throw new Error('Trusted upstream validation requires fork master');
  targetKind = 'upstream-read-only';
  effectiveScope = event === 'schedule' ? 'backend-all' : scope;
  if (manualSha) targetSha = manualSha;
  else {
    const output = execFileSync('git', ['ls-remote', '--exit-code', `https://github.com/${upstreamRepository}.git`, upstreamRef], { encoding: 'utf8', timeout: 30000 }).trim();
    const lines = output.split(/\r?\n/);
    const match = /^([a-f0-9]{40})\trefs\/heads\/master$/.exec(lines[0]);
    if (lines.length !== 1 || !match) throw new Error('Unexpected upstream ref response');
    targetSha = match[1];
  }
} else if (event === 'push' || event === 'pull_request') {
  targetKind = 'fork-change';
  effectiveScope = 'backend-p0';
  if (event === 'pull_request' && process.env.VOCLE_PR_HEAD_REPOSITORY !== forkRepository) throw new Error('Only same-fork PR heads are accepted');
  targetSha = event === 'pull_request' ? process.env.VOCLE_PR_HEAD_SHA : process.env.GITHUB_SHA;
} else throw new Error(`Unsupported event ${event}`);
if (!/^[a-f0-9]{40}$/.test(targetSha || '')) throw new Error('Target SHA is missing or invalid');
const result = { targetKind, targetSha, scope: effectiveScope, force, targetRepository: targetKind === 'upstream-read-only' ? upstreamRepository : forkRepository };
if (process.env.GITHUB_OUTPUT) await appendFile(process.env.GITHUB_OUTPUT, Object.entries(result).map(([key, value]) => `${key}=${value}\n`).join(''));
console.log(JSON.stringify(result));
