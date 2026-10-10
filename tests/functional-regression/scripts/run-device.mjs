import { spawn, spawnSync } from 'node:child_process';
import { resolve, join, dirname } from 'node:path';
import { readFile, writeFile, mkdir, rm } from 'node:fs/promises';
import { deviceCases, devicePackage, deviceSdk, emulatorSerial, selectedDeviceCases, validateRestart } from './device-contracts.mjs';
import { prepareDeviceWorkspace, verifyDeviceSource, command, hash } from './prepare-device-workspace.mjs';

const root = resolve(import.meta.dirname, '../../..');
const option = (key) => process.argv.find((arg) => arg.startsWith(`--${key}=`))?.slice(key.length + 3);
const selected = selectedDeviceCases(option('cases'));
const flutter = option('flutter-bin') || (process.platform === 'win32' ? 'C:/flutter/bin/flutter.bat' : 'flutter');
const adb = option('adb-bin') || (process.platform === 'win32'
  ? join(process.env.LOCALAPPDATA || '', 'Android/Sdk/platform-tools/adb.exe') : 'adb');
let workspace, active, provenance = { status: 'ERROR' }, cleanup = { status: 'ERROR' };
const results = [], phases = [];
let serial;

async function runLogged(bin, args, cwd, log, timeoutMs) {
  const batch = process.platform === 'win32' && /\.(bat|cmd)$/i.test(bin);
  if (batch && [bin, ...args].some((arg) => /[&|<>^%\r\n"]/.test(arg))) throw new Error('Unsafe batch argument');
  const child = spawn(batch ? 'cmd.exe' : bin,
    batch ? ['/d', '/s', '/c', `""${bin}" ${args.map((arg) => `"${arg}"`).join(' ')}"`] : args,
    { cwd, env: { ...process.env, CI: 'true', FLUTTER_SUPPRESS_ANALYTICS: 'true' }, windowsHide: true, windowsVerbatimArguments: batch,
      stdio: ['ignore', 'pipe', 'pipe'], shell: false });
  const chunks = [];
  const output = (chunk) => { chunks.push(chunk); };
  child.stdout.on('data', output); child.stderr.on('data', output);
  const timer = setTimeout(() => {
    if (process.platform === 'win32' && child.pid && child.exitCode === null) {
      // Kill only this spawned tool tree, including Gradle/Dart children.
      spawnSync('taskkill', ['/PID', String(child.pid), '/T', '/F'], { windowsHide: true, timeout: 10000 });
    } else child.kill();
  }, timeoutMs);
  const status = await new Promise((resolveDone, reject) => {
    child.once('error', reject); child.once('exit', (code, signal) => resolveDone({ exitCode: code, signal }));
  }).finally(() => clearTimeout(timer));
  // Provider tokens/OTP/session secrets are synthetic but still redacted.
  const text = Buffer.concat(chunks).toString().replace(/eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/g, '[redacted-jwt]');
  await writeFile(log, text);
  return { ...status, log: log.slice(workspace.runRoot.length + 1), completed: status.exitCode !== null,
    assertionFailure: /TestFailure|Expected:|Application framework exception|EXCEPTION CAUGHT BY/.test(text) };
}

function lockPackages(text) {
  const entries = new Map();
  for (const match of text.matchAll(/^  ([a-zA-Z0-9_]+):\r?\n([\s\S]*?)(?=^  [a-zA-Z0-9_]+:|^sdks:|$(?![\s\S]))/gm)) {
    // The dependency label can change when an SDK helper becomes direct; the
    // actual package source/version/hash must remain identical.
    entries.set(match[1], match[2].replace(/^    dependency:.*\r?\n/m, '').replaceAll('\r', '').trim());
  }
  return entries;
}

try {
  const sdk = JSON.parse(command(flutter, ['--version', '--machine'], root, 60000));
  if (sdk.frameworkVersion !== deviceSdk) throw new Error(`Expected Flutter ${deviceSdk}; got ${sdk.frameworkVersion}`);
  const devices = command(adb, ['devices', '-l'], root).split(/\r?\n/).filter((line) => /^\S+\s+device\b/.test(line));
  if (devices.length !== 1) throw new Error('Exactly one Android emulator and no physical devices are required');
  serial = emulatorSerial(option('emulator') || devices[0].split(/\s+/)[0]);
  if (!devices[0].startsWith(`${serial} `) && !devices[0].startsWith(`${serial}\t`)) throw new Error('Emulator does not match ADB inventory');
  // Existing user installs/data are never reused. Only our dedicated package
  // may be uninstalled or force-stopped by this runner.
  workspace = await prepareDeviceWorkspace(option('source-sha'));
  await mkdir(join(workspace.runRoot, 'diagnostics'), { recursive: true });
  console.log(JSON.stringify({ deviceWorkspace: workspace.runRoot, selected, sourceSha: workspace.provenance.sourceSha }));
  const originalLock = await readFile(join(workspace.app, 'pubspec.lock'), 'utf8');
  const locked = await runLogged(flutter, ['pub', 'get'], workspace.app,
    join(workspace.runRoot, 'diagnostics/pub-get.log'), 300000);
  if (locked.exitCode !== 0) throw new Error('Isolated Flutter integration dependency resolution failed');
  const overlayLock = await readFile(join(workspace.app, 'pubspec.lock'), 'utf8');
  const originalPackages = lockPackages(originalLock), overlayPackages = lockPackages(overlayLock);
  if (originalPackages.size < 20) throw new Error('Could not validate original app lockfile');
  for (const [name, expected] of originalPackages) {
    if (overlayPackages.get(name) !== expected) throw new Error(`Device SDK overlay changed original dependency ${name}`);
  }
  workspace.provenance.overlayLockHash = hash(overlayLock);
  workspace.provenance.addedSdkPackages = [...overlayPackages.keys()].filter((name) => !originalPackages.has(name));
  workspace.provenance.sdk = sdk;
  await writeFile(join(workspace.runRoot, 'provenance.json'), JSON.stringify(workspace.provenance, null, 2));
  const npm = process.platform === 'win32' ? process.execPath : 'npm';
  const npmArgs = process.platform === 'win32' ? [join(dirname(process.execPath), 'node_modules/npm/bin/npm-cli.js'), 'ci', '--ignore-scripts'] : ['ci', '--ignore-scripts'];
  const installed = await runLogged(npm, npmArgs, join(workspace.target, 'medcollab-backend'),
    join(workspace.runRoot, 'diagnostics/npm-ci.log'), 300000);
  if (installed.exitCode !== 0) throw new Error('Disposable backend dependency installation failed');
  process.env.VOCLE_TARGET_DIR = workspace.target;
  process.env.VOCLE_OUTPUT_DIR = workspace.runRoot;
  // Use a known downloaded test binary when supplied, never a Mongo URI.
  if (option('mongo-bin')) process.env.MONGOMS_SYSTEM_BINARY = resolve(option('mongo-bin'));
  const { startDeviceServer } = await import('./device-server.mjs');
  for (const id of selected) {
    let caseCleanup = { status: 'ERROR' };
    try {
      const packages = command(adb, ['-s', serial, 'shell', 'pm', 'list', 'packages', devicePackage], root);
      if (packages.includes(`package:${devicePackage}`)) command(adb, ['-s', serial, 'uninstall', devicePackage], root);
      active = await startDeviceServer({ adb, serial, caseId: id });
      let failedPhase;
      for (const phase of deviceCases[id].phases) {
        const processes = command(adb, ['-s', serial, 'shell', 'ps', '-A'], root);
        if (processes.includes(devicePackage)) active.forceStop();
        console.log(`Executing ${id} native phase ${phase}`);
        // flutter test uninstalls the app on completion. flutter drive leaves
        // native data in place, which is essential for real process-death tests.
        const args = ['drive', `--target=integration_test/functional_regression/${deviceCases[id].file}`,
          '--driver=test_driver/functional_regression_driver.dart', '-d', serial,
          '--debug', '--keep-app-running', '--no-pub', '--dart-define=ENABLE_API_LOGGING=false',
          `--dart-define=API_BASE_URL=${active.apiOrigin}`, `--dart-define=SOCKET_URL=${active.apiOrigin}`,
          `--dart-define=DEVICE_CONTROL_URL=${active.controlOrigin}`, `--dart-define=DEVICE_RUN_ID=${active.runId}`,
          `--dart-define=DEVICE_PHASE=${phase}`];
        const phaseResult = await runLogged(flutter, args, workspace.app,
          join(workspace.runRoot, 'diagnostics', `${id}-${phase}.log`), 600000);
        phases.push({ id, phase, ...phaseResult });
        if (phaseResult.exitCode !== 0) { failedPhase = phaseResult; break; }
      }
      const records = active.results.filter((row) => row.id === id);
      if (records.length > 1) throw new Error(`Duplicate device record ${id}`);
      if (records.length === 1) {
        results.push(records[0]);
        if (failedPhase && ['PASS', 'NEEDS_DECISION'].includes(records[0].status)) {
          records[0].status = failedPhase.assertionFailure ? 'FAIL' : 'ERROR';
          records[0].error = 'Flutter reported a subsequent failure after the case body; inspect phase diagnostics';
        }
      }
      else results.push({ id, status: failedPhase?.assertionFailure ? 'FAIL' : 'ERROR', executed: Boolean(failedPhase?.assertionFailure),
        error: 'Device phase ended without a complete catalog result; inspect phase diagnostics', phaseEvidence: phases.filter((row) => row.id === id) });
      if (id === 'FR-NAV-05' && results.at(-1).status === 'PASS') validateRestart(active.checkpoints, deviceCases[id].phases, active.runId);
      if (id === 'FR-JRN-06' && results.at(-1).status === 'PASS') validateRestart(active.checkpoints, deviceCases[id].phases, active.runId);
      await writeFile(join(workspace.runRoot, `${id}-events.json`), JSON.stringify({ checkpoints: active.checkpoints,
        controlActions: active.controlRecords, backendRequests: active.requests }, null, 2));
    } catch (error) {
      const existing = results.find((row) => row.id === id);
      if (existing) { existing.status = 'ERROR'; existing.error = error.message; }
      else results.push({ id, status: error.name === 'HttpContractError' ? 'FAIL' : 'ERROR', executed: false,
        error: error.message, ...(error.deviceCleanup ? { cleanup: error.deviceCleanup } : {}) });
    } finally {
      try { caseCleanup = active ? await active.close() : { status: 'PASS', setupNeverStarted: true }; }
      catch (error) { caseCleanup = { status: 'ERROR', error: error.message }; }
      active = null;
      const row = results.find((item) => item.id === id);
      if (row && !row.cleanup) row.cleanup = caseCleanup;
    }
  }
  provenance = await verifyDeviceSource(workspace);
} catch (error) {
  for (const id of selected) if (!results.some((row) => row.id === id)) {
    results.push({ id, status: 'ERROR', executed: false, error: error.message, errorCategory: 'DEVICE_PREREQUISITE' });
  }
} finally {
  try {
    if (active) await active.close();
    if (serial) {
      const packages = command(adb, ['-s', serial, 'shell', 'pm', 'list', 'packages', devicePackage], root);
      if (packages.includes(`package:${devicePackage}`)) command(adb, ['-s', serial, 'uninstall', devicePackage], root);
    }
    if (workspace) {
      provenance = await verifyDeviceSource(workspace);
      // Keep logs/source archive/provenance; remove test-owned credentials and
      // dependencies with the isolated target after checking unchanged source.
      await rm(workspace.target, { recursive: true, force: true });
    }
    cleanup = { status: results.some((row) => row.cleanup?.status === 'ERROR') ? 'ERROR' : 'PASS',
      dedicatedTestAppRemoved: Boolean(serial), isolatedTargetRemoved: Boolean(workspace) };
  } catch (error) { cleanup = { status: 'ERROR', error: error.message }; }
  const directory = workspace?.runRoot || resolve(root, 'tests/functional-regression/output/device-prerequisites');
  await mkdir(directory, { recursive: true });
  const counts = Object.fromEntries(['PASS', 'FAIL', 'ERROR', 'BLOCKED', 'NEEDS_DECISION', 'SKIP'].map((status) =>
    [status, results.filter((row) => row.status === status).length]));
  const report = { tier: 'D', platform: 'Android emulator', selected, planned: Object.keys(deviceCases).length,
    sourceSha: workspace?.provenance.sourceSha || null, harnessSha: workspace?.provenance.harnessSha || null,
    executed: results.filter((row) => row.executed).length, counts, cases: results, phases, provenance, cleanup,
    fullSuccess: selected.length === 8 && counts.PASS === 8 && provenance.status === 'PASS' && cleanup.status === 'PASS',
    providerDeliveryProven: false, iosImplemented: false, transportOutage: 'test-owned local gateway; no claim of carrier/radio delivery',
    generatedAt: new Date().toISOString() };
  await writeFile(join(directory, 'results.json'), JSON.stringify(report, null, 2));
  await writeFile(join(directory, 'coverage.json'), JSON.stringify({ planned: 8, selected, executed: report.executed, counts, fullSuccess: report.fullSuccess }, null, 2));
  await writeFile(join(directory, 'cleanup.json'), JSON.stringify(cleanup, null, 2));
  const escape = (value) => String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('"', '&quot;');
  await writeFile(join(directory, 'junit.xml'), `<testsuite name="Vocle Android device" tests="${results.length}" failures="${counts.FAIL + counts.NEEDS_DECISION}" errors="${counts.ERROR + counts.BLOCKED}">\n${results.map((row) => `<testcase name="${row.id}">${row.status === 'PASS' ? '' : `<${row.status === 'FAIL' || row.status === 'NEEDS_DECISION' ? 'failure' : 'error'} message="${row.status}">${escape(row.error || '')}</${row.status === 'FAIL' || row.status === 'NEEDS_DECISION' ? 'failure' : 'error'}>`}</testcase>`).join('\n')}\n</testsuite>\n`);
  await writeFile(join(directory, 'report.md'), `# Android device regression\n\nSource: ${report.sourceSha}; harness: ${report.harnessSha}.\nExecuted: ${report.executed}/${selected.length}; full success: ${report.fullSuccess}.\n\n| ID | Status | Executed |\n| --- | --- | --- |\n${results.map((row) => `| ${row.id} | ${row.status} | ${row.executed} |`).join('\n')}\n\nProvenance: ${provenance.status}; cleanup: ${cleanup.status}.\nNo real provider delivery or iOS coverage claimed.\n`);
  console.log(JSON.stringify({ reportDirectory: directory, counts, executed: report.executed, fullSuccess: report.fullSuccess }));
  if (!report.fullSuccess) process.exitCode = 1;
}
