import { latestOtp } from './fake-inbox.js';
import { request, expectSuccess } from './http.js';

export const fixtureUsers = Object.freeze([
  ['A', '+12025550101'], ['B', '+12025550102'], ['C', '+12025550103'], ['D', '+12025550104'], ['E', '+12025550105'],
]);

export async function createFixtureUsers() {
  const identities = {};
  for (const [label, phone] of fixtureUsers) {
    await request('/api/auth/request-otp', { method: 'POST', body: { phone } });
    const auth = expectSuccess(await request('/api/auth/verify-otp', { method: 'POST', body: { phone, otp: await latestOtp(phone) } }), `authenticate fixture ${label}`);
    const profile = expectSuccess(await request('/api/users/me', {
      method: 'PUT', token: auth.accessToken,
      body: { name: `Dr Sanity ${label}`, institution: 'Vocle Sanity Institute', speciality: 'Sanity Medicine' },
    }), `onboard fixture ${label}`);
    identities[label] = { phone, token: auth.accessToken, refreshToken: auth.refreshToken, userId: profile.user._id };
  }
  return identities;
}
