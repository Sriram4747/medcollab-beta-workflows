/**
 * USER CONTROLLER
 */

const User = require('./user.model');
const { respond } = require('../../utils/apiResponse');
const escapeRegex = require('../../utils/escapeRegex');
const asyncHandler = require('../../utils/asyncHandler');
const { emitNotification } = require('../../socket');
const { getIO } = require('../../socket');
const { isUserOnline } = require('../../socket/handlers/presence.handler');
const { SOCKET_EVENTS } = require('../../constants');
const logger = require('../../utils/logger');

/**
 * GET /api/users/me
 * Return the full authenticated user profile
 */
const getMe = asyncHandler(async (req, res) => {
  // req.user is already attached by protect middleware
  // Re-fetch to get the latest data (availability may have changed via socket)
  const user = await User.findById(req.user._id);
  return respond.ok(res, 'Profile fetched', { user: user.toPublicProfile() });
});

/**
 * PUT /api/users/me
 * Update profile fields. Sets isOnboarded=true once name+role are present.
 */
const updateMe = asyncHandler(async (req, res) => {
  const allowed = ['name', 'displayTitle', 'role', 'speciality', 'pgYear',
                   'institution', 'city', 'bio', 'notifications'];

  const updates = {};
  allowed.forEach((field) => {
    if (req.body[field] !== undefined) updates[field] = req.body[field];
  });

  // Promote to onboarded once they have the minimum required fields
  const user = await User.findById(req.user._id);
  const nameAfter  = updates.name  ?? user.name;
  const roleAfter  = updates.role  ?? user.role;

  if (nameAfter && roleAfter && !user.isOnboarded) {
    updates.isOnboarded = true;
  }

  const updated = await User.findByIdAndUpdate(
    req.user._id,
    { $set: updates },
    { new: true, runValidators: true }
  );

  return respond.ok(res, 'Profile updated', { user: updated.toPublicProfile() });
});

/**
 * PUT /api/users/me/availability
 * Update availability status and broadcast to all space rooms via socket
 */
const updateAvailability = asyncHandler(async (req, res) => {
  const { status, until, note } = req.body;

  const updated = await User.findByIdAndUpdate(
    req.user._id,
    {
      'availability.status': status,
      'availability.until': until || null,
      'availability.note': note || '',
      'availability.updatedAt': new Date(),
    },
    { new: true }
  );

  // Broadcast presence update to all spaces this user is in — other members
  // will see the status dot change in real time without refreshing
  try {
    const Space = require('../spaces/space.model');
    const spaces = await Space.find(
      { 'members.userId': req.user._id },
      { _id: 1 }
    ).lean();

    const io = getIO();
    spaces.forEach(({ _id }) => {
      io.to(`space:${_id}`).emit(SOCKET_EVENTS.PRESENCE_UPDATE, {
        userId: req.user._id.toString(),
        isOnline: isUserOnline(req.user._id),
        availability: {
          status: updated.availability.status,
          until: updated.availability.until || null,
          note: updated.availability.note || '',
        },
        updatedAt: new Date().toISOString(),
      });
    });
  } catch (err) {
    // Non-fatal — socket may not be up in test env
    logger.debug(`Availability broadcast skipped: ${err.message}`);
  }

  return respond.ok(res, 'Availability updated', {
    availability: updated.availability,
  });
});

/**
 * PUT /api/users/me/fcm-token
 * Register a device FCM token for push notifications
 */
const registerFcmToken = asyncHandler(async (req, res) => {
  const { token } = req.body;
  const user = await User.findById(req.user._id);
  await user.addFcmToken(token);   // Instance method handles dedup + cap
  return respond.ok(res, 'Device registered for notifications');
});

/**
 * GET /api/users/:id
 * Get another user's public profile
 */
const getUserById = asyncHandler(async (req, res) => {
  const user = await User.findById(req.params.id);
  if (!user) return respond.notFound(res, 'User not found');
  return respond.ok(res, 'User fetched', { user: user.toPublicProfile() });
});

/**
 * GET /api/users/search?q=priya&spaceId=...
 * Search users by name or institution for @mentions and DM creation
 */
const searchUsers = asyncHandler(async (req, res) => {
  const { q, spaceId } = req.query;

  if (!q || q.trim().length < 2) {
    return respond.badRequest(res, 'Search query must be at least 2 characters');
  }

  const searchRegex = new RegExp(escapeRegex(q.trim()), 'i');
  const Space = require('../spaces/space.model');

  // Privacy default: only people who share at least one active space with the caller.
  // Optional spaceId further narrows to that group's members.
  let memberIds;
  if (spaceId) {
    const space = await Space.findById(spaceId).select('members');
    if (!space) {
      return respond.ok(res, 'Search results', { users: [] });
    }
    memberIds = space.members.map((m) => m.userId);
  } else {
    const spaces = await Space.find(
      { 'members.userId': req.user._id, isActive: true },
      { members: 1 }
    ).lean();
    memberIds = [
      ...new Set(
        spaces.flatMap((s) => (s.members || []).map((m) => m.userId.toString()))
      ),
    ];
  }

  const selfId = req.user._id.toString();
  const filteredIds = memberIds
    .map((id) => id.toString())
    .filter((id) => id !== selfId);

  if (filteredIds.length === 0) {
    return respond.ok(res, 'Search results', { users: [] });
  }

  const users = await User.find({
    _id: { $in: filteredIds },
    isActive: true,
    isOnboarded: true,
    $or: [{ name: searchRegex }, { institution: searchRegex }],
  })
    .select('name displayTitle role speciality institution avatarUrl availability')
    .limit(20)
    .lean();

  return respond.ok(res, 'Search results', { users });
});

module.exports = {
  getMe, updateMe, updateAvailability,
  registerFcmToken, getUserById, searchUsers,
};
