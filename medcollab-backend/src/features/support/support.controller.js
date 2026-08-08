/**
 * Support inbox — bugs & feature requests stored in MongoDB for the beta team.
 * Accessible only by authenticated users (write) + logged as SupportTicket.
 */

const mongoose = require('mongoose');
const asyncHandler = require('../../utils/asyncHandler');
const { respond } = require('../../utils/apiResponse');
const logger = require('../../utils/logger');

const ticketSchema = new mongoose.Schema(
  {
    type: {
      type: String,
      enum: ['bug', 'feature'],
      required: true,
      index: true,
    },
    title: { type: String, required: true, maxlength: 200 },
    description: { type: String, required: true, maxlength: 5000 },
    steps: { type: String, maxlength: 3000, default: '' },
    context: { type: String, maxlength: 3000, default: '' },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    userName: { type: String },
    userPhone: { type: String },
    status: {
      type: String,
      enum: ['open', 'triaged', 'closed'],
      default: 'open',
      index: true,
    },
  },
  { timestamps: true }
);

const SupportTicket =
  mongoose.models.SupportTicket ||
  mongoose.model('SupportTicket', ticketSchema);

const createBug = asyncHandler(async (req, res) => {
  const { title, description, steps } = req.body || {};
  if (!title?.trim() || !description?.trim()) {
    return respond.badRequest(res, 'Title and description are required');
  }

  const ticket = await SupportTicket.create({
    type: 'bug',
    title: String(title).trim().slice(0, 200),
    description: String(description).trim().slice(0, 5000),
    steps: steps ? String(steps).trim().slice(0, 3000) : '',
    userId: req.user._id,
    userName: req.user.name,
    userPhone: req.user.phone,
  });

  logger.info(`Support bug filed by ${req.user._id}: ${ticket.title}`);
  return respond.created(res, 'Bug report received', {
    ticketId: ticket._id,
  });
});

const createFeature = asyncHandler(async (req, res) => {
  const { title, description, context } = req.body || {};
  if (!title?.trim() || !description?.trim()) {
    return respond.badRequest(res, 'Title and description are required');
  }

  const ticket = await SupportTicket.create({
    type: 'feature',
    title: String(title).trim().slice(0, 200),
    description: String(description).trim().slice(0, 5000),
    context: context ? String(context).trim().slice(0, 3000) : '',
    userId: req.user._id,
    userName: req.user.name,
    userPhone: req.user.phone,
  });

  logger.info(`Support feature filed by ${req.user._id}: ${ticket.title}`);
  return respond.created(res, 'Feature request received', {
    ticketId: ticket._id,
  });
});

module.exports = { createBug, createFeature, SupportTicket };
