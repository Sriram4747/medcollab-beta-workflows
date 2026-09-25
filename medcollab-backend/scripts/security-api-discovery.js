#!/usr/bin/env node
'use strict';
// Real HTTP discovery tests. MongoDB is used only for setup and independent
// persistence checks, never as a substitute for the API action under test.
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const BASE = 'http://127.0.0.1:5000';
const URI = 'mongodb://127.0.0.1:27017/vocle_ci';
const source = (name) => `src/features/${name}/${name === 'spaces' ? 'space' : name === 'messages' ? 'message' : name === 'handoffs' ? 'handoff' : 'channel'}.controller.js`;
// Fixed, valid 24-character ObjectIds reserved solely for this disposable
// discovery world. Keeping them explicit prevents an accidental formatting
// change from making fixture setup fail before any HTTP security case runs.
const ids = {
  space: '7ec000000000000000000001',
  otherSpace: '7ec000000000000000000002',
  channel: '7ec000000000000000000003',
  otherChannel: '7ec000000000000000000004',
  messageA: '7ec000000000000000000005',
  messageB: '7ec000000000000000000006',
  otherMessage: '7ec000000000000000000007',
  handoff: '7ec000000000000000000008',
  dmAB: '7ec000000000000000000009',
  dmOther: '7ec00000000000000000000a',
  dmArchived: '7ec00000000000000000000b',
  dmMessageA: '7ec00000000000000000000c',
  dmMessageB: '7ec00000000000000000000d',
  dmOtherMessage: '7ec00000000000000000000e',
  requestPending: '7ec00000000000000000000f',
  requestDeclined: '7ec000000000000000000010',
  requestBlocked: '7ec000000000000000000011',
  requestAccepted: '7ec000000000000000000012',
  absentUser: '7ec000000000000000000998',
};
for (const [name, id] of Object.entries(ids)) assert.match(id, /^[a-f0-9]{24}$/, `Invalid scratch ObjectId for ${name}`);
const mp = `/api/channels/${ids.channel}/messages`;
const sp = `/api/spaces/${ids.space}`;
const hp = `/api/handoffs/${ids.handoff}`;
const cases = [];
function add(name, actor, method, endpoint, statuses, body, options = {}) {
  const endpointText = typeof endpoint === 'string' ? endpoint : '';
  cases.push({ name, actor, method, endpoint, statuses, body,
    category: 'identity-permutation', context: 'A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B',
    sources: [source(endpointText.includes('handoff') ? 'handoffs' : endpointText.includes('messages') ? 'messages' : 'spaces'), 'src/middleware/auth.js'],
    module: 'Baseline group, space, and handoff security',
    ...options });
}
for (const actor of ['A', 'B', 'C', 'anonymous']) {
  const member = actor === 'A' || actor === 'B';
  const denial = actor === 'anonymous' ? 401 : 403;
  for (const endpoint of [sp, `${sp}/members`, `${sp}/channels`, mp, hp, `${sp}/handoffs`]) {
    add(`read ${endpoint}`, actor, 'GET', endpoint, [member ? 200 : denial], undefined, {
      check: member && endpoint === mp ? (b) => b.data?.messages?.length === 2 : undefined,
    });
  }
  add('list only own spaces', actor, 'GET', '/api/spaces', [actor === 'anonymous' ? 401 : 200], undefined, {
    check: actor === 'anonymous' ? undefined : (b) => b.data?.spaces?.some(s => s._id === ids.space) === member,
  });
  add('update space admin boundary', actor, 'PUT', sp, [actor === 'A' ? 200 : denial], { description: 'Discovery update' });
  add('create message member boundary', actor, 'POST', mp, [member ? 201 : denial], { type: 'text', content: { text: 'Discovery create' } });
  for (const owner of ['A', 'B']) {
    add(`edit ${owner} message`, actor, 'PUT', `${mp}/${ids[`message${owner}`]}`, [actor === owner ? 200 : denial], { content: { text: 'Discovery edit' } }, {
      check: actor === owner ? async () => (await models.Message.findById(ids[`message${owner}`])).content.text === 'Discovery edit' : undefined,
    });
    add(`delete ${owner} message`, actor, 'DELETE', `${mp}/${ids[`message${owner}`]}`, [actor === owner || actor === 'A' ? 200 : denial], undefined, {
      check: actor === owner || actor === 'A' ? async () => (await models.Message.findById(ids[`message${owner}`])).isDeleted === true : undefined,
    });
  }
  add('edit submitted handoff', actor, 'PUT', hp, [actor === 'A' ? 400 : denial], { shiftSummary: 'Attempted edit' });
  add('delete submitted handoff', actor, 'DELETE', hp, [actor === 'A' ? 400 : denial]);
  add('acknowledge receiver only', actor, 'POST', `${hp}/acknowledge`, [actor === 'B' ? 200 : actor === 'anonymous' ? 401 : 400], { note: 'CI acknowledgement' }, {
    check: actor === 'B' ? async () => (await models.Handoff.findById(ids.handoff)).status === 'acknowledged' : undefined,
  });
  add('remove member admin boundary', actor, 'DELETE', `${sp}/members/:B`, [actor === 'A' ? 200 : denial], undefined, {
    check: actor === 'A' ? async () => !(await models.Space.findById(ids.space)).isMember(users.B._id) : undefined,
  });
  add('draft handoff create', actor, 'POST', '/api/handoffs', [member ? 201 : denial], 'handoff');
  for (const action of ['edit', 'delete', 'submit']) {
    add(`draft handoff ${action}`, actor, action === 'edit' ? 'PUT' : action === 'delete' ? 'DELETE' : 'POST', action === 'submit' ? `${hp}/submit` : hp,
      [actor === 'A' ? 200 : denial], action === 'edit' ? { shiftSummary: 'Draft update' } : undefined,
      { prepare: 'draft', context: 'Draft handoff A to B in AB space; only sender may edit/delete/submit' });
  }
}
for (const header of ['missing', 'Basic invalid', 'Bearer', 'Bearer invalid', 'bearer invalid', 'tampered']) {
  add(`authentication header ${header}`, 'anonymous', 'GET', '/api/users/me', [401], undefined, { category: 'authentication-negative', header, sources: ['src/middleware/auth.js:protect'] });
}
for (const owner of ['A', 'B']) {
  for (const action of ['thread', 'edit', 'delete', 'reply']) {
    add(`cross-channel ${action} by ${owner}`, owner, action === 'thread' ? 'GET' : action === 'edit' ? 'PUT' : action === 'delete' ? 'DELETE' : 'POST',
      `${mp}/${ids.otherMessage}${action === 'thread' || action === 'reply' ? `/${action}` : ''}`, [403, 404], action === 'edit' || action === 'reply' ? { type: 'text', content: { text: 'Cross-channel attempt' } } : undefined,
      { category: 'foreign-resource', context: 'C owns target message in C-only space; A/B can access URL channel only', sources: [source('messages'), 'src/utils/channelAccess.js:assertMessageInChannel'] });
  }
}
for (const field of ['channelId', 'spaceId', 'toUserId']) {
  add(`handoff foreign ${field}`, 'A', 'POST', '/api/handoffs', [400, 403, 404], 'handoff', { category: 'foreign-resource', foreignField: field, sources: [source('handoffs') + ':createHandoff'] });
}
add('acknowledgement replay', 'B', 'POST', `${hp}/acknowledge`, [400], {}, { category: 'replay', prepare: 'acknowledge' });
for (const [label, value, accepted] of [
  ['missing', undefined, false], ['null', null, false], ['empty', '', false],
  ['number', 42, false], ['object', {}, false], ['array', ['x'], false],
  ['minimum', 'x', true], ['below-max', 'x'.repeat(3999), true],
  ['at-max', 'x'.repeat(4000), true], ['above-max', 'x'.repeat(4001), false],
]) {
  for (const method of ['POST', 'PUT']) add(`message text ${label} ${method}`, 'A', method, method === 'POST' ? mp : `${mp}/${ids.messageA}`, [accepted ? method === 'POST' ? 201 : 200 : 400],
    { type: 'text', content: value === undefined ? {} : { text: value } }, { category: `schema-text-${label}`, sources: ['src/middleware/validate.js:validateSendMessage', 'src/features/messages/message.routes.js', 'src/features/messages/message.model.js:content.text'] });
}
for (const [field, value] of [['type', 'unknown'], ['priority', 'unknown'], ['threadId', 'invalid-id'], ['content', null], ['content', []]]) {
  add(`message invalid ${field}`, 'A', 'POST', mp, [400], { type: 'text', content: { text: 'CI' }, [field]: value }, { category: 'schema-type-enum', sources: ['src/middleware/validate.js:validateSendMessage', 'src/features/messages/message.model.js'] });
}
add('message ownership fields ignored', 'B', 'POST', mp, [201], { type: 'text', content: { text: 'CI' }, senderId: ':A', spaceId: ids.otherSpace, isDeleted: true }, {
  category: 'unexpected-ownership-fields', check: b => b.data?.message?.senderId?._id === String(users.B._id) && b.data?.message?.spaceId === ids.space && b.data?.message?.isDeleted === false,
});
for (const limit of [0, 1, 99, 100, 101]) add(`pagination boundary ${limit}`, 'A', 'GET', `${mp}?limit=${limit}`, [limit >= 1 && limit <= 100 ? 200 : 400], undefined, { category: 'pagination-boundary', sources: ['src/middleware/validate.js:validatePagination'] });
// VOCLE-137 previously used a 25-character ID: 400 was correct for that input.
// Keep the intended valid-but-absent case separate from malformed-ID cases.
const absentSpaceId = '7ec000000000000000000999';
assert.match(absentSpaceId, /^[a-f0-9]{24}$/);
assert.ok(!Object.values(ids).includes(absentSpaceId));
for (const [endpoint, expectedStatus] of [
  ['/api/spaces/not-an-id', 400],
  [`${mp}/not-an-id/thread`, 400],
  ['/api/handoffs/not-an-id', 400],
  [`/api/spaces/${absentSpaceId}`, 404],
]) {
  add('object id boundary', 'A', 'GET', endpoint, [expectedStatus], undefined, { category: 'object-id', sources: ['src/middleware/validate.js:validateMongoId', 'src/features/spaces/space.controller.js:getSpaceById'] });
}
for (const field of ['toUserId', 'shiftDate', 'shiftType']) {
  for (const variant of ['missing', 'null', 'invalid']) add(`handoff ${field} ${variant}`, 'A', 'POST', '/api/handoffs', [400], 'handoff', { category: 'handoff-required-enum', mutation: { field, variant }, sources: ['src/middleware/validate.js:validateCreateHandoff', 'src/features/handoffs/handoff.model.js'] });
}

require('./security/suites/direct-messages')({ add, ids });
require('./security/suites/message-requests')({ add, ids });

let mongoose, models, users;
const tokens = {};
const results = [];
let fatal = null;
let stage = 'safety preflight';
function safety() {
  assert.equal(process.env.NODE_ENV, 'test', 'Requires NODE_ENV=test');
  assert.equal(process.env.API_BASE_URL, BASE, 'Requires exact local API URL');
  assert.equal(process.env.MONGODB_URI, URI, 'Requires exact disposable database');
  assert.equal(process.env.JWT_SECRET, 'ci-test-only-jwt-secret-not-for-production-0000000000000001', 'Requires known disposable signing configuration');
  for (const key of ['CLOUDINARY_CLOUD_NAME', 'CLOUDINARY_API_KEY', 'CLOUDINARY_API_SECRET', 'MSG91_AUTH_KEY', 'MSG91_TEMPLATE_ID', 'FIREBASE_PROJECT_ID', 'FIREBASE_CLIENT_EMAIL', 'FIREBASE_PRIVATE_KEY']) assert.ok(!process.env[key], 'External credentials must be absent');
}
async function http(actor, method, endpoint, body, header) {
  assert.ok(endpoint.startsWith('/api/') || endpoint === '/health');
  const url = new URL(endpoint, BASE);
  assert.equal(url.origin, BASE);
  const headers = { 'Content-Type': 'application/json' };
  if (actor !== 'anonymous') headers.Authorization = `Bearer ${tokens[actor]}`;
  if (header && header !== 'missing') headers.Authorization = header === 'tampered' ? `Bearer ${tokens.A.slice(0, -8)}AAAAAAAA` : header;
  const response = await fetch(url, { method, headers, body: body === undefined ? undefined : JSON.stringify(body), redirect: 'error', signal: AbortSignal.timeout(10000) });
  const text = await response.text();
  let data;
  try { data = JSON.parse(text); } catch { data = null; }
  return { status: response.status, data };
}
async function health() {
  const r = await http('anonymous', 'GET', '/health');
  assert.ok(r.status === 200 && r.data?.database === 'connected' && r.data?.environment === 'test' && r.data?.firebase === false && r.data?.cloudinary === false, 'Local backend health/safety preflight failed');
}
async function reset() {
  // Exact scratch IDs plus direct/request resources created by fixture actors.
  // The fixture users exist only in the disposable local vocle_ci database.
  const fixtureUserIds = Object.values(users).map((user) => user._id);
  const directChannels = await models.Channel.find({ type: 'direct', createdBy: { $in: fixtureUserIds } }).select('_id').lean();
  const directChannelIds = directChannels.map((channel) => channel._id);
  await models.Message.deleteMany({ $or: [{ channelId: { $in: directChannelIds } }, { _id: { $in: Object.values(ids) } }, { spaceId: { $in: [ids.space, ids.otherSpace] } }] });
  await models.MessageRequest.deleteMany({ $or: [{ _id: { $in: Object.values(ids) } }, { fromUserId: { $in: fixtureUserIds } }, { toUserId: { $in: fixtureUserIds } }] });
  await models.Channel.deleteMany({ type: 'direct', createdBy: { $in: fixtureUserIds } });
  for (const model of Object.values(models).filter(m => m !== models.User)) await model.deleteMany({ $or: [{ _id: { $in: Object.values(ids) } }, { spaceId: { $in: [ids.space, ids.otherSpace] } }] });
  await models.Space.create([
    { _id: ids.space, name: 'Discovery AB', type: 'department', inviteCode: 'DSCABA', createdBy: users.A._id, members: [{ userId: users.A._id, role: 'owner' }, { userId: users.B._id, role: 'member' }] },
    { _id: ids.otherSpace, name: 'Discovery C', type: 'department', inviteCode: 'DSCCCA', createdBy: users.C._id, members: [{ userId: users.C._id, role: 'owner' }] },
  ]);
  await models.Channel.create([
    { _id: ids.channel, name: 'discovery-ab', spaceId: ids.space, createdBy: users.A._id },
    { _id: ids.otherChannel, name: 'discovery-c', spaceId: ids.otherSpace, createdBy: users.C._id },
    { _id: ids.dmAB, type: 'direct', spaceId: null, name: null, members: [users.A._id, users.B._id], createdBy: users.A._id },
    { _id: ids.dmOther, type: 'direct', spaceId: null, name: null, members: [users.D._id, users.E._id], createdBy: users.D._id },
    { _id: ids.dmArchived, type: 'direct', spaceId: null, name: null, members: [users.E._id, users.G._id], isArchived: true, createdBy: users.E._id },
  ]);
  await models.Message.create([
    ...['A', 'B', 'C'].map(actor => ({ _id: actor === 'C' ? ids.otherMessage : ids[`message${actor}`], channelId: actor === 'C' ? ids.otherChannel : ids.channel, spaceId: actor === 'C' ? ids.otherSpace : ids.space, senderId: users[actor]._id, content: { text: `Discovery ${actor}` } })),
    { _id: ids.dmMessageA, channelId: ids.dmAB, spaceId: null, senderId: users.A._id, content: { text: 'Direct discovery A' } },
    { _id: ids.dmMessageB, channelId: ids.dmAB, spaceId: null, senderId: users.B._id, content: { text: 'Direct discovery B' } },
    { _id: ids.dmOtherMessage, channelId: ids.dmOther, spaceId: null, senderId: users.D._id, content: { text: 'Foreign direct discovery D' } },
  ]);
  await models.MessageRequest.create([
    { _id: ids.requestPending, fromUserId: users.E._id, toUserId: users.F._id, status: 'pending', introMessage: 'Controlled pending request' },
    { _id: ids.requestDeclined, fromUserId: users.E._id, toUserId: users.G._id, status: 'declined', introMessage: 'Controlled declined request' },
    { _id: ids.requestBlocked, fromUserId: users.F._id, toUserId: users.G._id, status: 'blocked', introMessage: 'Controlled blocked request' },
    { _id: ids.requestAccepted, fromUserId: users.E._id, toUserId: users.H._id, status: 'accepted', introMessage: 'Controlled accepted request' },
  ]);
  await models.Handoff.create({ _id: ids.handoff, ...handoffBody(), fromUserId: users.A._id, status: 'submitted', submittedAt: new Date('2025-01-15') });
}
function handoffBody() {
  return { spaceId: ids.space, channelId: ids.channel, toUserId: String(users.B._id), shiftDate: '2025-01-15', shiftType: 'morning', patients: [{ bedNumber: 'CI', clinicalAlias: 'Synthetic only' }] };
}
async function snapshot() {
  const state = {};
  const fixtureUserIds = Object.values(users).map((user) => user._id);
  for (const [name, model] of Object.entries(models).filter(([n]) => n !== 'User')) {
    const query = name === 'Channel'
      ? { $or: [{ _id: { $in: Object.values(ids) } }, { spaceId: { $in: [ids.space, ids.otherSpace] } }, { type: 'direct', createdBy: { $in: fixtureUserIds } }] }
      : name === 'Message'
        ? { $or: [{ _id: { $in: Object.values(ids) } }, { spaceId: { $in: [ids.space, ids.otherSpace] } }, { senderId: { $in: fixtureUserIds }, spaceId: null }] }
        : name === 'MessageRequest'
          ? { $or: [{ _id: { $in: Object.values(ids) } }, { fromUserId: { $in: fixtureUserIds } }, { toUserId: { $in: fixtureUserIds } }] }
          : { $or: [{ _id: { $in: Object.values(ids) } }, { spaceId: { $in: [ids.space, ids.otherSpace] } }] };
    state[name] = await model.find(query).sort({ _id: 1 }).lean();
  }
  return JSON.stringify(state);
}
function actorLabel(actor) {
  return { A: 'User A (space owner/admin)', B: 'User B (normal space member)', C: 'User C (authenticated outsider)', D: 'User D (same-institution medical peer)', E: 'User E (unrelated controlled identity)', F: 'User F (unrelated controlled identity)', G: 'User G (unrelated controlled identity)', H: 'User H (unrelated controlled identity)', anonymous: 'Anonymous caller (unauthenticated)' }[actor];
}
function securityArea(category) {
  if (category === 'authentication-negative') return 'Authentication';
  if (category === 'foreign-resource') return 'Resource Isolation / IDOR';
  if (category === 'identity-permutation') return 'Authorization / Ownership';
  if (category === 'replay') return 'Authorization / Workflow Integrity';
  if (category.startsWith('direct-')) return category.includes('schema') ? 'Input Validation' : 'Direct-message Authorization';
  if (category.startsWith('message-request-')) return category.includes('schema') ? 'Input Validation' : 'Message-request Authorization';
  if (/schema|boundary|required|enum|object-id|pagination|ownership-fields/.test(category)) return 'Input Validation';
  return 'Authorization';
}
function mutationDescription(c) {
  if (c.header) return `Authorization header variant: ${c.header}.`;
  if (c.foreignField) return `Replaced ${c.foreignField} with a valid controlled resource or identity from another security context.`;
  if (c.mutation) return `${c.mutation.field} is ${c.mutation.variant}.`;
  if (c.category.startsWith('schema-text-')) return `Message text variant: ${c.category.slice('schema-text-'.length)}.`;
  if (c.category === 'schema-type-enum') return `Invalid message field variant: ${c.name.replace('message invalid ', '')}.`;
  if (c.category === 'pagination-boundary') return `Pagination limit: ${new URL(c.endpoint, BASE).searchParams.get('limit')}.`;
  if (c.category === 'object-id') return 'Malformed or non-existent object identifier.';
  if (c.category === 'unexpected-ownership-fields') return 'Sent client-controlled ownership and deletion fields that the API should ignore.';
  if (c.category === 'replay') return 'Repeated an acknowledgement after it was already accepted.';
  if (c.category.startsWith('direct-') || c.category.startsWith('message-request-')) return `Controlled ${c.module.toLowerCase()} authorization/state permutation: ${c.category}.`;
  return 'None; this is a baseline authorization or ownership request.';
}
function setupFor(c) {
  if (c.module === 'Direct Messages') return [
    'Users A and B are the two members of the controlled direct-message channel.',
    c.actor === 'D' ? 'User D is a same-institution medical peer but is not a member of that conversation.' : actorLabel(c.actor),
    'Users E–H use different institutions and no shared space for relationship-state checks.',
  ].filter(Boolean);
  if (c.module === 'Message Requests') return [
    'Users E–H are genuinely unrelated fixture identities: different institutions and no shared space.',
    'The reset models pending, declined, blocked, and accepted request states with fixed controlled IDs.',
    actorLabel(c.actor),
  ].filter(Boolean);
  if (c.category === 'authentication-negative') return ['No valid authenticated identity is supplied.'];
  if (c.category === 'foreign-resource' && c.name.startsWith('cross-channel')) return [
    `${actorLabel(c.actor)} has access to the controlled A/B channel.`,
    'The target message belongs to User C in a separate controlled space and channel.',
  ];
  if (c.category === 'foreign-resource') return [
    'User A owns the controlled space.',
    'The referenced field is replaced with a valid controlled value from another identity or space context.',
  ];
  if (c.name.includes('message')) {
    const owner = c.name.match(/(?:edit|delete) ([AB]) message/)?.[1];
    return [
      actorLabel(c.actor),
      owner ? `The target message was created by User ${owner}.` : 'The target message is in the controlled A/B channel.',
    ];
  }
  if (c.name.includes('handoff')) return [
    actorLabel(c.actor),
    'The controlled handoff was sent from User A to User B in the controlled space.',
  ];
  if (c.name.includes('space') || c.name.includes('member') || c.name.includes('channel')) return [
    'User A owns the controlled space.',
    'User B is a normal member of that space.',
    c.actor === 'C' ? 'User C is not a member of that space.' : actorLabel(c.actor),
  ].filter(Boolean);
  return [actorLabel(c.actor)];
}
function whatItChecks(c) {
  if (c.module === 'Direct Messages') return 'Checks direct-message participant, relationship, resource-binding, receipt, and metadata isolation using the implemented channel and message routes.';
  if (c.module === 'Message Requests') return 'Checks request visibility, recipient-only lifecycle transitions, relationship-state binding, and bounded request input handling.';
  if (c.category === 'authentication-negative') return 'Checks that the protected profile endpoint rejects missing, malformed, incorrectly formatted, or tampered authentication credentials.';
  if (c.name.startsWith('cross-channel')) return 'Checks that a caller who can access one channel cannot use that channel URL to operate on a message from another controlled channel.';
  if (c.name.includes('edit A message') && c.actor === 'B') return 'Checks whether User B can modify a message created by User A. Message editing should be limited to the sender.';
  if (c.name.includes('delete') && c.name.includes('message')) return 'Checks whether message deletion follows the route’s ownership and space-administration rules without allowing an unrelated caller to delete it.';
  if (c.name.includes('create message')) return 'Checks that only members of the controlled space can create a channel message.';
  if (c.name.includes('update space') || c.name.includes('remove member')) return 'Checks that an ordinary member or outsider cannot perform space-administration actions.';
  if (c.name.includes('acknowledge')) return 'Checks that only the intended handoff recipient can acknowledge a submitted handoff, and that acknowledgement cannot be replayed.';
  if (c.name.includes('draft handoff')) return 'Checks whether handoff creation or draft lifecycle actions are limited to the permitted space member and sender.';
  if (c.category === 'foreign-resource') return 'Checks whether the API rejects a valid identifier when it belongs to a different controlled resource or identity context.';
  if (/schema|boundary|required|enum|object-id|pagination|ownership-fields/.test(c.category)) return 'Checks that request validation safely handles the supplied boundary, type, identifier, enum, or client-controlled ownership-field mutation.';
  if (c.name.startsWith('read ') || c.name.startsWith('list ')) return 'Checks whether reading this controlled resource is limited to authenticated callers with the required space membership.';
  return 'Checks the endpoint’s current authentication, authorization, and input-handling contract for this controlled request.';
}
function expectedBehaviour(c) {
  const statuses = c.statuses.join(' or ');
  if (c.actor === 'anonymous' || c.category === 'authentication-negative') return `The API should reject the request with HTTP ${statuses} because no valid authenticated session is presented.`;
  if (c.statuses.every(s => s >= 400)) return `The API should reject the request with HTTP ${statuses} under the endpoint’s current security contract and must not change the controlled state.`;
  return `The API should return HTTP ${statuses} for this permitted controlled action. Where the request is denied by an alternate allowed response, controlled state must remain unchanged.`;
}
function actionPerformed(c, endpoint) {
  const identity = c.actor === 'anonymous' ? 'Without a valid Authorization header' : `Authenticated as ${actorLabel(c.actor)}`;
  return `${identity}, sent a ${c.method} request to ${endpoint}.`;
}
function whyItMatters(result) {
  if (result.passed) return 'The observed response and controlled-state check match the security rule encoded from the implemented route, middleware, validator, and controller behavior.';
  return 'The observed behavior differs from the encoded security expectation. It is recorded for review and is not, by itself, a confirmed vulnerability.';
}
function potentialImpact(result) {
  if (result.report.securityArea.includes('Authentication')) return 'If confirmed exploitable, invalid or malformed credentials might not be consistently rejected by protected endpoints.';
  if (result.report.securityArea.includes('IDOR') || result.report.securityArea.includes('Ownership') || result.report.securityArea.includes('Authorization')) return 'If confirmed exploitable, a caller could potentially read or change a resource outside their intended ownership or membership boundary.';
  return 'If confirmed exploitable, malformed input could produce inconsistent request handling or weaken an expected server-side guard.';
}
function anchorFor(result) { return `${result.caseId.toLowerCase()}--${result.name.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`.replace(/-+$/, ''); }
async function execute(c) {
  stage = `fixture reset for ${c.name}`;
  await reset();
  const ctx = { http, models, users, ids };
  if (typeof c.prepare === 'function') await c.prepare(ctx);
  if (c.prepare === 'acknowledge') assert.equal((await http('B', 'POST', `${hp}/acknowledge`, {})).status, 200, 'Replay prerequisite failed');
  if (c.prepare === 'draft') await models.Handoff.findByIdAndUpdate(ids.handoff, { status: 'draft', submittedAt: null }, { runValidators: true });
  let body = c.body === 'handoff' ? handoffBody() : typeof c.body === 'function' ? c.body(ctx) : c.body && structuredClone(c.body);
  if (c.foreignField) body[c.foreignField] = c.foreignField === 'channelId' ? ids.otherChannel : c.foreignField === 'spaceId' ? ids.otherSpace : String(users.C._id);
  if (c.mutation) {
    const { field, variant } = c.mutation;
    if (variant === 'missing') delete body[field]; else body[field] = variant === 'null' ? null : 'invalid';
  }
  const replaceFixtureReferences = (value) => {
    if (typeof value === 'string') return value.replace(/:([A-I])\b/g, (_match, actor) => String(users[actor]._id));
    if (Array.isArray(value)) return value.map(replaceFixtureReferences);
    if (value && typeof value === 'object') return Object.fromEntries(Object.entries(value).map(([key, item]) => [key, replaceFixtureReferences(item)]));
    return value;
  };
  body = replaceFixtureReferences(body);
  const endpoint = replaceFixtureReferences(typeof c.endpoint === 'function' ? c.endpoint(ctx) : c.endpoint);
  const before = await snapshot();
  stage = `${c.actor} ${c.method} ${c.endpoint}`;
  const r = await http(c.actor, c.method, endpoint, body, c.header);
  const unchanged = before === await snapshot();
  const denial = c.statuses.every(s => s >= 400);
  const semantic = !c.check || (r.data !== null && await c.check(r.data, ctx));
  const passed = c.statuses.includes(r.status) && !!r.data && r.data.success === !denial && semantic && (!denial || unchanged);
  const validation = /schema|boundary|required|enum|object-id/.test(c.category);
  const classification = passed ? 'confirmed expected behavior' : validation ? 'validation weakness/hardening opportunity' : (r.status < 300 && denial) || (denial && !unchanged) ? 'likely security finding' : 'ambiguous / requires manual investigation';
  const result = { caseId: `VOCLE-${String(results.length + 1).padStart(3, '0')}`, name: c.name, actor: c.actor, endpoint, method: c.method, module: c.module, context: c.context, mutationCategory: c.category,
    expected: { statuses: c.statuses, successfulEnvelope: !denial, deniedWritesMustPreserveState: denial, semanticCheck: !!c.check },
    actual: { status: r.status, success: r.data?.success ?? null, stateUnchanged: unchanged, semanticCheckPassed: !!semantic, jsonResponse: !!r.data },
    sources: c.sources, passed, classification, manualConfirmationWorthwhile: !passed,
    report: { securityArea: securityArea(c.category), module: c.module, whatItChecks: whatItChecks(c), testSetup: setupFor(c), actionPerformed: actionPerformed(c, endpoint), mutation: mutationDescription(c), expectedSecurityBehaviour: expectedBehaviour(c) } };
  results.push(result);
  // A server error is an observation only if the service remains healthy.
  if (r.status >= 500) await health();
}
function report() {
  const directory = path.join(process.env.RUNNER_TEMP || require('node:os').tmpdir(), 'vocle-security-results');
  fs.mkdirSync(directory, { recursive: true });
  const unexpected = results.filter(r => !r.passed);
  const moduleBreakdown = Object.entries(results.reduce((counts, result) => {
    counts[result.module] = (counts[result.module] || 0) + 1;
    return counts;
  }, {})).sort(([a], [b]) => a.localeCompare(b));
  const summary = { planned: cases.length, executed: results.length, passed: results.length - unexpected.length, unexpected: unexpected.length, infrastructureFailure: fatal, moduleBreakdown: Object.fromEntries(moduleBreakdown), results };
  fs.writeFileSync(path.join(directory, 'results.json'), JSON.stringify(summary, null, 2));
  const markdown = [`# Vocle API discovery`, '', `Executed ${summary.executed}/${summary.planned}; passed ${summary.passed}; observations ${summary.unexpected}.`, `Infrastructure: ${fatal || 'healthy'}.`, '', 'Module breakdown:', ...moduleBreakdown.map(([module, count]) => `- ${module}: ${count}`), '', 'Observations are candidates, not confirmed vulnerabilities. See results.json for every case and source.', '', ...unexpected.map(r => `- ${r.caseId}: ${r.actor} ${r.method} ${r.endpoint}; ${r.mutationCategory}; expected ${r.expected.statuses.join('/')}, got ${r.actual.status}; ${r.classification}; manual confirmation worthwhile.`)].join('\n');
  fs.writeFileSync(path.join(directory, 'summary.md'), markdown);
  const categoryBreakdown = Object.entries(results.reduce((counts, result) => {
    counts[result.report.securityArea] = (counts[result.report.securityArea] || 0) + 1;
    return counts;
  }, {})).sort(([a], [b]) => a.localeCompare(b));
  const detailed = [
    '# Vocle API Security Test Report',
    '',
    'This report is generated from the security cases that actually executed in the disposable local CI environment. `results.json` remains the machine-readable source of truth; `summary.md` is the concise run summary.',
    '',
    '## Controlled test identities and resources',
    '',
    '- User A = space owner/admin.',
    '- User B = normal member.',
    '- User C = authenticated outsider/non-member; User D = same-institution peer without channel membership.',
    '- Users E–H = different-institution, no-shared-space message-request identities; User I = inactive target-only identity.',
    '- Anonymous = unauthenticated caller.',
    '',
    'Controlled resources include group and direct messages, relationship-state message requests, and handoffs between controlled users. All requests target the disposable local backend and database only.',
    '',
    '## Report summary',
    '',
    `- Total tests executed: ${summary.executed}/${summary.planned}`,
    `- Passed: ${summary.passed}`,
    `- Observations: ${summary.unexpected}`,
    `- Infrastructure status: ${fatal || 'healthy'}`,
    '- Security-area breakdown:',
    ...categoryBreakdown.map(([area, count]) => `  - ${area}: ${count}`),
    '- Module breakdown:',
    ...moduleBreakdown.map(([module, count]) => `  - ${module}: ${count}`),
    '',
    '## Security Observations Requiring Review',
    '',
    ...(unexpected.length ? unexpected.map(result => `- [${result.caseId} — ${result.name}](#${anchorFor(result)}): expected HTTP ${result.expected.statuses.join('/')}, received HTTP ${result.actual.status}; ${result.classification}.`) : ['No observations were recorded in this execution.']),
    '',
    'Observations are not confirmed vulnerabilities. A finding is only labelled confirmed after separate review and reproduction.',
    '',
    '## Executed testcase catalog',
    '',
    ...results.flatMap(result => {
      const state = result.actual.stateUnchanged ? 'controlled database/application state remained unchanged' : 'controlled database/application state changed';
      const lines = [
        `### ${result.caseId} — ${result.name}`,
        '',
        `**Security area:** ${result.report.securityArea}`,
        '',
        `**Module/context:** ${result.report.module} — ${result.context}`,
        '',
        '**What this test checks:**',
        result.report.whatItChecks,
        '',
        '**Test setup:**',
        ...result.report.testSetup.map(item => `- ${item}`),
        '',
        '**Action performed:**',
        result.report.actionPerformed,
        `- HTTP method: \`${result.method}\``,
        `- Endpoint: \`${result.endpoint}\``,
        `- Mutation used: ${result.report.mutation}`,
        '',
        '**Expected security behaviour:**',
        result.report.expectedSecurityBehaviour,
        '',
        '**Actual result:**',
        `- HTTP status: ${result.actual.status}`,
        `- Request succeeded: ${result.actual.success === true ? 'yes' : result.actual.success === false ? 'no' : 'not represented by the expected JSON envelope'}`,
        `- State check: ${state}.`,
        `- Semantic check: ${result.actual.semanticCheckPassed ? 'passed' : 'did not pass'}.`,
        '',
        `**Result:** ${result.passed ? 'PASS' : 'OBSERVATION'}`,
        '',
        '**Why this result matters:**',
        whyItMatters(result),
      ];
      if (!result.passed) lines.push('', '**Potential security impact:**', potentialImpact(result), '', '**Recommended follow-up:**', result.manualConfirmationWorthwhile ? 'Manually reproduce with Reqable or an equivalent controlled client, then inspect the applicable route, middleware, validator, and controller before classifying severity.' : 'Review the recorded behavior in the controlled environment.');
      return [...lines, ''];
    }),
  ].join('\n');
  fs.writeFileSync(path.join(directory, 'security-test-report.md'), detailed);
  if (process.env.GITHUB_STEP_SUMMARY) fs.appendFileSync(process.env.GITHUB_STEP_SUMMARY, markdown + '\n');
  console.log(`API discovery: ${summary.executed}/${summary.planned} executed, ${summary.passed} passed, ${summary.unexpected} observations.`);
}
async function main() {
  safety();
  stage = 'database and authentication preflight';
  mongoose = require('mongoose');
  models = Object.fromEntries(['User', 'Space', 'Channel', 'Message', 'Handoff'].map(n => [n, require(`../src/features/${n === 'Handoff' ? 'handoffs' : n.toLowerCase() + 's'}/${n.toLowerCase()}.model`)]));
  models.MessageRequest = require('../src/features/message-requests/messageRequest.model');
  await mongoose.connect(URI, { serverSelectionTimeoutMS: 10000 });
  users = {};
  for (const [i, actor] of ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].entries()) {
    users[actor] = await models.User.findOne({ phone: `+1555000000${i + 1}`, isActive: true, isOnboarded: true, isVerified: true });
    assert.ok(users[actor], 'Fixture identity missing');
    tokens[actor] = process.env[`VOCLE_TEST_USER_${actor}_TOKEN`];
    assert.ok(tokens[actor], 'Authentication setup token missing');
    const r = await http(actor, 'GET', '/api/users/me');
    assert.ok(r.status === 200 && r.data?.data?.user?._id === String(users[actor]._id), 'Authentication identity preflight failed');
  }
  await health();
  for (const c of cases) await execute(c);
  await health();
}
if (process.argv.includes('--list')) {
  console.log(JSON.stringify({ count: cases.length, cases: cases.map(({ name, actor, method, endpoint, category }) => ({ name, actor, method, endpoint, category })) }, null, 2));
} else {
  main().catch(() => { fatal = `Execution prerequisite failed at ${stage}. Raw errors omitted to protect credentials.`; console.error(fatal); process.exitCode = 1; }).finally(async () => {
    try { report(); } finally { if (mongoose) await mongoose.disconnect(); }
  });
}
