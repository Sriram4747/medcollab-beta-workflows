import { createHash } from 'node:crypto';
import { mkdir, readFile, readdir, writeFile } from 'node:fs/promises';
import { join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(fileURLToPath(new URL('../', import.meta.url)));
const repo = resolve(root, '../..');
const [messageRun, threadRun, socialRun] = process.argv.slice(2);
if (![messageRun, threadRun, socialRun].filter(Boolean).every((id) => /^[a-f0-9-]{36}$/.test(id)) || !messageRun || !threadRun) throw new Error('Pass exact message and thread run UUIDs, optionally followed by the social run UUID');
const names = [
  ...Array.from({ length: 8 }, (_, index) => [`messages-${String(index + 1).padStart(2, '0')}`, messageRun]),
  ...Array.from({ length: 4 }, (_, index) => [`threads-${String(index + 1).padStart(2, '0')}`, threadRun]),
  ...(socialRun ? Array.from({ length: 5 }, (_, index) => [`social-${String(index + 1).padStart(2, '0')}`, socialRun]) : []),
];
const reports = await Promise.all(names.map(async ([name, id]) => JSON.parse(await readFile(join(root, 'output', `${name}-${id}`, 'results.json'), 'utf8'))));
const sourceSha = 'da2baff621fe03b21e614965bdb77510f32a62b9';
if (reports.some((row) => row.targetSha !== sourceSha || !row.complete || row.cleanup.status !== 'PASS' || row.provenance.status !== 'PASS' || row.results.length !== 1)) throw new Error('Invalid source, completeness, provenance or cleanup');
if (reports.slice(0, 8).some((row) => row.harnessSha !== reports[0].harnessSha) || reports.slice(8, 12).some((row) => row.harnessSha !== reports[8].harnessSha) || (socialRun && reports.slice(12).some((row) => row.harnessSha !== reports[12].harnessSha))) throw new Error('Mixed base harness SHAs within a module group');
const catalog = JSON.parse(await readFile(join(root, 'catalog.json'), 'utf8'));
const byId = new Map(catalog.cases.map((row) => [row.id, row]));
const expected = [['MSG', 8], ['THR', 4], ...(socialRun ? [['SOC', 5]] : [])].flatMap(([module, count]) => Array.from({ length: count }, (_, index) => `FR-${module}-${String(index + 1).padStart(2, '0')}`));
const results = reports.flatMap((row) => row.results);
if (new Set(results.map((row) => row.id)).size !== expected.length || expected.some((id) => !results.some((row) => row.id === id && byId.get(id)?.tier === 'B'))) throw new Error('Selected ID set is incomplete or duplicated');
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
const tally = Object.fromEntries(['PASS', 'FAIL', 'ERROR', 'BLOCKED', 'NEEDS_DECISION', 'SKIP'].map((status) => [status, results.filter((row) => row.status === status).length]));
const evidence = {
  schemaVersion: 1, scope: socialRun ? 'batch3-messages-threads-social-17-only' : 'batch3-messages-and-threads-12-only', targetKind: 'upstream-read-only', targetRepository: 'mathiharan29/medcollab-beta', targetSha: sourceSha,
  harnessAtMessagesSha: reports[0].harnessSha, harnessAtThreadsSha: reports[8].harnessSha, ...(socialRun ? { harnessAtSocialSha: reports[12].harnessSha } : {}), harnessContentSha256: hash.digest('hex'), plannedCatalogCount: 187,
  implementedTotalSoFar: 88 + expected.length, implementedBackendSoFar: 88 + expected.length, selectedIds: expected, tally, fullBackendSuccess: false, fullCatalogSuccess: false,
  results: results.map(({ id, status, errorCategory, error, verifiedSubassertions, prerequisiteSeed }) => ({ id, status, ...(errorCategory ? { errorCategory } : {}), ...(error ? { error } : {}), ...(verifiedSubassertions ? { verifiedSubassertions } : {}), ...(prerequisiteSeed ? { prerequisiteSeed } : {}) })),
  originalReportDirectories: names.map(([name, id]) => `tests/functional-regression/output/${name}-${id}`),
};
const destination = join(repo, 'docs/functional-regression-evidence');
await mkdir(destination, { recursive: true });
const stem = `upstream-da2baff-batch3-checkpoint-${expected.length}`;
await writeFile(join(destination, `${stem}.json`), `${JSON.stringify(evidence, null, 2)}\n`);
await writeFile(join(destination, `${stem}.md`), `# Batch 3 partial checkpoint\n\nPinned upstream: \`${sourceSha}\`. ${expected.length} new Batch 3 cases executed. This is a partial Batch 3 run; **backend-all success is false**.\n\n- PASS ${tally.PASS}; FAIL ${tally.FAIL}; ERROR ${tally.ERROR}; BLOCKED ${tally.BLOCKED}; NEEDS_DECISION ${tally.NEEDS_DECISION}; SKIP ${tally.SKIP}\n- Implemented catalog cases so far: ${88 + expected.length} of 187 (48 retained sanity, 40 Batch 2, ${expected.length} Batch 3).\n\n${evidence.results.filter((row) => row.status !== 'PASS').map((row) => `- **${row.id} ${row.status}:** ${row.error || ''}`).join('\n')}\n`);
console.log(JSON.stringify({ destination, tally, harnessContentSha256: evidence.harnessContentSha256, selected: expected.length }, null, 2));
