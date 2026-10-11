// Executes existing security assertions in a network-none Linux container only.
import { createRequire } from 'node:module';
import { readdir, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import { spawn } from 'node:child_process';
import { run } from './process.mjs';
const backend = '/target/medcollab-backend';
if (process.platform !== 'linux' || JSON.stringify((await readdir('/sys/class/net')).sort()) !== '["lo"]') throw new Error('Linux network-none runtime required');
const require = createRequire(join(backend, 'package.json'));
const { MongoMemoryServer } = require('mongodb-memory-server');
const env = { PATH: process.env.PATH, HOME: '/tmp', NODE_ENV: 'test', PORT: '5000', MONGODB_URI: 'mongodb://127.0.0.1:27017/vocle_ci', API_BASE_URL: 'http://127.0.0.1:5000', JWT_SECRET: 'ci-test-only-jwt-secret-not-for-production-0000000000000001', JWT_REFRESH_SECRET: 'ci-test-only-refresh-secret-not-for-production-000000000002', RUNNER_TEMP: '/output', VOCLE_MEDIA_NETWORK_NONE: 'true', OTP_BYPASS: 'true' };
process.env.MONGOMS_DOWNLOAD_DIR = '/output/mongo-binaries';
process.env.MONGOMS_RUNTIME_DOWNLOAD = 'false';
let mongo, app;
const attempts = [];
try {
  mongo = await MongoMemoryServer.create({ instance: { ip: '127.0.0.1', port: 27017, args: ['--setParameter', 'ttlMonitorEnabled=false'] } });
  for (const suite of ['security-media', 'security-data']) {
    attempts.push(await run(process.execPath, [join(backend, 'scripts', suite, 'run.js')], { cwd: backend, env, timeout: 15 * 60 * 1000, log: '/output/' + suite + '.log' }));
  }
  // Exact fixture/auth/discovery sequence from the existing hosted workflow.
  app = spawn(process.execPath, [join(backend, 'src/server.js')], { cwd: '/tmp', env, stdio: 'ignore' });
  const deadline = Date.now() + 30000;
  let ready = false;
  while (Date.now() < deadline) {
    try { if ((await fetch('http://127.0.0.1:5000/health')).ok) { ready = true; break; } } catch { /* startup */ }
    await new Promise(r => setTimeout(r, 200));
  }
  if (!ready) throw new Error('Discovery backend health timeout');
  for (const [script, args] of [['security-test-fixtures.js', []], ['security-test-fixtures.js', ['--verify']], ['security-test-auth-smoke.js', []], ['security-api-discovery.js', []], ['security-api-coverage-report.js', []]]) {
    const result = await run(process.execPath, [join(backend, 'scripts', script), ...args], { cwd: backend, env, timeout: 15 * 60 * 1000, log: '/output/' + script + (args.length ? '-verify' : '') + '.log' });
    attempts.push(result);
    if (result.code !== 0 && script !== 'security-api-discovery.js') throw new Error('Existing security prerequisite failed: ' + script);
  }
} finally {
  if (app && app.exitCode === null) { app.kill('SIGTERM'); await new Promise(r => app.once('exit', r)); }
  await mongo?.stop();
  await writeFile('/output/security-execution.json', JSON.stringify({ attempts: attempts.map(({ code, timedOut, error }) => ({ code, timedOut, error })), cleanup: 'PASS' }, null, 2));
}
if (!attempts.length || attempts.some(r => r.code !== 0 || r.timedOut)) process.exitCode = 1;
