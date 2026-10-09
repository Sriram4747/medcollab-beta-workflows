import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';

await runModule('requests', [{
  id: 'FR-REQ-02', module: 'REQ',
  prerequisiteSeed: 'Accepted request inserted as component prerequisite; no accept endpoint behavior credited',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), d = await identity('D'), e = await identity('E');
    let seededId;
    await db(async (connection) => {
      const fromUserId = new connection.base.Types.ObjectId(a.userId);
      const toUserId = new connection.base.Types.ObjectId(d.userId);
      const seeded = await connection.collection('messagerequests').insertOne({ fromUserId, toUserId, status: 'accepted', introMessage: 'synthetic prerequisite', createdAt: new Date(), updatedAt: new Date() });
      seededId = String(seeded.insertedId);
    });
    const pendingBefore = await Promise.all([a, d, e].map((person) => request('/api/message-requests/pending-count', { token: person.token })));
    assert.deepEqual(pendingBefore.map((item) => item.data.count), [0, 0, 0]);
    const boundaries = [
      [{ toUserId: a.userId }, 400],
      [{ toUserId: '000000000000000000000001' }, 404],
      [{ toUserId: d.userId }, 400],
      [{ toUserId: e.userId }, 403],
    ];
    for (const [body, status] of boundaries) {
      const denied = await request('/api/message-requests', { method: 'POST', token: a.token, body, expectedStatus: status });
      assert.equal(denied.payload.success, false);
    }
    const pendingAfter = await Promise.all([a, d, e].map((person) => request('/api/message-requests/pending-count', { token: person.token })));
    assert.deepEqual(pendingAfter.map((item) => item.data.count), [0, 0, 0]);
    await db(async (connection) => {
      const records = await connection.collection('messagerequests').find({}).toArray();
      assert.equal(records.length, 1);
      assert.equal(String(records[0]._id), seededId);
      assert.equal(records[0].status, 'accepted');
      const notifications = await connection.collection('notifications').countDocuments({ userId: { $in: [a, d, e].map((person) => new connection.base.Types.ObjectId(person.userId)) } });
      assert.equal(notifications, 0);
    });
  },
}]);
