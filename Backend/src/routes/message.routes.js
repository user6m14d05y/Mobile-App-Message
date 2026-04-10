const express = require('express');
const {
  sendMessage,
  allMessages,
  accessConversation,
  fetchConversations,
} = require('../controllers/message.controller');
const { protect } = require('../middleware/auth.middleware');

const router = express.Router();

router.route('/conversation').post(protect, accessConversation);
router.route('/conversations').get(protect, fetchConversations);
router.route('/').post(protect, sendMessage);
router.route('/:conversationId').get(protect, allMessages);

module.exports = router;
