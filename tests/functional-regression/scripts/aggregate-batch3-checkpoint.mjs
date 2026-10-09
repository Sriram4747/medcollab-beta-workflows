import { createHash } from 'node:crypto';
import { mkdir, readFile, readdir, writeFile } from 'node:fs/promises';
import { join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(fileURLToPath(new URL('../', import.meta.url)));
const repo = resolve(root, '../..');
const [messageRun, threadRun, socialRun, notificationRun, pushRun, realtimeRun, searchRun] = process.argv.slice(2);
if (![messageRun, threadRun, socialRun, notificationRun, pushRun, realtimeRun, searchRun].filter(Boolean).every((id) => /^[a-f0-9-]{36}$/.test(id)) || !messageRun || !threadRun || (notificationRun && !socialRun) || (pushRun && !notificationRun) || (realtimeRun && !pushRun) || (searchRun && !realtimeRun)) throw new Error('Pass exact consecutive Batch 3 module run UUIDs');
const names = [
  ...Array.from({ length: 8 }, (_, index) => [`messages-${String(index + 1).padStart(2, '0')}`, messageRun]),
  ...Array.from({ length: 4 }, (_, index) => [`threads-${String(index + 1).padStart(2, '0')}`, threadRun]),
  ...(socialRun ? Array.from({ length: 5 }, (_, index) => [`social-${String(index + 1).padStart(2, '0')}`, socialRun]) : []),
  ...(notificationRun ? Array.from({ length: 5 }, (_, index) => [`notifications-${String(index + 1).padStart(2, '0')}`, notificationRun]) : []),
  ...(pushRun ? Array.from({ length: 4 }, (_, index) => [`push-${String(index + 1).padStart(2, '0')}`, pushRun]) : []),
  ...(realtimeRun ? [1, 2, 3, 7].map((index) => [`realtime-${String(index).padStart(2, '0')}`, realtimeRun]) : []),
  ...(searchRun ? Array.from({ length: 3 }, (_, index) => [`search-${String(index + 1).padStart(2, '0')}`, searchRun]) : []),
];
const reports = await Promise.all(names.map(async ([name, id]) => JSON.parse(await readFile(join(root, 'output', `${name}-${id}`, 'results.json'), 'utf8'))));
const sourceSha = 'da2baff621fe03b21e614965bdb77510f32a62b9';
if (reports.some((row) => row.targetSha !== sourceSha || !row.complete || row.cleanup.status !== 'PASS' || row.provenance.status !== 'PASS' || row.results.length !== 1)) throw new Error('Invalid source, completeness, provenance or cleanup');
for (const [start, end] of [[0, 8], [8, 12], [12, 17], [17, 22], [22, 26], [26, 30], [30, 33]]) {
  if (reports.length > start && reports.slice(start, Math.min(end, reports.length)).some((row) => row.harnessSha !== reports[start].harnessSha)) throw new Error(`Mixed base harness SHAs within module group ${start}-${end}`);
}
const catalog = JSON.parse(await readFile(join(root, 'catalog.json'), 'utf8'));
const byId = new Map(catalog.cases.map((row) => [row.id, row]));
const expected = [['MSG', [1,2,3,4,5,6,7,8]], ['THR', [1,2,3,4]], ...(socialRun ? [['SOC', [1,2,3,4,5]]] : []), ...(notificationRun ? [['NOT', [1,2,3,4,5]]] : []), ...(pushRun ? [['PUSH', [1,2,3,4]]] : []), ...(realtimeRun ? [['RT', [1,2,3,7]]] : []), ...(searchRun ? [['SRCH', [1,2,3]]] : [])].flatMap(([module, indexes]) => indexes.map((index) => `FR-${module}-${String(index).padStart(2, '0')}`));
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
  schemaVersion: 1, scope: `batch3-new-${expected.length}-only`, targetKind: 'upstream-read-only', targetRepository: 'mathiharan29/medcollab-beta', targetSha: sourceSha,
  harnessAtMessagesSha: reports[0].harnessSha, harnessAtThreadsSha: reports[8].harnessSha, ...(socialRun ? { harnessAtSocialSha: reports[12].harnessSha } : {}), ...(notificationRun ? { harnessAtNotificationsSha: reports[17].harnessSha } : {}), ...(pushRun ? { harnessAtPushSha: reports[22].harnessSha } : {}), ...(realtimeRun ? { harnessAtRealtimeSha: reports[26].harnessSha } : {}), ...(searchRun ? { harnessAtSearchSha: reports[30].harnessSha } : {}), harnessContentSha256: hash.digest('hex'), plannedCatalogCount: 187,
  implementedTotalSoFar: 88 + expected.length, implementedBackendSoFar: 88 + expected.length, selectedIds: expected, tally, fullBackendSuccess: false, fullCatalogSuccess: false,
  results: results.map(({ id, status, errorCategory, error, verifiedSubassertions, prerequisiteSeed }) => ({ id, status, ...(errorCategory ? { errorCategory } : {}), ...(error ? { error } : {}), ...(verifiedSubassertions ? { verifiedSubassertions } : {}), ...(prerequisiteSeed ? { prerequisiteSeed } : {}) })),
  originalReportDirectories: names.map(([name, id]) => `tests/functional-regression/output/${name}-${id}`),
};
const destination = join(repo, 'docs/functional-regression-evidence');
await mkdir(destination, { recursive: true });
const stem = `upstream-da2baff-batch3-checkpoint-${expected.length}`;
await writeFile(join(destination, `${stem}.json`), `${JSON.stringify(evidence, null, 2)}\n`);
await writeFile(join(destination, `${stem}.md`), `# Batch 3 ${expected.length === 33 ? 'implementation' : 'partial'} checkpoint\n\nPinned upstream: \`${sourceSha}\`. ${expected.length} new Batch 3 cases executed. ${expected.length === 33 ? 'All planned Batch 3 cases are implemented and executed.' : 'This is a partial Batch 3 run.'} **Backend-all success is false**.\n\n- PASS ${tally.PASS}; FAIL ${tally.FAIL}; ERROR ${tally.ERROR}; BLOCKED ${tally.BLOCKED}; NEEDS_DECISION ${tally.NEEDS_DECISION}; SKIP ${tally.SKIP}\n- Implemented catalog cases so far: ${88 + expected.length} of 187 (48 retained sanity, 40 Batch 2, ${expected.length} Batch 3).\n\n${evidence.results.filter((row) => row.status !== 'PASS').map((row) => `- **${row.id} ${row.status}:** ${row.error || ''}`).join('\n')}\n`.trimEnd() + '\n');
console.log(JSON.stringify({ destination, tally, harnessContentSha256: evidence.harnessContentSha256, selected: expected.length }, null, 2));
