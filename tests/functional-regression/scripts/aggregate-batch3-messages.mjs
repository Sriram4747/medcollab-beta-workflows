import { createHash } from 'node:crypto';
import { mkdir, readFile, readdir, writeFile } from 'node:fs/promises';
import { join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const harnessRoot = resolve(fileURLToPath(new URL('../', import.meta.url)));
const repoRoot = resolve(harnessRoot, '../..');
const runId = process.argv[2];
if (!/^[a-f0-9-]{36}$/.test(runId || '')) throw new Error('Pass the exact message suite run UUID');
const targetSha = 'da2baff621fe03b21e614965bdb77510f32a62b9';
const modules = Array.from({ length: 8 }, (_, index) => `messages-${String(index + 1).padStart(2, '0')}`);
const reports = await Promise.all(modules.map(async (name) => JSON.parse(await readFile(join(harnessRoot, 'output', `${name}-${runId}`, 'results.json'), 'utf8'))));
if (reports.some((report) => report.targetSha !== targetSha || !report.complete || report.cleanup.status !== 'PASS' || report.provenance.status !== 'PASS' || report.results.length !== 1)) throw new Error('Incomplete, unclean or mismatched evidence');
if (reports.some((report) => report.harnessSha !== reports[0].harnessSha)) throw new Error('Inconsistent base harness SHA');
const catalog = JSON.parse(await readFile(join(harnessRoot, 'catalog.json'), 'utf8'));
const catalogById = new Map(catalog.cases.map((row) => [row.id, row]));
const results = reports.flatMap((report) => report.results);
const expected = Array.from({ length: 8 }, (_, index) => `FR-MSG-${String(index + 1).padStart(2, '0')}`);
if (new Set(results.map((row) => row.id)).size !== 8 || expected.some((id) => !results.some((row) => row.id === id && catalogById.get(id)?.tier === 'B'))) throw new Error('Batch 3 message ID set is incomplete');

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
const tally = Object.fromEntries(['PASS', 'FAIL', 'ERROR', 'BLOCKED', 'NEEDS_DECISION', 'SKIP'].map((status) => [status, results.filter((row) => row.status === status).length]));
const evidence = {
  schemaVersion: 1, scope: 'batch3-messages-8-only', targetKind: 'upstream-read-only', targetRepository: 'mathiharan29/medcollab-beta', targetSha,
  harnessBaseSha: reports[0].harnessSha, harnessContentSha256: hash.digest('hex'),
  plannedCatalogCount: 187, implementedTotalSoFar: 96, implementedBackendSoFar: 96, selectedIds: expected, tally,
  fullBackendSuccess: false, fullCatalogSuccess: false,
  results: results.map(({ id, status, errorCategory, error, verifiedSubassertions, prerequisiteSeed }) => ({ id, status, ...(errorCategory ? { errorCategory } : {}), ...(error ? { error } : {}), ...(verifiedSubassertions ? { verifiedSubassertions } : {}), ...(prerequisiteSeed ? { prerequisiteSeed } : {}) })),
  originalReportDirectories: modules.map((name) => `tests/functional-regression/output/${name}-${runId}`),
};
const destination = join(repoRoot, 'docs/functional-regression-evidence');
await mkdir(destination, { recursive: true });
await writeFile(join(destination, 'upstream-da2baff-batch3-messages-checkpoint-8.json'), `${JSON.stringify(evidence, null, 2)}\n`);
await writeFile(join(destination, 'upstream-da2baff-batch3-messages-checkpoint-8.md'), `# Batch 3 root messaging checkpoint\n\nPinned upstream: \`${targetSha}\`. Exactly eight new message cases executed. This is a **partial Batch 3** run and cannot establish full backend success.\n\n- PASS ${tally.PASS}; FAIL ${tally.FAIL}; ERROR ${tally.ERROR}; BLOCKED ${tally.BLOCKED}; NEEDS_DECISION ${tally.NEEDS_DECISION}; SKIP ${tally.SKIP}\n- Implemented catalog cases so far: 96 of 187 (48 unchanged sanity, 40 Batch 2, 8 Batch 3 message cases).\n\n${evidence.results.filter((row) => row.status !== 'PASS').map((row) => `- **${row.id} ${row.status}:** ${row.error || ''}`).join('\n')}\n`);
console.log(JSON.stringify({ destination, tally, harnessContentSha256: evidence.harnessContentSha256, selected: expected.length }, null, 2));
