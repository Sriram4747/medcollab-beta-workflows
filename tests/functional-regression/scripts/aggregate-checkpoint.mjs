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
const modules = ['auth', 'profile', 'discovery', 'spaces', 'channels', 'requests', 'conversations'];
const readReport = async (path) => JSON.parse(await readFile(path, 'utf8'));
const sanity = await readReport(join(output, `sanity-adapted-${sanityRun}`, 'results.json'));
const subset = await Promise.all(modules.map((name) => readReport(join(output, `${name}-${subsetRun}`, 'results.json'))));
const reports = [sanity, ...subset];
const targetSha = 'da2baff621fe03b21e614965bdb77510f32a62b9';
if (reports.some((report) => report.targetSha !== targetSha || !report.complete || report.cleanup.status !== 'PASS' || report.provenance.status !== 'PASS')) throw new Error('Incomplete or mismatched evidence');
if (sanity.results.length !== 48 || subset.reduce((n, report) => n + report.results.length, 0) !== 20) throw new Error('Unexpected executed case count');
const results = reports.flatMap((report) => report.results.map(({ id, status, error, dependencyFailureIds, prerequisiteSeed, verifiedSubassertions }) => ({ id, status, ...(error ? { error } : {}), ...(dependencyFailureIds ? { dependencyFailureIds } : {}), ...(prerequisiteSeed ? { prerequisiteSeed } : {}), ...(verifiedSubassertions ? { verifiedSubassertions } : {}) })));
const catalog = await readReport(join(harnessRoot, 'catalog.json'));
const registered = new Set(catalog.cases.map((item) => item.id));
const executed = new Set(results.map((item) => item.id));
if (executed.size !== 68 || results.some((item) => !registered.has(item.id))) throw new Error('Duplicate or unregistered result IDs');

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
  scope: 'retained-sanity-48-plus-batch2-new-20',
  targetKind: 'upstream-read-only', targetRepository: 'mathiharan29/medcollab-beta', targetSha,
  harnessBaseSha: sanity.harnessSha, harnessContentSha256: hash.digest('hex'),
  environment: 'local Windows, Node 24, disposable MongoDB 7.0.14, loopback backend, synthetic identities, test-owned MSG91 fake; Firebase and Cloudinary disabled',
  plannedCatalogCount: 187, implementedAndExecutedHere: 68, notImplementedHere: 119,
  selectedIds: results.map((item) => item.id), tally, fullBackendSuccess: false, fullCatalogSuccess: false,
  results,
  originalReportDirectories: [`tests/functional-regression/output/sanity-adapted-${sanityRun}`, ...modules.map((name) => `tests/functional-regression/output/${name}-${subsetRun}`)],
};
const destination = join(repoRoot, 'docs/functional-regression-evidence');
await mkdir(destination, { recursive: true });
await writeFile(join(destination, 'upstream-da2baff-batch2-checkpoint.json'), `${JSON.stringify(evidence, null, 2)}\n`);
await writeFile(join(destination, 'upstream-da2baff-batch2-checkpoint.md'), `# Upstream functional regression checkpoint\n\nPinned upstream: \`${targetSha}\`. Scope: 48 retained sanity plus 20 new Batch 2 cases. This is a partial catalog run and **not** backend-all success.\n\n- PASS: ${tally.PASS}\n- FAIL: ${tally.FAIL}\n- BLOCKED: ${tally.BLOCKED}\n- ERROR: ${tally.ERROR}\n- NEEDS_DECISION: ${tally.NEEDS_DECISION}\n- Unimplemented catalog cases: 119\n\n${results.filter((item) => item.status !== 'PASS').map((item) => `- **${item.id} ${item.status}:** ${item.error || ''}`).join('\n')}\n\nFR-SPC-03 verified safe subassertions and remains NEEDS_DECISION under Q14. The retained sanity request failures and FR-DM-01 timeout remain application defects. See the JSON for each selected ID and seeded-prerequisite disclosures.\n`);
console.log(JSON.stringify({ destination, tally, hash: evidence.harnessContentSha256, selected: results.length }, null, 2));
