import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';

await runModule('conversations', [{
  id: 'FR-DM-01', module: 'DM',
  prerequisiteSeed: 'Accepted A/B request inserted directly for pair-delegation branch; no accept endpoint behavior credited',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), b = await identity('B'), c = await identity('C');
    const space = (await request('/api/spaces', { method: 'POST', token: a.token, body: { name: 'Synthetic Group Alias', type: 'department' }, expectedStatus: 201 })).data.space;
    for (const person of [b, c]) await request('/api/spaces/join', { method: 'POST', token: person.token, body: { inviteCode: space.inviteCode } });
    const first = await request('/api/channels/dm/group', { method: 'POST', token: a.token, body: { userIds: [c.userId, b.userId, c.userId, a.userId] } });
    const groupId = first.data.channel._id;
    const reopened = await request('/api/channels/group-dm', { method: 'POST', token: a.token, body: { userIds: [b.userId, c.userId] } });
    assert.equal(reopened.data.channel._id, groupId);
    assert.deepEqual(new Set(reopened.data.channel.members.map((member) => member._id || member)), new Set([a.userId, b.userId, c.userId]));
    const selfOnly = await request('/api/channels/dm/group', { method: 'POST', token: a.token, body: { userIds: [a.userId] }, expectedStatus: 400 });
    assert.equal(selfOnly.payload.success, false);
    await db(async (connection) => {
      const collection = connection.collection('messagerequests');
      await collection.insertOne({ fromUserId: new connection.base.Types.ObjectId(a.userId), toUserId: new connection.base.Types.ObjectId(b.userId), status: 'accepted', createdAt: new Date(), updatedAt: new Date() });
    });
    const pair = await request('/api/channels/dm/group', { method: 'POST', token: a.token, body: { userIds: [b.userId] } });
    const direct = await request('/api/channels/dm', { method: 'POST', token: a.token, body: { userId: b.userId } });
    assert.equal(pair.data.channel._id, direct.data.channel._id);
    await db(async (connection) => {
      const groups = await connection.collection('channels').find({ spaceId: null, members: new connection.base.Types.ObjectId(a.userId) }).toArray();
      assert.equal(groups.filter((item) => item.members.length === 3).length, 1);
      assert.equal(groups.filter((item) => item.members.length === 2).length, 1);
    });
  },
}, {
  id: 'FR-DM-02', module: 'DM', timeoutMs: 60000,
  run: async ({ identity, request, db }) => {
    const a = await identity('A');
    const space = (await request('/api/spaces', { method: 'POST', token: a.token, body: { name: 'Synthetic Needl Boundary', type: 'department' }, expectedStatus: 201 })).data.space;
    const others = [];
    for (const label of ['B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']) {
      const person = await identity(label);
      await request('/api/spaces/join', { method: 'POST', token: person.token, body: { inviteCode: space.inviteCode } });
      others.push(person);
    }
    const accepted = await request('/api/channels/dm/group', { method: 'POST', token: a.token, body: { userIds: others.slice(0, 8).map((person) => person.userId) } });
    const groupId = accepted.data.channel._id;
    assert.ok(groupId);
    const reread = await request(`/api/channels/${groupId}`, { token: a.token });
    assert.deepEqual(new Set(reread.data.channel.members.map((member) => member._id || member)), new Set([a.userId, ...others.slice(0, 8).map((person) => person.userId)]));
    const rejected = await request('/api/channels/dm/group', { method: 'POST', token: a.token, body: { userIds: others.map((person) => person.userId) }, expectedStatus: 400 });
    assert.equal(rejected.payload.success, false);
    await db(async (connection) => {
      const groups = await connection.collection('channels').find({ spaceId: null, members: new connection.base.Types.ObjectId(a.userId) }).toArray();
      assert.equal(groups.filter((item) => item.members.length === 9).length, 1);
      assert.equal(groups.filter((item) => item.members.length === 10).length, 0, 'Rejected 10-person group must not create a partial conversation');
      assert.equal(String(groups.find((item) => item.members.length === 9)._id), groupId);
    });
  },
}]);
