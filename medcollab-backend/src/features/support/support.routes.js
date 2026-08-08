const express = require('express');
const { protect } = require('../../middleware/auth');
const supportController = require('./support.controller');

const router = express.Router();

router.use(protect);

/**
 * @route POST /api/support/bug
 * @desc  File a bug report (authenticated)
 */
router.post('/bug', supportController.createBug);

/**
 * @route POST /api/support/feature
 * @desc  File a feature request (authenticated)
 */
router.post('/feature', supportController.createFeature);

module.exports = router;
