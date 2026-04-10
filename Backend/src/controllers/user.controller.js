const User = require('../models/User');
const FriendRequest = require('../models/FriendRequest');


// @desc    Get all users (searchable)
// @route   GET /api/users
// @access  Private
const getUsers = async (req, res) => {
  try {
    const keyword = req.query.search
      ? {
          $or: [
            { name: { $regex: req.query.search, $options: 'i' } },
            { email: { $regex: req.query.search, $options: 'i' } },
          ],
        }
      : {};

    // Do not return the current logged in user
    const users = await User.find({ ...keyword, _id: { $ne: req.user._id } }).select('-password');
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get user profile
// @route   GET /api/users/profile
// @access  Private
const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-password');
    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Send Friend Request
// @route   POST /api/users/friend-request
// @access  Private
const sendFriendRequest = async (req, res) => {
  try {
    const { receiverId } = req.body;

    // Check if target exists
    const receiver = await User.findById(receiverId);
    if (!receiver) {
      return res.status(404).json({ message: 'Người dùng không tồn tại' });
    }

    // Check if already friends
    const sender = await User.findById(req.user._id);
    if (sender.friends.includes(receiverId)) {
      return res.status(400).json({ message: 'Hai người đã là bạn bè' });
    }

    // Check if request already exists
    const existingRequest = await FriendRequest.findOne({
      $or: [
        { sender: req.user._id, receiver: receiverId },
        { sender: receiverId, receiver: req.user._id },
      ],
      status: 'pending',
    });

    if (existingRequest) {
      return res.status(400).json({ message: 'Đã có lời mời kết bạn đang chờ' });
    }

    const newRequest = await FriendRequest.create({
      sender: req.user._id,
      receiver: receiverId,
    });

    res.status(201).json(newRequest);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get Friend Requests (Incoming)
// @route   GET /api/users/friend-requests
// @access  Private
const getFriendRequests = async (req, res) => {
  try {
    const requests = await FriendRequest.find({
      receiver: req.user._id,
      status: 'pending',
    }).populate('sender', 'name email avatar');
    res.json(requests);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Respond to Friend Request (Accept/Reject)
// @route   PUT /api/users/friend-request/:id
// @access  Private
const respondToFriendRequest = async (req, res) => {
  try {
    const { status } = req.body; // 'accepted' or 'rejected'
    const request = await FriendRequest.findById(req.params.id);

    if (!request) {
      return res.status(404).json({ message: 'Không tìm thấy lời mời' });
    }

    if (request.receiver.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: 'Bạn không có quyền này' });
    }

    request.status = status;
    await request.save();

    if (status === 'accepted') {
      // Add to friends list for both
      await User.findByIdAndUpdate(request.sender, { $push: { friends: request.receiver } });
      await User.findByIdAndUpdate(request.receiver, { $push: { friends: request.sender } });
    }

    res.json(request);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get Friends List
// @route   GET /api/users/friends
// @access  Private
const getFriends = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).populate('friends', 'name email avatar isOnline lastSeen');
    res.json(user.friends);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getUsers,
  getUserProfile,
  sendFriendRequest,
  getFriendRequests,
  respondToFriendRequest,
  getFriends,
};

