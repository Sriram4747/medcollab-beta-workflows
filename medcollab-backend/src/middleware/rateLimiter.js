/**
 * RATE LIMITER
 *
 * Prevents abuse of sensitive endpoints.
 *
 * Beta note (Sprint 15): hospital WiFi / mobile NAT often shares one public IP
 * across many doctors. Authenticated API traffic is keyed by JWT userId when
 * possible so group chat does not trip the IP bucket for everyone.
 */

const rateLimit = require('express-rate-limit');
const { ipKeyGenerator } = require('express-rate-limit');
const { respond } = require('../utils/apiResponse');

const rateLimitHandler = (req, res) => {
  respond.tooManyRequests(
    res,
    'Too many requests. Please wait and try again.'
  );
};

/**
 * Extract userId from Bearer JWT payload (rate-limit key only — not auth).
 * @param {import('express').Request} req
 * @returns {string|null}
 */
function bearerUserIdFromRequest(req) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) return null;

  const token = header.slice(7).trim();
  const parts = token.split('.');
  if (parts.length < 2) return null;

  try {
    const payload = JSON.parse(
      Buffer.from(parts[1], 'base64url').toString('utf8')
    );
    const id = payload.userId || payload.sub || payload.id;
    return id ? String(id) : null;
  } catch (_) {
    return null;
  }
}

/**
 * Per-user bucket for logged-in API calls; IP bucket for anonymous traffic.
 * @param {import('express').Request} req
 */
function apiRateLimitKey(req) {
  const userId = bearerUserIdFromRequest(req);
  if (userId) return `user:${userId}`;
  return ipKeyGenerator(req);
}

/**
 * Global limiter — applied to all /api routes.
 * Default: 600 / 15 min per authenticated user, shared IP bucket for anon.
 */
const globalLimiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000,
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 600,
  standardHeaders: true,
  legacyHeaders: false,
  handler: rateLimitHandler,
  keyGenerator: apiRateLimitKey,
  skip: (req) => process.env.NODE_ENV === 'test',
});

const otpLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: parseInt(process.env.OTP_RATE_LIMIT_MAX) || 5,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    respond.tooManyRequests(
      res,
      'Too many OTP requests. Please wait 15 minutes before trying again.'
    );
  },
  keyGenerator: (req) => {
    const phone = req.body?.phone || 'unknown';
    return `${ipKeyGenerator(req)}-${phone}`;
  },
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  handler: rateLimitHandler,
});

const uploadLimiter = rateLimit({
  windowMs: 60 * 60 * 1000,
  max: 30,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    respond.tooManyRequests(res, 'Upload limit reached. Try again in an hour.');
  },
  keyGenerator: (req) => {
    return req.user?._id?.toString() || ipKeyGenerator(req);
  },
});

module.exports = {
  globalLimiter,
  otpLimiter,
  authLimiter,
  uploadLimiter,
  bearerUserIdFromRequest,
  apiRateLimitKey,
};
