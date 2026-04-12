# Sử dụng phiên bản Node.js nhẹ nhàng thay vì bản full
FROM node:24-alpine
# Thư mục làm việc bên trong container
WORKDIR /app
# Copy 2 file package vào trước để cài thư viện
COPY package*.json ./
# Cài đặt thư viện
RUN npm install
# Copy toàn bộ code vào
COPY . .
# Mở port 5000 ra cho môi trường bên ngoài thấy
EXPOSE 5000
# Lệnh khởi chạy server (dùng node thay vì nodemon cho production)
CMD ["npm", "run", "dev"]