/**
 * Channel visibility — public channels + private channels the user belongs to.
 */
const accessibleChannelFilter = (userId, { spaceId } = {}) => {
  const filter = {
    isArchived: false,
    $or: [{ isPrivate: false }, { members: userId }],
  };
  if (spaceId) {
    filter.spaceId = spaceId;
  }
  return filter;
};

module.exports = { accessibleChannelFilter };
