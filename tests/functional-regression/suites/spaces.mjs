import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';

await runModule('spaces', [{
  id: 'FR-SPC-01', module: 'SPC',
  run: async ({ identity, request, db }) => {
    const a = await identity('A');
    const valid = [
      { name: 'AB', type: 'department', description: 'D'.repeat(300) },
      { name: 'S'.repeat(100), type: 'department', description: '' },
    ];
    const createdIds = [];
    for (const body of valid) {
      const created = await request('/api/spaces', { method: 'POST', token: a.token, body, expectedStatus: 201 });
      assert.equal(created.data.space.name, body.name);
      createdIds.push(created.data.space._id);
      const detail = await request(`/api/spaces/${created.data.space._id}`, { token: a.token });
      assert.equal(detail.data.space.name, body.name);
      assert.equal(detail.data.space.description, body.description);
      assert.deepEqual(new Set(detail.data.space.channels.map((item) => item.name)), new Set(['general', 'emergency', 'academics']));
    }
    const invalid = [
      { name: 'A', type: 'department' },
      { name: 'N'.repeat(101), type: 'department' },
      { name: 'Valid', type: 'department', description: 'D'.repeat(301) },
      { name: 'Valid', type: 'fictional-type' },
    ];
    for (const body of invalid) {
      const rejected = await request('/api/spaces', { method: 'POST', token: a.token, body, expectedStatus: 400 });
      assert.equal(rejected.payload.success, false);
    }
    await db(async (connection) => {
      const spaces = await connection.collection('spaces').find({ createdBy: { $exists: true } }).toArray();
      assert.deepEqual(new Set(spaces.map((item) => String(item._id))), new Set(createdIds));
      const channels = await connection.collection('channels').countDocuments({ spaceId: { $in: spaces.map((item) => item._id) } });
      assert.equal(channels, 6, 'Rejected creates must leave no partial spaces or channels');
    });
  },
}]);
