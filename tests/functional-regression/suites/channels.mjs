import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';

await runModule('channels', [{
  id: 'FR-CH-01', module: 'CH',
  run: async ({ identity, request, db }) => {
    const a = await identity('A');
    const space = (await request('/api/spaces', { method: 'POST', token: a.token, body: { name: 'Synthetic Channel Boundaries', type: 'department' }, expectedStatus: 201 })).data.space;
    const valid = [{ name: 'x', description: 'D'.repeat(200) }, { name: 'n'.repeat(80), description: '' }];
    const createdIds = [];
    for (const body of valid) {
      const made = await request(`/api/spaces/${space._id}/channels`, { method: 'POST', token: a.token, body, expectedStatus: 201 });
      assert.equal(made.data.channel.name, body.name);
      createdIds.push(made.data.channel._id);
    }
    for (const body of [{ name: 'n'.repeat(81) }, { name: 'Upper' }, { name: 'has space' }, { name: 'valid', description: 'D'.repeat(201) }]) {
      const rejected = await request(`/api/spaces/${space._id}/channels`, { method: 'POST', token: a.token, body, expectedStatus: 400 });
      assert.equal(rejected.payload.success, false);
    }
    const list = await request(`/api/spaces/${space._id}/channels`, { token: a.token });
    for (const id of createdIds) assert.equal(list.data.channels.filter((item) => item._id === id).length, 1);
    await db(async (connection) => {
      const channels = await connection.collection('channels').find({ spaceId: new connection.base.Types.ObjectId(space._id) }).toArray();
      assert.equal(channels.length, 5, 'Rejected creates must not persist partial channels');
      assert.deepEqual(new Set(channels.filter((item) => createdIds.includes(String(item._id))).map((item) => item.name)), new Set(valid.map((item) => item.name)));
    });
  },
}, {
  id: 'FR-CH-03', module: 'CH',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), b = await identity('B');
    const createdSpace = await request('/api/spaces', { method: 'POST', token: a.token, body: { name: 'Synthetic Channel Rules', type: 'department' }, expectedStatus: 201 });
    const space = createdSpace.data.space;
    await request('/api/spaces/join', { method: 'POST', token: b.token, body: { inviteCode: space.inviteCode } });
    const made = await request(`/api/spaces/${space._id}/channels`, { method: 'POST', token: a.token, body: { name: 'announcements' }, expectedStatus: 201 });
    const channelId = made.data.channel._id;
    await request(`/api/channels/${channelId}`, { method: 'PUT', token: a.token, body: { onlyAdminsCanPost: true } });
    const body = { content: { text: 'synthetic announcement' } };
    const rejected = await request(`/api/channels/${channelId}/messages`, { method: 'POST', token: b.token, body, expectedStatus: 403 });
    assert.equal(rejected.payload.success, false);
    const adminPost = await request(`/api/channels/${channelId}/messages`, { method: 'POST', token: a.token, body, expectedStatus: 201 });
    assert.ok(adminPost.data.message._id);
    await request(`/api/channels/${channelId}`, { method: 'PUT', token: a.token, body: { onlyAdminsCanPost: false } });
    const memberPost = await request(`/api/channels/${channelId}/messages`, { method: 'POST', token: b.token, body: { content: { text: 'synthetic member post' } }, expectedStatus: 201 });
    const detail = await request(`/api/channels/${channelId}`, { token: b.token });
    assert.equal(detail.data.channel.onlyAdminsCanPost, false);
    await db(async (connection) => {
      const messages = await connection.collection('messages').find({ channelId: new connection.base.Types.ObjectId(channelId) }).toArray();
      assert.deepEqual(new Set(messages.map((item) => String(item._id))), new Set([adminPost.data.message._id, memberPost.data.message._id]));
      const channel = await connection.collection('channels').findOne({ _id: new connection.base.Types.ObjectId(channelId) });
      assert.equal(channel.onlyAdminsCanPost, false);
      assert.equal(String(channel.lastMessage.messageId), memberPost.data.message._id);
    });
  },
}]);
