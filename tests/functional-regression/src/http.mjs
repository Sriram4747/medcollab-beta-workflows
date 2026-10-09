export class HttpContractError extends Error { constructor(message, detail) { super(message); this.name = 'HttpContractError'; this.detail = detail; } }

export function createHttp(origin) {
  const parsedOrigin = new URL(origin);
  if (parsedOrigin.protocol !== 'http:' || !['127.0.0.1', 'localhost'].includes(parsedOrigin.hostname)) throw new Error('HTTP origin must be loopback');
  return async function request(path, { method = 'GET', token, body, expectedStatus = 200, timeoutMs = 10000 } = {}) {
    const url = new URL(path, parsedOrigin);
    if (url.origin !== parsedOrigin.origin) throw new Error('Cross-origin request rejected');
    const response = await fetch(url, {
      method, redirect: 'error', signal: AbortSignal.timeout(timeoutMs),
      headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}), ...(body === undefined ? {} : { 'Content-Type': 'application/json' }) },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    const payload = await response.json().catch(() => null);
    if (response.status !== expectedStatus) throw new HttpContractError(`${method} ${url.pathname} expected ${expectedStatus}, got ${response.status}`, { method, path: url.pathname, expectedStatus, status: response.status, payload });
    return { status: response.status, data: payload?.data, payload };
  };
}
