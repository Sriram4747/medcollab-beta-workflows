/**
 * Resolve which authenticated users currently have a socket in a channel room
 * (i.e. are viewing that chat). Used to suppress noisy inbox/FCM while reading.
 */
async function getUserIdsViewingChannel(channelId) {
  try {
    const { getIO } = require('../index');
    const io = getIO();
    if (!io || !channelId) return new Set();
    const sockets = await io.in(`channel:${channelId}`).fetchSockets();
    const ids = new Set();
    for (const s of sockets) {
      const id = s.userId?.toString?.() || s.userId;
      if (id) ids.add(id.toString());
    }
    return ids;
  } catch (_) {
    return new Set();
  }
}

module.exports = { getUserIdsViewingChannel };
