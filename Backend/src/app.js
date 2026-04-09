const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth.routes');
const userRoutes = require('./routes/user.routes');
const messageRoutes = require('./routes/message.routes');

const app = express();

app.use(cors());
app.use(express.json()); // Để server hiểu JSON body

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/messages', messageRoutes);

// Route mặc định kiểm tra server
app.get('/', (req, res) => {
  res.send('API của Message App đang chạy...');
});

// Middleware xử lý lỗi
app.use((req, res, next) => {
  const error = new Error(`Không tìm thấy - ${req.originalUrl}`);
  res.status(404);
  next(error);
});

app.use((err, req, res, next) => {
  const statusCode = res.statusCode === 200 ? 500 : res.statusCode;
  res.status(statusCode);
  res.json({
    message: err.message,
    stack: process.env.NODE_ENV === 'production' ? null : err.stack,
  });
});

module.exports = app;
