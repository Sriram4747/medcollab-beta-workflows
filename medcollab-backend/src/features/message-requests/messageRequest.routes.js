const express = require('express');
const { protect, requireOnboarding } = require('../../middleware/auth');
const { validateMongoId } = require('../../middleware/validate');
const { body } = require('express-validator');
const { handleValidationErrors } = require('../../middleware/validate');
const messageRequestController = require('./messageRequest.controller');

const router = express.Router();

router.use(protect, requireOnboarding);

router.get('/pending-count', messageRequestController.pendingCount);

router.get('/', messageRequestController.listRequests);

router.post(
  '/',
  [
    body('toUserId').notEmpty().withMessage('toUserId is required'),
    body('introMessage')
      .optional()
      .isString()
      .isLength({ max: 280 })
      .withMessage('introMessage max 280 characters'),
    handleValidationErrors,
  ],
  messageRequestController.createRequest
);

router.post(
  '/:id/accept',
  validateMongoId('id'),
  messageRequestController.acceptRequest
);

router.post(
  '/:id/decline',
  validateMongoId('id'),
  messageRequestController.declineRequest
);

module.exports = router;
