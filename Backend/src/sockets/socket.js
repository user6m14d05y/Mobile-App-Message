const initSocket = (io) => {
  io.on('connection', (socket) => {
    console.log('🔗 Connected to Socket.io');

    // User kết nối, tạo room riêng dựa trên userId
    socket.on('setup', (userData) => {
      socket.join(userData._id);
      socket.emit('connected');
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

    socket.off('setup', () => {
      console.log('🔗 ƯSER DISCONNECTED');
      socket.leave(userData._id);
    });
  });
};

module.exports = initSocket;
