const Message = require('../models/Message');
const User = require('../models/User');
const Conversation = require('../models/Conversation');

// @desc    Send a message
// @route   POST /api/messages
// @access  Private
const sendMessage = async (req, res) => {
  try {
    const { content, conversationId } = req.body;

    if (!content || !conversationId) {
      return res.status(400).json({ message: 'Dữ liệu không hợp lệ' });
    }

    let newMessage = {
      sender: req.user._id,
      content: content,
      conversation: conversationId,
    };

    let message = await Message.create(newMessage);

    message = await message.populate('sender', 'name avatar');
    message = await message.populate('conversation');
    message = await User.populate(message, {
      path: 'conversation.participants',
      select: 'name avatar email',
    });

    await Conversation.findByIdAndUpdate(conversationId, {
      latestMessage: message,
    });

    res.json(message);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get all messages for a conversation
// @route   GET /api/messages/:conversationId
// @access  Private
const allMessages = async (req, res) => {
  try {
    const messages = await Message.find({ conversation: req.params.conversationId })
      .populate('sender', 'name avatar email')
      .populate('conversation');

    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Create or access a 1-to-1 conversation
// @route   POST /api/messages/conversation
// @access  Private
const accessConversation = async (req, res) => {
  const { userId } = req.body;

  if (!userId) {
    return res.status(400).json({ message: 'UserId không được gửi' });
  }

  let isChat = await Conversation.find({
    isGroupChat: false,
    $and: [
      { participants: { $elemMatch: { $eq: req.user._id } } },
      { participants: { $elemMatch: { $eq: userId } } },
    ],
  })
    .populate('participants', '-password')
    .populate('latestMessage');

  isChat = await User.populate(isChat, {
    path: 'latestMessage.sender',
    select: 'name avatar email',
  });

  if (isChat.length > 0) {
    res.send(isChat[0]);
  } else {
    // Không tìm thấy conversation => tạo mới
    var chatData = {
      name: 'sender',
      isGroupChat: false,
      participants: [req.user._id, userId],
    };

    try {
      const createdChat = await Conversation.create(chatData);
      const FullChat = await Conversation.findOne({ _id: createdChat._id }).populate(
        'participants',
        '-password'
      );
      res.status(200).json(FullChat);
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
};

// @desc    Fetch all conversations for a user
// @route   GET /api/messages/conversations
// @access  Private
const fetchConversations = async (req, res) => {
  try {
    Conversation.find({ participants: { $elemMatch: { $eq: req.user._id } } })
      .populate('participants', '-password')
      .populate('latestMessage')
      .sort({ updatedAt: -1 })
      .then(async (results) => {
        results = await User.populate(results, {
          path: 'latestMessage.sender',
          select: 'name avatar email',
        });
        res.status(200).send(results);
      });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  sendMessage,
  allMessages,
  accessConversation,
  fetchConversations,
};
