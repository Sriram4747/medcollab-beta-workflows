import { readFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { git } from './process.mjs';

export function validateCoverage({ oldCases, newCases, changedFiles, declaration, authorizedExceptions = [] }) {
  const errors = [], byId = new Map(newCases.map(c => [c.id, c]));
  if (byId.size !== newCases.length) errors.push('Duplicate testcase IDs');
  for (const c of oldCases) if (!byId.has(c.id)) errors.push('Stable testcase removed: ' + c.id);
  const appChanged = changedFiles.some(f => /^medcollab-(backend\/src|app\/lib)\//.test(f));
  if (!appChanged) return errors;
  if (!declaration) return [...errors, 'Application change requires .github/regression-coverage.json'];
  if (declaration.schemaVersion !== 1 || typeof declaration.newFeature !== 'boolean' || typeof declaration.securityRelevant !== 'boolean' || !declaration.reviewReason) errors.push('Coverage declaration requires schemaVersion, newFeature, securityRelevant and reviewReason');
  const selected = declaration.testcaseIds || [];
  if (!selected.length || selected.some(id => !byId.has(id))) errors.push('Coverage declaration needs registered functional testcase IDs');
  if (declaration.newFeature && !selected.some(id => !oldCases.some(c => c.id === id))) errors.push('New feature requires a newly registered regression testcase');
  if (!declaration.localCommand || !declaration.ciWorkflow || !declaration.crossFeatureReview) errors.push('Local command, CI workflow and independent cross-feature QA review are required');
  if (declaration.securityRelevant && (!(declaration.securityTestcaseIds || []).length || !declaration.securityWorkflow)) errors.push('Security-relevant change requires security testcase IDs and a workflow');
  if (!declaration.securityRelevant && !declaration.securityReason) errors.push('Explain why security coverage is unaffected');
  // A declaration alone cannot authorize an exception. Trusted base metadata is the authority.
  if (declaration.exceptionId && !authorizedExceptions.some(e => e.id === declaration.exceptionId && e.approvedBy && Date.parse(e.expiresAt) > Date.now())) errors.push('Exception lacks current authorization in the trusted base revision');
  return errors;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const root = resolve(import.meta.dirname, '../..'), base = process.argv[2];
  if (!/^[a-f0-9]{40}$/.test(base || '')) throw new Error('Exact base SHA required');
  const oldCases = JSON.parse(git(root, ['show', base + ':tests/functional-regression/catalog.json'])).cases;
  const newCases = JSON.parse(await readFile(resolve(root, 'tests/functional-regression/catalog.json'))).cases;
  const changedFiles = git(root, ['diff', '--name-only', base, 'HEAD']).split(/\r?\n/).filter(Boolean);
  let declaration; try { declaration = JSON.parse(await readFile(resolve(root, '.github/regression-coverage.json'))); } catch { /* mandatory only for application changes */ }
  let authorizedExceptions = []; try { authorizedExceptions = JSON.parse(git(root, ['show', base + ':.github/regression-exceptions.json'])).exceptions; } catch { /* no pre-existing authorization */ }
  const errors = validateCoverage({ oldCases, newCases, changedFiles, declaration, authorizedExceptions });
  if (declaration && changedFiles.some(f => /^medcollab-(backend\/src|app\/lib)\//.test(f))) {
    const implementation = git(root, ['grep', '-n', '-E', (declaration.testcaseIds || []).join('|') || 'NEVER_MATCH', '--', 'tests/sanity/src', 'tests/functional-regression/suites', 'medcollab-app/test', 'medcollab-app/integration_test']);
    for (const id of declaration.testcaseIds || []) if (!implementation.includes(id)) errors.push('No executable test source reference: ' + id);
    if (declaration.securityRelevant) {
      const registry = git(root, ['grep', '-n', '-E', declaration.securityTestcaseIds.join('|'), '--', 'medcollab-backend/scripts', 'docs/SECURITY_REGRESSION_GATES.json']);
      for (const id of declaration.securityTestcaseIds) if (!registry.includes(id)) errors.push('Security testcase not registered: ' + id);
    }
  }
  console.log(JSON.stringify({ status: errors.length ? 'FAIL' : 'PASS', errors, changedFiles, review: 'This check cannot detect every missing testcase. Authorized reviewers assess assertion quality, feature scope and cross-feature effects.' }, null, 2));
  if (errors.length) process.exitCode = 1;
}
