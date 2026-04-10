const User = require('../models/User');

const initSocket = (io) => {
  io.on('connection', (socket) => {
    let currentUser = null;
    console.log('🔗 Connected to Socket.io');

    // User kết nối, tạo room riêng dựa trên userId
    socket.on('setup', async (userData) => {
      currentUser = userData;
      socket.join(userData._id);
      socket.emit('connected');
      
      // Set online in DB and broadcast
      await User.findByIdAndUpdate(userData._id, { isOnline: true });
      io.emit('user status changed', { userId: userData._id, isOnline: true });
    });

    // Tham gia một phòng chat cụ thể
    socket.on('join chat', (room) => {
      socket.join(room);
      console.log('User Joined Room: ' + room);
    });

    // Đang nhập văn bản
    socket.on('typing', (room) => socket.in(room).emit('typing'));
    socket.on('stop typing', (room) => socket.in(room).emit('stop typing'));

    // Gửi tin nhắn mới
    socket.on('new message', (newMessageRecieved) => {
      var chat = newMessageRecieved.conversation;

      if (!chat.participants) return console.log('Chat participants not defined');

      chat.participants.forEach((user) => {
        // Không gửi lại cho chính người gửi
        if (user._id == newMessageRecieved.sender._id) return;

        socket.in(user._id).emit('message recieved', newMessageRecieved);
      });
    });

    socket.off('setup', async () => {
      console.log('🔗 USER DISCONNECTED (setup off)');
      if (currentUser) {
        socket.leave(currentUser._id);
      }
    });

    socket.on('disconnect', async () => {
      if (currentUser) {
        console.log(`🔗 USER DISCONNECTED: ${currentUser.name}`);
        // Set offline in DB and broadcast
        await User.findByIdAndUpdate(currentUser._id, { isOnline: false, lastSeen: new Date() });
        io.emit('user status changed', { userId: currentUser._id, isOnline: false });
      }
    });
  });
};

module.exports = initSocket;
