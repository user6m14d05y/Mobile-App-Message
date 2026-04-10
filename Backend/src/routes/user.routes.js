const express = require('express');
const { 
  getUsers, 
  getUserProfile, 
  sendFriendRequest, 
  getFriendRequests, 
  respondToFriendRequest, 
  getFriends 
} = require('../controllers/user.controller');
const { protect } = require('../middleware/auth.middleware');

const router = express.Router();

router.get('/', protect, getUsers);
router.get('/profile', protect, getUserProfile);

// Friendship routes
router.post('/friend-request', protect, sendFriendRequest);
router.get('/friend-requests', protect, getFriendRequests);
router.put('/friend-request/:id', protect, respondToFriendRequest);
router.get('/friends', protect, getFriends);

module.exports = router;
