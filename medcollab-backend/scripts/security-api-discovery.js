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
};
for (const [name, id] of Object.entries(ids)) assert.match(id, /^[a-f0-9]{24}$/, `Invalid scratch ObjectId for ${name}`);
const mp = `/api/channels/${ids.channel}/messages`;
const sp = `/api/spaces/${ids.space}`;
const hp = `/api/handoffs/${ids.handoff}`;
const cases = [];
function add(name, actor, method, endpoint, statuses, body, options = {}) {
  cases.push({ name, actor, method, endpoint, statuses, body,
    category: 'identity-permutation', context: 'A owns space; B is member; C is outsider; messages owned by A/B; handoff A to B',
    sources: [source(endpoint.includes('handoff') ? 'handoffs' : endpoint.includes('messages') ? 'messages' : 'spaces'), 'src/middleware/auth.js'],
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
for (const endpoint of ['/api/spaces/not-an-id', `${mp}/not-an-id/thread`, '/api/handoffs/not-an-id', '/api/spaces/7ec0000000000000000000999']) {
  add('object id boundary', 'A', 'GET', endpoint, [endpoint.endsWith('999') ? 404 : 400], undefined, { category: 'object-id', sources: ['src/middleware/validate.js:validateMongoId'] });
}
for (const field of ['toUserId', 'shiftDate', 'shiftType']) {
  for (const variant of ['missing', 'null', 'invalid']) add(`handoff ${field} ${variant}`, 'A', 'POST', '/api/handoffs', [400], 'handoff', { category: 'handoff-required-enum', mutation: { field, variant }, sources: ['src/middleware/validate.js:validateCreateHandoff', 'src/features/handoffs/handoff.model.js'] });
}

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
  // Exact scratch IDs only. Original security fixtures are never modified.
  for (const model of Object.values(models).filter(m => m !== models.User)) await model.deleteMany({ $or: [{ _id: { $in: Object.values(ids) } }, { spaceId: { $in: [ids.space, ids.otherSpace] } }] });
  await models.Space.create([
    { _id: ids.space, name: 'Discovery AB', type: 'department', inviteCode: 'DSCABA', createdBy: users.A._id, members: [{ userId: users.A._id, role: 'owner' }, { userId: users.B._id, role: 'member' }] },
    { _id: ids.otherSpace, name: 'Discovery C', type: 'department', inviteCode: 'DSCCCA', createdBy: users.C._id, members: [{ userId: users.C._id, role: 'owner' }] },
  ]);
  await models.Channel.create([
    { _id: ids.channel, name: 'discovery-ab', spaceId: ids.space, createdBy: users.A._id },
    { _id: ids.otherChannel, name: 'discovery-c', spaceId: ids.otherSpace, createdBy: users.C._id },
  ]);
  await models.Message.create(['A', 'B', 'C'].map(actor => ({ _id: actor === 'C' ? ids.otherMessage : ids[`message${actor}`], channelId: actor === 'C' ? ids.otherChannel : ids.channel, spaceId: actor === 'C' ? ids.otherSpace : ids.space, senderId: users[actor]._id, content: { text: `Discovery ${actor}` } })));
  await models.Handoff.create({ _id: ids.handoff, ...handoffBody(), fromUserId: users.A._id, status: 'submitted', submittedAt: new Date('2025-01-15') });
}
function handoffBody() {
  return { spaceId: ids.space, channelId: ids.channel, toUserId: String(users.B._id), shiftDate: '2025-01-15', shiftType: 'morning', patients: [{ bedNumber: 'CI', clinicalAlias: 'Synthetic only' }] };
}
async function snapshot() {
  const state = {};
  for (const [name, model] of Object.entries(models).filter(([n]) => n !== 'User')) {
    state[name] = await model.find({ $or: [{ _id: { $in: Object.values(ids) } }, { spaceId: { $in: [ids.space, ids.otherSpace] } }] }).sort({ _id: 1 }).lean();
  }
  return JSON.stringify(state);
}
async function execute(c) {
  stage = `fixture reset for ${c.name}`;
  await reset();
  if (c.prepare === 'acknowledge') assert.equal((await http('B', 'POST', `${hp}/acknowledge`, {})).status, 200, 'Replay prerequisite failed');
  if (c.prepare === 'draft') await models.Handoff.findByIdAndUpdate(ids.handoff, { status: 'draft', submittedAt: null }, { runValidators: true });
  let body = c.body === 'handoff' ? handoffBody() : c.body && structuredClone(c.body);
  if (c.foreignField) body[c.foreignField] = c.foreignField === 'channelId' ? ids.otherChannel : c.foreignField === 'spaceId' ? ids.otherSpace : String(users.C._id);
  if (c.mutation) {
    const { field, variant } = c.mutation;
    if (variant === 'missing') delete body[field]; else body[field] = variant === 'null' ? null : 'invalid';
  }
  if (body?.senderId === ':A') body.senderId = String(users.A._id);
  const endpoint = c.endpoint.replace(':B', String(users.B._id));
  const before = await snapshot();
  stage = `${c.actor} ${c.method} ${c.endpoint}`;
  const r = await http(c.actor, c.method, endpoint, body, c.header);
  const unchanged = before === await snapshot();
  const denial = c.statuses.every(s => s >= 400);
  const semantic = !c.check || (r.data !== null && await c.check(r.data));
  const passed = c.statuses.includes(r.status) && !!r.data && r.data.success === !denial && semantic && (!denial || unchanged);
  const validation = /schema|boundary|required|enum|object-id/.test(c.category);
  const classification = passed ? 'confirmed expected behavior' : validation ? 'validation weakness/hardening opportunity' : (r.status < 300 && denial) || (denial && !unchanged) ? 'likely security finding' : 'ambiguous / requires manual investigation';
  results.push({ caseId: `VOCLE-${String(results.length + 1).padStart(3, '0')}`, name: c.name, actor: c.actor, endpoint, method: c.method, context: c.context, mutationCategory: c.category,
    expected: { statuses: c.statuses, successfulEnvelope: !denial, deniedWritesMustPreserveState: denial, semanticCheck: !!c.check },
    actual: { status: r.status, success: r.data?.success ?? null, stateUnchanged: unchanged, semanticCheckPassed: !!semantic, jsonResponse: !!r.data },
    sources: c.sources, passed, classification, manualConfirmationWorthwhile: !passed });
  // A server error is an observation only if the service remains healthy.
  if (r.status >= 500) await health();
}
function report() {
  const directory = path.join(process.env.RUNNER_TEMP || require('node:os').tmpdir(), 'vocle-security-results');
  fs.mkdirSync(directory, { recursive: true });
  const unexpected = results.filter(r => !r.passed);
  const summary = { planned: cases.length, executed: results.length, passed: results.length - unexpected.length, unexpected: unexpected.length, infrastructureFailure: fatal, results };
  fs.writeFileSync(path.join(directory, 'results.json'), JSON.stringify(summary, null, 2));
  const markdown = [`# Vocle API discovery`, '', `Executed ${summary.executed}/${summary.planned}; passed ${summary.passed}; observations ${summary.unexpected}.`, `Infrastructure: ${fatal || 'healthy'}.`, '', 'Observations are candidates, not confirmed vulnerabilities. See results.json for every case and source.', '', ...unexpected.map(r => `- ${r.caseId}: ${r.actor} ${r.method} ${r.endpoint}; ${r.mutationCategory}; expected ${r.expected.statuses.join('/')}, got ${r.actual.status}; ${r.classification}; manual confirmation worthwhile.`)].join('\n');
  fs.writeFileSync(path.join(directory, 'summary.md'), markdown);
  if (process.env.GITHUB_STEP_SUMMARY) fs.appendFileSync(process.env.GITHUB_STEP_SUMMARY, markdown + '\n');
  console.log(`API discovery: ${summary.executed}/${summary.planned} executed, ${summary.passed} passed, ${summary.unexpected} observations.`);
}
async function main() {
  safety();
  stage = 'database and authentication preflight';
  mongoose = require('mongoose');
  models = Object.fromEntries(['User', 'Space', 'Channel', 'Message', 'Handoff'].map(n => [n, require(`../src/features/${n === 'Handoff' ? 'handoffs' : n.toLowerCase() + 's'}/${n.toLowerCase()}.model`)]));
  await mongoose.connect(URI, { serverSelectionTimeoutMS: 10000 });
  users = {};
  for (const [i, actor] of ['A', 'B', 'C'].entries()) {
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
