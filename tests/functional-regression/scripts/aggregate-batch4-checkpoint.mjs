import { createHash } from 'node:crypto';
import { mkdir, readFile, readdir, writeFile } from 'node:fs/promises';
import { join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(fileURLToPath(new URL('../', import.meta.url)));
const repo = resolve(root, '../..');
const sourceSha = 'da2baff621fe03b21e614965bdb77510f32a62b9';
const modules = [
  ['handoffs', 'HOF', 10], ['media', 'MED', 7], ['support', 'SUP', 3], ['runtime', 'RUN', 2], ['journeys', 'JRN', 4],
];
const provided = process.argv.slice(2);
if (provided.length < 1 || provided.length > modules.length || provided.some((arg) => !/^[a-f0-9-]{36}$/.test(arg))) throw new Error('Pass consecutive Batch 4 module run UUIDs');
const catalog = JSON.parse(await readFile(join(root, 'catalog.json'), 'utf8'));
const byId = new Map(catalog.cases.map((item) => [item.id, item]));
const expected = modules.slice(0, provided.length).flatMap(([, prefix, count]) => Array.from({ length: count }, (_, index) => `FR-${prefix}-${String(index + 1).padStart(2, '0')}`));
const reports = await Promise.all(provided.map(async (id, index) => JSON.parse(await readFile(join(root, 'output', `${modules[index][0]}-${id}`, 'results.json'), 'utf8'))));
for (let index = 0; index < reports.length; index++) {
  const report = reports[index];
  const ids = expected.slice(modules.slice(0, index).reduce((sum, item) => sum + item[2], 0), modules.slice(0, index + 1).reduce((sum, item) => sum + item[2], 0));
  if (report.targetSha !== sourceSha || !report.complete || report.cleanup.status !== 'PASS' || report.provenance.status !== 'PASS') throw new Error(`Invalid source, completeness, cleanup or provenance for ${modules[index][0]}`);
  if (JSON.stringify(report.selectedIds) !== JSON.stringify(ids) || JSON.stringify(report.results.map((item) => item.id)) !== JSON.stringify(ids)) throw new Error(`Incorrect selected IDs for ${modules[index][0]}`);
}
if (expected.some((id) => byId.get(id)?.tier !== 'B' || byId.get(id)?.coverage !== 'NEW')) throw new Error('Catalog mismatch');
async function files(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const found = [];
  for (const entry of entries) {
    if (['output', 'node_modules', '.gitignore', 'catalog-validation.json'].includes(entry.name)) continue;
    const full = join(directory, entry.name);
    if (entry.isDirectory()) found.push(...await files(full));
    else if (entry.isFile()) found.push(full);
  }
  return found;
}
const hash = createHash('sha256');
for (const path of (await files(root)).sort()) {
  hash.update(relative(root, path).replaceAll('\\', '/'));
  hash.update(await readFile(path));
}
const results = reports.flatMap((item) => item.results);
const tally = Object.fromEntries(['PASS', 'FAIL', 'ERROR', 'BLOCKED', 'NEEDS_DECISION', 'SKIP'].map((status) => [status, results.filter((item) => item.status === status).length]));
const evidence = {
  schemaVersion: 1, scope: `batch4-new-${expected.length}-only`, targetKind: 'upstream-read-only', targetRepository: 'mathiharan29/medcollab-beta', targetSha: sourceSha,
  plannedCatalogCount: 187, selectedIds: expected, tally, implementedBackendSoFar: 121 + expected.length, fullBackendSuccess: false, fullCatalogSuccess: false,
  harnessBaseShas: Object.fromEntries(reports.map((item, index) => [modules[index][0], item.harnessSha])), harnessContentSha256: hash.digest('hex'),
  results: results.map(({ id, status, errorCategory, error, verifiedSubassertions, prerequisiteSeed }) => ({ id, status, ...(errorCategory ? { errorCategory } : {}), ...(error ? { error } : {}), ...(verifiedSubassertions ? { verifiedSubassertions } : {}), ...(prerequisiteSeed ? { prerequisiteSeed } : {}) })),
  originalReportDirectories: provided.map((id, index) => `tests/functional-regression/output/${modules[index][0]}-${id}`),
};
const destination = join(repo, 'docs/functional-regression-evidence');
await mkdir(destination, { recursive: true });
const stem = `upstream-da2baff-batch4-checkpoint-${expected.length}`;
await writeFile(join(destination, `${stem}.json`), `${JSON.stringify(evidence, null, 2)}\n`);
await writeFile(join(destination, `${stem}.md`), `# Batch 4 ${expected.length === 26 ? 'implementation' : 'partial'} checkpoint\n\nPinned upstream: \`${sourceSha}\`. ${expected.length} new Batch 4 backend cases executed. **Backend-all success is false**.\n\n- PASS ${tally.PASS}; FAIL ${tally.FAIL}; ERROR ${tally.ERROR}; BLOCKED ${tally.BLOCKED}; NEEDS_DECISION ${tally.NEEDS_DECISION}; SKIP ${tally.SKIP}\n- Implemented catalog cases so far: ${121 + expected.length} of 187.\n\n${evidence.results.filter((item) => item.status !== 'PASS').map((item) => `- **${item.id} ${item.status}:** ${item.error || ''}`).join('\n')}\n`.trimEnd() + '\n');
console.log(JSON.stringify({ selected: expected.length, tally, harnessContentSha256: evidence.harnessContentSha256 }, null, 2));
