import { createHash } from 'node:crypto';
import { spawnSync } from 'node:child_process';
import { mkdir, readFile, readdir, writeFile } from 'node:fs/promises';
import { join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const harnessRoot = resolve(fileURLToPath(new URL('../', import.meta.url)));
const repoRoot = resolve(harnessRoot, '../..');
const [sanityRun, subsetRun] = process.argv.slice(2);
if (!/^[a-f0-9-]{36}$/.test(sanityRun || '') || !/^[a-f0-9-]{36}$/.test(subsetRun || '')) throw new Error('Pass exact sanity and subset run UUIDs');
const output = join(harnessRoot, 'output');
const modules = [
  ...Array.from({ length: 7 }, (_, index) => `auth-${String(index + 1).padStart(2, '0')}`),
  'profile', 'discovery',
  ...Array.from({ length: 6 }, (_, index) => `spaces-${String(index + 1).padStart(2, '0')}`),
  'channels',
  ...Array.from({ length: 5 }, (_, index) => `requests-${String(index + 1).padStart(2, '0')}`),
  ...Array.from({ length: 9 }, (_, index) => `conversations-${String(index + 1).padStart(2, '0')}`),
];
const newCaseCount = 40;
const readReport = async (path) => JSON.parse(await readFile(path, 'utf8'));
const sanity = await readReport(join(output, `sanity-adapted-${sanityRun}`, 'results.json'));
const subset = await Promise.all(modules.map((name) => readReport(join(output, `${name}-${subsetRun}`, 'results.json'))));
const reports = [sanity, ...subset];
const targetSha = 'da2baff621fe03b21e614965bdb77510f32a62b9';
if (reports.some((report) => report.targetSha !== targetSha || !report.complete || report.cleanup.status !== 'PASS' || report.provenance.status !== 'PASS')) throw new Error('Incomplete or mismatched evidence');
if (subset.some((report) => report.harnessSha !== subset[0].harnessSha)) throw new Error('Subset reports have inconsistent harness Git SHAs');
if (sanity.results.length !== 48 || subset.reduce((n, report) => n + report.results.length, 0) !== newCaseCount) throw new Error('Unexpected executed case count');
const results = reports.flatMap((report) => report.results.map(({ id, status, error, dependencyFailureIds, prerequisiteSeed, verifiedSubassertions }) => ({ id, status, ...(error ? { error } : {}), ...(dependencyFailureIds ? { dependencyFailureIds } : {}), ...(prerequisiteSeed ? { prerequisiteSeed } : {}), ...(verifiedSubassertions ? { verifiedSubassertions } : {}) })));
const catalog = await readReport(join(harnessRoot, 'catalog.json'));
const registered = new Set(catalog.cases.map((item) => item.id));
const executed = new Set(results.map((item) => item.id));
if (executed.size !== 48 + newCaseCount || results.some((item) => !registered.has(item.id))) throw new Error('Duplicate or unregistered result IDs');
const expectedNew = new Set([['AUTH', 7], ['PRO', 4], ['DISC', 4], ['SPC', 6], ['CH', 5], ['REQ', 5], ['DM', 9]].flatMap(([module, count]) => Array.from({ length: count }, (_, index) => `FR-${module}-${String(index + 1).padStart(2, '0')}`)));
const actualNew = new Set(subset.flatMap((report) => report.results.map((item) => item.id)));
if (actualNew.size !== expectedNew.size || [...expectedNew].some((id) => !actualNew.has(id))) throw new Error('Batch 2 did not execute the exact 40 new catalog IDs');
const expectedSanity = new Set(catalog.cases.filter((item) => item.coverage === 'EXISTING').map((item) => item.id));
if (expectedSanity.size !== 48 || sanity.results.some((item) => !expectedSanity.has(item.id))) throw new Error('Retained sanity ID mismatch');

async function sourceFiles(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    if (['output', 'node_modules', '.gitignore', 'catalog-validation.json'].includes(entry.name)) continue;
    const full = join(directory, entry.name);
    if (entry.isDirectory()) files.push(...await sourceFiles(full));
    else if (entry.isFile()) files.push(full);
  }
  return files;
}
const hash = createHash('sha256');
for (const path of (await sourceFiles(harnessRoot)).sort()) {
  hash.update(relative(harnessRoot, path).replaceAll('\\', '/'));
  hash.update(await readFile(path));
}
const statuses = ['PASS', 'FAIL', 'ERROR', 'BLOCKED', 'NEEDS_DECISION', 'SKIP'];
const tally = Object.fromEntries(statuses.map((status) => [status, results.filter((item) => item.status === status).length]));
const evidence = {
  schemaVersion: 1,
  scope: `retained-sanity-48-plus-batch2-new-${newCaseCount}`,
  targetKind: 'upstream-read-only', targetRepository: 'mathiharan29/medcollab-beta', targetSha,
  harnessAtSanitySha: sanity.harnessSha, harnessAtSubsetSha: subset[0].harnessSha, harnessContentSha256: hash.digest('hex'),
  environment: 'local Windows, Node 24, disposable MongoDB 7.0.14, loopback backend, synthetic identities, test-owned MSG91 fake; Firebase and Cloudinary disabled',
  plannedCatalogCount: 187, implementedAndExecutedHere: 48 + newCaseCount, notImplementedHere: 187 - 48 - newCaseCount,
  selectedIds: results.map((item) => item.id), tally, fullBackendSuccess: false, fullCatalogSuccess: false,
  results,
  originalReportDirectories: [`tests/functional-regression/output/sanity-adapted-${sanityRun}`, ...modules.map((name) => `tests/functional-regression/output/${name}-${subsetRun}`)],
};
const destination = join(repoRoot, 'docs/functional-regression-evidence');
await mkdir(destination, { recursive: true });
await writeFile(join(destination, `upstream-da2baff-batch2-checkpoint-${newCaseCount}.json`), `${JSON.stringify(evidence, null, 2)}\n`);
await writeFile(join(destination, `upstream-da2baff-batch2-checkpoint-${newCaseCount}.md`), `# Upstream functional regression checkpoint\n\nPinned upstream: \`${targetSha}\`. Scope: 48 retained sanity plus ${newCaseCount} new Batch 2 cases. This is a partial catalog run and **not** backend-all success.\n\n- PASS: ${tally.PASS}\n- FAIL: ${tally.FAIL}\n- BLOCKED: ${tally.BLOCKED}\n- ERROR: ${tally.ERROR}\n- NEEDS_DECISION: ${tally.NEEDS_DECISION}\n- Unimplemented catalog cases: ${187 - 48 - newCaseCount}\n\n${results.filter((item) => item.status !== 'PASS').map((item) => `- **${item.id} ${item.status}:** ${item.error || ''}`).join('\n')}\n\nThe FAIL results preserve request notification, acceptance, room-revocation and direct-conversation defects. Q2, Q7 and Q14 cases record verified subassertions while disputed contracts remain NEEDS_DECISION. See the JSON for each selected ID and seeded-prerequisite disclosures.\n`);
console.log(JSON.stringify({ destination, tally, hash: evidence.harnessContentSha256, selected: results.length }, null, 2));
