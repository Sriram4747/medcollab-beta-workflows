/**
 * Privacy: users a doctor may discover / message.
 * Known = shared active spaces ∪ existing DM peers ∪ same institution (exact).
 */

const Space = require('../features/spaces/space.model');
const Channel = require('../features/channels/channel.model');
const User = require('../features/users/user.model');
const { CHANNEL_TYPES } = require('../constants');

function normalizeInstitution(value) {
  return (value || '').trim().toLowerCase().replace(/\s+/g, ' ');
}

/**
 * @param {import('mongoose').Types.ObjectId|string} userId
 * @returns {Promise<string[]>} other user ids (never includes self)
 */
async function resolveKnownUserIds(userId) {
  const selfId = userId.toString();
  const known = new Set();

  const spaces = await Space.find(
    { 'members.userId': userId, isActive: true },
    { members: 1 }
  ).lean();

  for (const space of spaces) {
    for (const member of space.members || []) {
      const id = member.userId?.toString();
      if (id && id !== selfId) known.add(id);
    }
  }

  const dms = await Channel.find({
    type: CHANNEL_TYPES.DIRECT,
    members: userId,
    isArchived: false,
  })
    .select('members')
    .lean();

  for (const dm of dms) {
    for (const memberId of dm.members || []) {
      const id = memberId.toString();
      if (id !== selfId) known.add(id);
    }
  }

  const me = await User.findById(userId).select('institution').lean();
  const myInstitution = normalizeInstitution(me?.institution);
  if (myInstitution.length >= 2) {
    const colleagues = await User.find({
      _id: { $ne: userId },
      isActive: true,
      isOnboarded: true,
      institution: { $exists: true, $nin: [null, ''] },
    })
      .select('_id institution')
      .lean();

    for (const colleague of colleagues) {
      if (normalizeInstitution(colleague.institution) === myInstitution) {
        known.add(colleague._id.toString());
      }
    }
  }

  return [...known];
}

/**
 * @param {string} callerId
 * @param {string} targetUserId
 */
async function canMessageUser(callerId, targetUserId) {
  if (!targetUserId || callerId.toString() === targetUserId.toString()) {
    return false;
  }

  const existingDm = await Channel.findOne({
    type: CHANNEL_TYPES.DIRECT,
    members: { $all: [callerId, targetUserId] },
    isArchived: false,
  })
    .select('_id')
    .lean();
  if (existingDm) return true;

  const known = await resolveKnownUserIds(callerId);
  return known.includes(targetUserId.toString());
}

module.exports = {
  resolveKnownUserIds,
  canMessageUser,
  normalizeInstitution,
};
