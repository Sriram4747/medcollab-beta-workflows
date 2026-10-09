const { appendFileSync, mkdirSync, readFileSync } = require('node:fs');
const { createRequire } = require('node:module');
const { join } = require('node:path');

const backendRoot = process.env.VOCLE_BACKEND_DIR;
const inbox = process.env.VOCLE_PROVIDER_INBOX;
if (!backendRoot || !inbox) throw new Error('Provider fake requires isolated backend and inbox');
mkdirSync(inbox, { recursive: true });
const axios = createRequire(join(backendRoot, 'package.json'))('axios');
axios.post = async (url, body) => {
  if (url === 'https://control.msg91.com/api/v5/otp') {
    let mode = 'success';
    try { mode = JSON.parse(readFileSync(join(inbox, 'msg91-mode.json'), 'utf8')).mode; }
    catch (error) { if (error.code !== 'ENOENT') throw error; }
    if (mode === 'timeout') throw new Error('Synthetic MSG91 provider timeout');
    if (mode === 'reject') return { status: 400, data: { type: 'error', message: 'Synthetic MSG91 rejection' } };
    if (mode !== 'success') throw new Error(`Unknown synthetic MSG91 mode ${mode}`);
    appendFileSync(join(inbox, 'msg91-inbox.ndjson'), `${JSON.stringify({ type: 'otp', mobile: String(body.mobile), otp: String(body.otp) })}\n`, { mode: 0o600 });
    return { status: 200, data: { type: 'success' } };
  }
  if (url === 'https://control.msg91.com/api/v5/widget/verifyAccessToken') {
    const token = typeof body === 'string' ? new URLSearchParams(body).get('access-token') : body['access-token'];
    appendFileSync(join(inbox, 'widget-inbox.ndjson'), `${JSON.stringify({ type: 'widget-verify', token })}\n`, { mode: 0o600 });
    if (token === 'synthetic-provider-failure') return { status: 503, data: { type: 'error', message: 'Synthetic provider unavailable' } };
    if (token === 'synthetic-invalid') return { status: 400, data: { type: 'error', message: 'Synthetic invalid token' } };
    return { status: 200, data: { type: 'success', mobile: '12025550105' } };
  }
  throw new Error(`Provider fake blocked unexpected axios POST to ${new URL(url).origin}`);
};
