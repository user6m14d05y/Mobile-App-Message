const path = require('path');
// Bien moi truong ENV dotenv
require('dotenv').config();
require('dotenv').config({ path: path.join(__dirname, '../../.env') });

const http = require('http');
const app = require('./app');
const connectDB = require('./config/db');
const initSocket = require('./sockets/socket');

// Connect Database
connectDB();

const server = http.createServer(app);

// Init Socket.IO (Real Time)
const io = require('socket.io')(server, {
  // set time out 60s
  pingTimeout: 60000,
  cors: {
    origin: '*', // Allow all origins
  },
});

initSocket(io);

const PORT = process.env.PORT || 5000;

server.listen(PORT, console.log(`Server đang chạy trên port ${PORT}`));
