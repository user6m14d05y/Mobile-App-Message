# Ứng dụng Nhắn tin TBS (TBS Messaging)

Một ứng dụng nhắn tin thời gian thực mạnh mẽ được xây dựng bằng **Flutter** (Mobile) và **Node.js** (Backend), tích hợp hệ thống kết bạn và xác thực bảo mật.

## Tính năng chính

- **Giao diện hiện đại**: Thiết kế tinh tế với hiệu ứng chuyển động mượt mà.
- **Chat thời gian thực**: Nhắn tin tức thời sử dụng công nghệ Socket.IO.
- **Hệ thống kết bạn**: Tìm kiếm người dùng, gửi lời mời kết bạn và quản lý danh sách bạn bè.
- **Xác thực bảo mật**: Sử dụng JWT cho các chức năng Đăng nhập và Đăng ký.
- **Backend Docker hóa**: Thiết lập toàn bộ Backend và MongoDB chỉ với một câu lệnh.

## Cấu trúc dự án

```text
Message-Mobile/
├── Backend/          # Server Node.js + Express + Socket.IO
├── Mobile/           # Ứng dụng di động Flutter
└── docker-compose.yml # Cấu hình Docker cho toàn bộ hệ thống Backend
```

---

## Hướng dẫn cài đặt

### 1. Yêu cầu hệ thống

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.x trở lên)
- [Node.js](https://nodejs.org/) (tùy chọn, nếu không dùng Docker)
- [Docker & Docker Compose](https://www.docker.com/products/docker-desktop/) (Khuyên dùng)

### 2. Thiết lập Backend (Dùng Docker - Khuyên dùng)

Truy cập thư mục gốc của dự án và chạy:

```bash
docker-compose up -d --build
```

Lệnh này sẽ tự động:
- Khởi chạy API server tại `http://localhost:5000`.
- Khởi chạy một thực thể MongoDB.
- Đồng bộ các thay đổi code của bạn vào container để phát triển dễ dàng.

### 3. Thiết lập Mobile (Flutter)

Truy cập thư mục `Mobile`:

```bash
cd Mobile
flutter pub get
flutter run
```

> [!NOTE]
> Nếu bạn chạy trên **Trình giả lập Android**, hãy đảm bảo `baseUrl` trong file `lib/core/constants/app_constants.dart` được đặt thành `http://10.0.2.2:5000/api`. Đối với bản **Web**, sử dụng `http://localhost:5000/api`.

---

## Tài khoản thử nghiệm

Nếu bạn vừa mới khởi tạo database, bạn có thể tạo tài khoản mới thông qua màn hình **Đăng ký (Sign Up)** trong ứng dụng.

## Đóng góp

1. Fork dự án.
2. Tạo Nhánh tính năng mới (`git checkout -b feature/AmazingFeature`).
3. Commit các thay đổi (`git commit -m 'Add some AmazingFeature'`).
4. Push lên Nhánh (`git push origin feature/AmazingFeature`).
5. Mở một Pull Request.

## Bổ sung hình ảnh

1. cp env.example .env
2. mkdir uploads