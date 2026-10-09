import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';

await runModule('discovery', [{
  id: 'FR-DISC-02', module: 'DISC',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), b = await identity('B');
    for (const variant of ['+12025550102', '+1 (202) 555-0102', '12025550102']) {
      const result = await request(`/api/users/lookup?phone=${encodeURIComponent(variant)}`, { token: a.token });
      assert.equal(result.data.user._id, b.userId);
    }
    for (const malformed of ['abc', '123']) {
      const result = await request(`/api/users/lookup?phone=${encodeURIComponent(malformed)}`, { token: a.token, expectedStatus: 400 });
      assert.equal(result.payload.success, false);
    }
    const absent = await request(`/api/users/lookup?phone=${encodeURIComponent('+12025550999')}`, { token: a.token, expectedStatus: 404 });
    assert.equal(absent.payload.success, false);
    await db(async (connection) => {
      const users = await connection.collection('users').find({ phone: b.phone }).toArray();
      assert.equal(users.length, 1);
      assert.equal(String(users[0]._id), b.userId);
    });
  },
}]);
