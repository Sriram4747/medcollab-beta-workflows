import { mkdir, writeFile } from 'node:fs/promises';
import { join } from 'node:path';

const xml = (value) => String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&apos;');

export async function writePlannedReports({ outputDirectory, scenarios, checks }) {
  await mkdir(outputDirectory, { recursive: true });
  const createdAt = new Date().toISOString();
  const report = {
    schemaVersion: 1,
    phase: 1,
    result: 'planned',
    execution: 'not-executed',
    createdAt,
    expectedScenarioCount: scenarios.length,
    passedScenarioCount: 0,
    scenarios,
    checks,
    note: 'This report is a harness self-check and is not success-history evidence.',
  };
  await writeFile(join(outputDirectory, 'sanity-report.json'), `${JSON.stringify(report, null, 2)}\n`);
  const testCases = scenarios.map(({ id, name }) => `  <testcase classname="planned.${xml(id)}" name="${xml(name)}"><skipped message="planned; not executed in Phase 1" /></testcase>`).join('\n');
  await writeFile(join(outputDirectory, 'sanity-report.junit.xml'), `<?xml version="1.0" encoding="UTF-8"?>\n<testsuite name="vocle-sanity-planned" tests="${scenarios.length}" skipped="${scenarios.length}" failures="0" errors="0">\n${testCases}\n</testsuite>\n`);
  await writeFile(join(outputDirectory, 'sanity-report.md'), `# Vocle sanity Phase 1 self-check\n\nResult: **PLANNED / NOT EXECUTED**\n\n- Expected scenarios: ${scenarios.length}\n- Passed scenarios: 0\n- Registry/configuration checks: ${checks.length}\n\nThis output cannot be used as successful sanity evidence.\n`);
  return report;
}
