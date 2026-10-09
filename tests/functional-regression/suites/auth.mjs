import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';
import { capturedOtp } from '../src/fixtures.mjs';

await runModule('auth', [{
  id: 'FR-AUTH-01', module: 'AUTH',
  run: async ({ request, db, inbox }) => {
    const invalidPhones = [undefined, '12025550106', '+123456', '+1234567890123456'];
    for (const phone of invalidPhones) {
      const body = phone === undefined ? {} : { phone };
      const result = await request('/api/auth/request-otp', { method: 'POST', body, expectedStatus: 400 });
      assert.equal(result.payload.success, false);
    }
    const valid = ['+1234567', '+123456789012345'];
    for (const phone of valid) {
      const result = await request('/api/auth/request-otp', { method: 'POST', body: { phone } });
      assert.equal(result.payload.success, true);
    }
    const invalidCodes = [undefined, '12345', '1234567', 'abcdef'];
    for (const otp of invalidCodes) {
      const body = otp === undefined ? { phone: valid[0] } : { phone: valid[0], otp };
      const result = await request('/api/auth/verify-otp', { method: 'POST', body, expectedStatus: 400 });
      assert.equal(result.payload.success, false);
    }
    await db(async (connection) => {
      const count = await connection.collection('users').countDocuments({ phone: { $in: valid } });
      assert.equal(count, 0, 'Validation boundary requests must not create sessions or users');
    });
    const acceptedCode = await capturedOtp(inbox, valid[0]);
    const verified = await request('/api/auth/verify-otp', { method: 'POST', body: { phone: valid[0], otp: acceptedCode } });
    assert.equal(verified.data.isNewUser, true);
    assert.ok(verified.data.accessToken && verified.data.refreshToken);
    await db(async (connection) => {
      const users = await connection.collection('users').find({ phone: valid[0] }).toArray();
      assert.equal(users.length, 1);
      assert.equal(String(users[0]._id), verified.data.user._id);
    });
  },
}]);
