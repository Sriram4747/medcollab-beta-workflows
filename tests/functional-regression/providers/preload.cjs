const { appendFileSync, mkdirSync } = require('node:fs');
const { createRequire } = require('node:module');
const { join } = require('node:path');

const backendRoot = process.env.VOCLE_BACKEND_DIR;
const inbox = process.env.VOCLE_PROVIDER_INBOX;
if (!backendRoot || !inbox) throw new Error('Provider fake requires isolated backend and inbox');
mkdirSync(inbox, { recursive: true });
const axios = createRequire(join(backendRoot, 'package.json'))('axios');
axios.post = async (url, body) => {
  if (url === 'https://control.msg91.com/api/v5/otp') {
    appendFileSync(join(inbox, 'msg91-inbox.ndjson'), `${JSON.stringify({ type: 'otp', mobile: String(body.mobile), otp: String(body.otp) })}\n`, { mode: 0o600 });
    return { status: 200, data: { type: 'success' } };
  }
  if (url === 'https://control.msg91.com/api/v5/widget/verifyAccessToken') return { status: 200, data: { type: 'success', mobile: '12025550105' } };
  throw new Error(`Provider fake blocked unexpected axios POST to ${new URL(url).origin}`);
};
