import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';

await runModule('conversations', [{
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
      assert.equal(groups.length, 1, 'Rejected 10-person group must not create a partial conversation');
      assert.equal(groups[0].members.length, 9);
      assert.equal(String(groups[0]._id), groupId);
    });
  },
}]);
