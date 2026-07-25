/**
 * SEARCH ROUTES
 *
 * GET /api/search?q=...&type=all|messages|doctors|channels|attachments
 */

const express = require('express');
const router = express.Router();
const { protect, requireOnboarding } = require('../../middleware/auth');
const searchController = require('./search.controller');

router.use(protect, requireOnboarding);

router.get('/', searchController.globalSearch);

module.exports = router;
