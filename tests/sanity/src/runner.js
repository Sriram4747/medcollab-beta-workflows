import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';
import { validateStaticConfig } from './config.js';
import { expectedScenarioCount, scenarios, validateScenarioRegistry } from './scenarios.js';
import { writePlannedReports } from './reporting.js';

const here = dirname(fileURLToPath(import.meta.url));
const outputDirectory = resolve(here, '..', 'output');

async function main() {
  if (!process.argv.includes('--self-check')) {
    throw new Error('Phase 1 only supports --self-check; live scenario execution is not implemented yet.');
  }
  const failures = [...validateStaticConfig(), ...validateScenarioRegistry()];
  if (failures.length > 0) throw new Error(`Sanity harness contract failed:\n- ${failures.join('\n- ')}`);
  const checks = ['static target configuration', 'isolation configuration', 'fixture identity contract', 'scenario registry'];
  await writePlannedReports({ outputDirectory, scenarios, checks });
  console.log(`Phase 1 self-check passed: ${expectedScenarioCount} planned scenarios; reports written to ${outputDirectory}.`);
}

main().catch((error) => {
  console.error(error.stack || error.message);
  process.exitCode = 1;
});
