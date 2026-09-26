'use strict';
module.exports = ({ add, ids }) => {
  const options = { module: 'Extended API', sources: ['src/features/channels/channel.controller.js', 'src/features/notifications/notification.controller.js'], context: 'Reset synthetic owner A, member B, foreign-space C and recipient-scoped notifications.' };
  const register = (name, actor, method, endpoint, statuses, body, extra = {}) => add(name, actor, method, endpoint, statuses, body, { ...options, ...extra });
  for (const actor of ['A', 'B', 'C', 'anonymous']) {
    const status = actor === 'A' ? 200 : actor === 'anonymous' ? 401 : 403;
    register('channel update admin boundary', actor, 'PUT', `/api/channels/${ids.channel}`, [status], { description: 'Controlled update', spaceId: ids.otherSpace, createdBy: ':C' }, {
      check: status === 200 ? async (_, c) => { const d = await c.models.Channel.findById(ids.channel); return d.description === 'Controlled update' && String(d.spaceId) === ids.space && String(d.createdBy) === String(c.users.A._id); } : undefined,
    });
    register('channel archive admin boundary', actor, 'DELETE', `/api/channels/${ids.channel}`, [status], undefined, {
      check: status === 200 ? async (_, c) => (await c.models.Channel.findById(ids.channel)).isArchived && await c.models.Message.countDocuments({ channelId: ids.channel }) === 2 : undefined,
    });
    register('channel creation membership and ownership', actor, 'POST', `/api/spaces/${ids.space}/channels`, [actor === 'anonymous' ? 401 : actor === 'C' ? 403 : 201], { name: 'controlled-private', isPrivate: true, createdBy: ':C', members: [':C'], spaceId: ids.otherSpace }, {
      check: ['A', 'B'].includes(actor) ? async (b, c) => { const d = await c.models.Channel.findById(b.data?.channel?._id); return !!d && String(d.spaceId) === ids.space && String(d.createdBy) === String(c.users[actor]._id) && d.members.length === 1 && String(d.members[0]) === String(c.users[actor]._id); } : undefined,
    });
  }
  const privatePrepare = async c => c.models.Channel.findByIdAndUpdate(ids.channel, { isPrivate: true, members: [c.users.A._id] });
  for (const suffix of ['', '/members', '/messages']) register('private group excluded member read ' + suffix, 'B', 'GET', `/api/channels/${ids.channel}${suffix}`, [403], undefined, { prepare: privatePrepare });
  for (const threadId of [ids.otherMessage, ids.dmOtherMessage]) register('direct body foreign thread binding ' + threadId, 'A', 'POST', `/api/channels/${ids.channel}/messages`, [400, 403, 404], { content: { text: 'Cross-context canary' }, threadId }, {
    module: 'Cross-module', category: 'foreign-resource', check: async (b, c) => {
      const child = b.data?.message?._id && await c.models.Message.findById(b.data.message._id).lean();
      const parent = await c.models.Message.findById(threadId).lean();
      c.evidence.foreignBindingPersisted = !!child && String(child.channelId) === ids.channel && String(child.threadId) === threadId && String(parent.channelId) !== ids.channel;
      c.evidence.foreignParentReplyCount = parent.replyCount;
      return !c.evidence.foreignBindingPersisted && parent.replyCount === 0;
    },
  });
  for (const variant of ['expired', 'wrong-key', 'inactive', 'refresh']) register('REST authentication ' + variant, 'A', 'GET', '/api/users/me', [401], undefined, {
    category: 'authentication-negative', run: c => {
      const jwt = require('jsonwebtoken');
      const key = variant === 'wrong-key' ? 'disposable-wrong-key' : variant === 'refresh' ? process.env.JWT_REFRESH_SECRET : process.env.JWT_SECRET;
      const token = jwt.sign({ userId: String(c.users[variant === 'inactive' ? 'I' : 'A']._id) }, key, { expiresIn: variant === 'expired' ? -1 : 60 });
      return c.http('A', 'GET', '/api/users/me', undefined, 'Bearer ' + token);
    },
  });
  const prep = async c => {
    const type = c.models.Notification.schema.path('type').enumValues[0];
    const docs = await c.models.Notification.create(['A', 'B'].map(actor => ({ userId: c.users[actor]._id, actorId: c.users.C._id, type, body: 'Synthetic notification', referenceId: ids.messageA, referenceType: 'Message', metadata: { channelId: ids.channel }, read: false })));
    c.noteA = String(docs[0]._id); c.noteB = String(docs[1]._id);
  };
  for (const op of ['read', 'unread', 'delete']) for (const actor of ['A', 'B', 'anonymous']) register('notification ' + op + ' recipient boundary', actor, op === 'delete' ? 'DELETE' : 'PUT', c => `/api/notifications/${c.noteA}${op === 'delete' ? '' : '/' + op}`, [actor === 'A' ? 200 : actor === 'anonymous' ? 401 : 404], undefined, {
    prepare: async c => { await prep(c); if (op === 'unread') await c.models.Notification.findByIdAndUpdate(c.noteA, { read: true }); },
    check: actor === 'A' ? async (_, c) => { const d = await c.models.Notification.findById(c.noteA); return (op === 'delete' ? !d : d.read === (op === 'read')) && !(await c.models.Notification.findById(c.noteB)).read; } : undefined,
  });
  register('notification inbox scoped to recipient', 'A', 'GET', '/api/notifications', [200], undefined, { prepare: prep, check: (b, c) => b.data?.notifications?.length === 1 && String(b.data.notifications[0]._id) === c.noteA });
  register('notification count scoped to recipient', 'A', 'GET', '/api/notifications/unread-count', [200], undefined, { prepare: prep, check: b => b.data?.count === 1 });
  for (const endpoint of ['/api/notifications/read-all', `/api/notifications/read-by-channel/${ids.channel}`, `/api/notifications/read-by-channel/${ids.otherChannel}`]) register('notification bulk recipient binding ' + endpoint, 'A', 'PUT', endpoint, [200], undefined, {
    prepare: prep, check: async (b, c) => b.data?.modifiedCount === (endpoint.endsWith(ids.otherChannel) ? 0 : 1) && !(await c.models.Notification.findById(c.noteB)).read,
  });
};
