import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';

await runModule('discovery', [{
  id: 'FR-DISC-01', module: 'DISC',
  prerequisiteSeed: 'Accepted A/C request inserted directly to represent an existing peer relationship',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), b = await identity('B'), c = await identity('C'), d = await identity('D'), e = await identity('E');
    const space = (await request('/api/spaces', { method: 'POST', token: a.token, body: { name: 'Synthetic Discovery', type: 'department' }, expectedStatus: 201 })).data.space;
    await request('/api/spaces/join', { method: 'POST', token: b.token, body: { inviteCode: space.inviteCode } });
    await request('/api/users/me', { method: 'PUT', token: d.token, body: { notifications: { allowMessageRequestsFromAnyone: true } } });
    await db(async (connection) => connection.collection('messagerequests').insertOne({ fromUserId: new connection.base.Types.ObjectId(a.userId), toUserId: new connection.base.Types.ObjectId(c.userId), status: 'accepted', createdAt: new Date(), updatedAt: new Date() }));
    const lookup = async (person) => (await request(`/api/users/lookup?phone=${encodeURIComponent(person.phone)}`, { token: a.token })).data;
    const self = await lookup(a);
    assert.equal(self.isSelf, true);
    assert.equal(self.canMessage, true);
    assert.equal(self.canRequest, false);
    const shared = await lookup(b);
    assert.equal(shared.relationship, 'group_member');
    assert.equal(shared.sharesGroup, true);
    assert.equal(shared.canMessage, false);
    assert.equal(shared.canRequest, true);
    const accepted = await lookup(c);
    assert.equal(accepted.relationship, 'known');
    assert.equal(accepted.canMessage, true);
    assert.equal(accepted.canRequest, false);
    const optedIn = await lookup(d), optedOut = await lookup(e);
    assert.equal(optedIn.relationship, 'stranger');
    assert.equal(optedIn.canRequest, true);
    assert.equal(optedOut.relationship, 'stranger');
    assert.equal(optedOut.canRequest, false);
    await db(async (connection) => {
      const saved = await connection.collection('spaces').findOne({ _id: new connection.base.Types.ObjectId(space._id) });
      assert.deepEqual(new Set(saved.members.map((item) => String(item.userId))), new Set([a.userId, b.userId]));
    });
  },
}, {
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
