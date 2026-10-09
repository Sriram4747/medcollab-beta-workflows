import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';

await runModule('requests', [{
  id: 'FR-REQ-01', module: 'REQ',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), d = await identity('D');
    await request('/api/users/me', { method: 'PUT', token: d.token, body: { notifications: { allowMessageRequestsFromAnyone: true } } });
    await request('/api/users/me', { method: 'PUT', token: a.token, body: { notifications: { allowMessageRequestsFromAnyone: true } } });
    const first = await request('/api/message-requests', { method: 'POST', token: a.token, body: { toUserId: d.userId, introMessage: 'synthetic reverse collision' }, expectedStatus: 201 });
    const id = first.data.request.id;
    const reverse = await request('/api/message-requests', { method: 'POST', token: d.token, body: { toUserId: a.userId } });
    assert.equal(reverse.data.request.id, id);
    assert.equal(reverse.data.action, 'accept_incoming');
    const sent = await request('/api/message-requests?direction=sent', { token: a.token });
    const received = await request('/api/message-requests?direction=received', { token: d.token });
    assert.equal(sent.data.requests.filter((item) => item.id === id).length, 1);
    assert.equal(received.data.requests.filter((item) => item.id === id).length, 1);
    assert.equal(received.data.requests.find((item) => item.id === id).direction, 'received');
    const count = await request('/api/message-requests/pending-count', { token: d.token });
    assert.equal(count.data.count, 1);
    await db(async (connection) => {
      const records = await connection.collection('messagerequests').find({ $or: [{ fromUserId: new connection.base.Types.ObjectId(a.userId), toUserId: new connection.base.Types.ObjectId(d.userId) }, { fromUserId: new connection.base.Types.ObjectId(d.userId), toUserId: new connection.base.Types.ObjectId(a.userId) }] }).toArray();
      assert.equal(records.length, 1);
      assert.equal(String(records[0]._id), id);
      assert.equal(records[0].status, 'pending');
    });
  },
}, {
  id: 'FR-REQ-02', module: 'REQ',
  prerequisiteSeed: 'Accepted request inserted as component prerequisite; no accept endpoint behavior credited',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), b = await identity('B'), e = await identity('E');
    const initialRecords = await db(async (connection) => connection.collection('messagerequests').countDocuments({}));
    let seededId;
    await db(async (connection) => {
      const fromUserId = new connection.base.Types.ObjectId(a.userId);
      const toUserId = new connection.base.Types.ObjectId(b.userId);
      const seeded = await connection.collection('messagerequests').insertOne({ fromUserId, toUserId, status: 'accepted', introMessage: 'synthetic prerequisite', createdAt: new Date(), updatedAt: new Date() });
      seededId = String(seeded.insertedId);
    });
    const pendingBefore = await Promise.all([a, b, e].map((person) => request('/api/message-requests/pending-count', { token: person.token })));
    const notificationCountBefore = await db(async (connection) => connection.collection('notifications').countDocuments({ userId: { $in: [a, b, e].map((person) => new connection.base.Types.ObjectId(person.userId)) } }));
    const boundaries = [
      [{ toUserId: a.userId }, 400],
      [{ toUserId: '000000000000000000000001' }, 404],
      [{ toUserId: b.userId }, 400],
      [{ toUserId: e.userId }, 403],
    ];
    for (const [body, status] of boundaries) {
      const denied = await request('/api/message-requests', { method: 'POST', token: a.token, body, expectedStatus: status });
      assert.equal(denied.payload.success, false);
    }
    const pendingAfter = await Promise.all([a, b, e].map((person) => request('/api/message-requests/pending-count', { token: person.token })));
    assert.deepEqual(pendingAfter.map((item) => item.data.count), pendingBefore.map((item) => item.data.count));
    await db(async (connection) => {
      const records = await connection.collection('messagerequests').find({}).toArray();
      assert.equal(records.length, initialRecords + 1);
      assert.equal(records.filter((item) => String(item._id) === seededId && item.status === 'accepted').length, 1);
      const notifications = await connection.collection('notifications').countDocuments({ userId: { $in: [a, b, e].map((person) => new connection.base.Types.ObjectId(person.userId)) } });
      assert.equal(notifications, notificationCountBefore);
    });
  },
}]);
