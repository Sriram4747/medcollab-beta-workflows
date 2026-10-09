import assert from 'node:assert/strict';
import { runModule } from '../src/module-runner.mjs';
import { DecisionPending } from '../src/runner.mjs';

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
}, {
  id: 'FR-SPC-02', module: 'SPC',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), b = await identity('B'), c = await identity('C');
    const space = (await request('/api/spaces', { method: 'POST', token: a.token, body: { name: 'Synthetic Invite Rotation', type: 'department' }, expectedStatus: 201 })).data.space;
    const lower = space.inviteCode.toLowerCase();
    const preview = await request(`/api/spaces/invite/${lower}`, { token: b.token });
    assert.equal(preview.data.invite.inviteCode, space.inviteCode);
    assert.equal(preview.data.invite.alreadyMember, false);
    await request('/api/spaces/join', { method: 'POST', token: b.token, body: { inviteCode: lower } });
    const after = await request(`/api/spaces/invite/${lower}`, { token: b.token });
    assert.equal(after.data.invite.alreadyMember, true);
    const rotated = await request(`/api/spaces/${space._id}/invite`, { method: 'POST', token: a.token });
    assert.notEqual(rotated.data.inviteCode, space.inviteCode);
    await request(`/api/spaces/invite/${lower}`, { token: c.token, expectedStatus: 404 });
    const newPreview = await request(`/api/spaces/invite/${rotated.data.inviteCode.toLowerCase()}`, { token: c.token });
    assert.equal(newPreview.data.invite.inviteCode, rotated.data.inviteCode);
    await request('/api/spaces/join', { method: 'POST', token: c.token, body: { inviteCode: rotated.data.inviteCode.toLowerCase() } });
    await db(async (connection) => {
      const stored = await connection.collection('spaces').findOne({ _id: new connection.base.Types.ObjectId(space._id) });
      assert.equal(stored.inviteCode, rotated.data.inviteCode);
      assert.deepEqual(new Set(stored.members.map((item) => String(item.userId))), new Set([a.userId, b.userId, c.userId]));
    });
  },
}, {
  id: 'FR-SPC-03', module: 'SPC',
  run: async ({ identity, request, db }) => {
    const a = await identity('A'), b = await identity('B');
    const created = await request('/api/spaces', { method: 'POST', token: a.token, body: { name: 'Synthetic Pending Approval', type: 'department' }, expectedStatus: 201 });
    const space = created.data.space;
    const updated = await request(`/api/spaces/${space._id}`, { method: 'PUT', token: a.token, body: { settings: { requireApproval: true } } });
    assert.equal(updated.data.space.settings.requireApproval, true);
    for (let attempt = 0; attempt < 2; attempt++) {
      const joined = await request('/api/spaces/join', { method: 'POST', token: b.token, body: { inviteCode: space.inviteCode } });
      assert.match(joined.payload.message, /waiting for admin approval/i);
    }
    const list = await request('/api/spaces', { token: b.token });
    assert.ok(!list.data.spaces.some((item) => item._id === space._id));
    await request(`/api/spaces/${space._id}`, { token: b.token, expectedStatus: 403 });
    await db(async (connection) => {
      const stored = await connection.collection('spaces').findOne({ _id: new connection.base.Types.ObjectId(space._id) });
      assert.equal(stored.pendingRequests.length, 1);
      assert.equal(String(stored.pendingRequests[0].userId), b.userId);
      assert.ok(!stored.members.some((member) => String(member.userId) === b.userId));
    });
    throw new DecisionPending('Q14: pending-join client state and approval completion need product decision', [
      'requireApproval persisted', 'repeat join created one pending request', 'requester has no membership or channel detail access',
    ]);
  },
}]);
