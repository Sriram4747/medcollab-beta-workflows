/**
 * Message request — stranger DM gate (approve before chat).
 */

const mongoose = require('mongoose');
const { MESSAGE_REQUEST_STATUS } = require('../../constants');

const messageRequestSchema = new mongoose.Schema(
  {
    fromUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    toUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    status: {
      type: String,
      enum: Object.values(MESSAGE_REQUEST_STATUS),
      default: MESSAGE_REQUEST_STATUS.PENDING,
      index: true,
    },
    introMessage: {
      type: String,
      maxlength: 280,
      trim: true,
      default: '',
    },
  },
  { timestamps: true }
);

messageRequestSchema.index({ fromUserId: 1, toUserId: 1 });
messageRequestSchema.index({ toUserId: 1, status: 1 });

module.exports = mongoose.model('MessageRequest', messageRequestSchema);
