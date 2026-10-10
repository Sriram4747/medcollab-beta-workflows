import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { deviceCases, emulatorOrigin, emulatorSerial, selectedDeviceCases, validateRestart, resumedActivityState } from './device-contracts.mjs';

test('device registry matches the exact eight catalog IDs, files and phases', async () => {
  const catalog = JSON.parse(await readFile(new URL('../catalog.json', import.meta.url)));
  const planned = catalog.cases.filter((row) => row.tier === 'D').map((row) => row.id).sort();
  assert.deepEqual(Object.keys(deviceCases).sort(), planned);
  for (const [id, item] of Object.entries(deviceCases)) {
    const source = await readFile(new URL(`../../../medcollab-app/integration_test/functional_regression/${item.file}`, import.meta.url), 'utf8');
    assert.match(source, new RegExp(`deviceCase\\('${id}'`));
    assert.ok(item.phases.every((phase) => source.includes(`'${phase}'`)));
  }
});

test('device driver rejects provider, physical-device and malformed origins', () => {
  assert.equal(emulatorOrigin('http://10.0.2.2:54321'), 'http://10.0.2.2:54321');
  for (const url of ['https://10.0.2.2:123', 'http://localhost:123', 'http://10.0.2.2',
    'http://10.0.2.2:123/path', 'http://10.0.2.2:123?query', 'http://name:password@10.0.2.2:123', 'https://synthetic.invalid']) {
    assert.throws(() => emulatorOrigin(url));
  }
  assert.equal(emulatorSerial('emulator-5580'), 'emulator-5580');
  assert.throws(() => emulatorSerial('physical-phone'));
  assert.throws(() => selectedDeviceCases('FR-NAV-05,FR-NAV-05'));
  assert.throws(() => selectedDeviceCases('FR-NAV-01'));
});

test('restart proof rejects same-process, stale-run and absent-phase evidence', () => {
  const checkpoints = [{ phase: 'seed', runId: 'this-run', processId: 100, status: 'PASS' },
    { phase: 'restore', runId: 'this-run', processId: 101, status: 'PASS' }];
  assert.equal(validateRestart(checkpoints, ['seed', 'restore'], 'this-run').length, 2);
  assert.throws(() => validateRestart(checkpoints, ['seed', 'missing'], 'this-run'));
  assert.throws(() => validateRestart(checkpoints, ['seed', 'restore'], 'other-run'));
  assert.throws(() => validateRestart(checkpoints.map((row) => ({ ...row, processId: 100 })), ['seed', 'restore'], 'this-run'));
});

test('activity observation accepts Android 36 fields and excludes historical activities', () => {
  const current = '  topResumedActivity=ActivityRecord{abc com.vocle.regression/MainActivity t42}\n  ResumedActivity: ActivityRecord{abc com.vocle.regression/MainActivity t42}';
  assert.match(resumedActivityState(current), /com\.vocle\.regression/);
  assert.match(resumedActivityState('mResumedActivity: ActivityRecord{old MainActivity}'), /MainActivity/);
  assert.equal(resumedActivityState('mLastResumedActivity: stale\n  activity: inactive'), '');
});
