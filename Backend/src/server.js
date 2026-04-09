require('dotenv').config();
const http = require('http');
const app = require('./app');
const connectDB = require('./config/db');
const initSocket = require('./sockets/socket');

// Kết nối database
connectDB();

const server = http.createServer(app);

// Khởi tạo Socket.IO
const io = require('socket.io')(server, {
  pingTimeout: 60000,
  cors: {
    origin: '*', // Trong môi trường production, bạn nên giới hạn origin
  },
});

initSocket(io);

const PORT = process.env.PORT || 5000;

server.listen(PORT, console.log(`🚀 Server đang chạy trên port ${PORT}`));
