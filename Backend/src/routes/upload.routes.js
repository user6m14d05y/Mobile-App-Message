const express = require('express');
const multer = require('multer');
const path = require('path');
const { protect } = require('../middleware/auth.middleware');

const router = express.Router();

const storage = multer.diskStorage({
  destination(req, file, cb) {
    cb(null, 'uploads/');
  },
  filename(req, file, cb) {
    cb(
      null,
      `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`
    );
  },
});

function checkFileType(file, cb) {
  const filetypes = /jpg|jpeg|png/;
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = filetypes.test(file.mimetype);

  if (extname && mimetype) {
    return cb(null, true);
  } else {
    cb('Chỉ cho phép định dạng ảnh (jpg, jpeg, png)!');
  }
}

const upload = multer({
  storage,
  fileFilter: function (req, file, cb) {
    checkFileType(file, cb);
  },
});

router.post('/', protect, upload.single('image'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: 'Không có file nào được tải lên' });
  }
  
  // Trả về đường dẫn tuyệt đối hoặc tương đối tùy cấu hình
  // Ở đây trả về dạng /uploads/filename
  res.send(`/${req.file.path.replace(/\\/g, '/')}`);
});

module.exports = router;
