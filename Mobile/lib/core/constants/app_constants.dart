class AppConstants {
  // Đối với Android Emulator, localhost backend sẽ là 10.0.2.2.
  // Đối với iOS Simulator, localhost là 127.0.0.1.
  // Nếu cắm cáp dùng máy tính thật, bạn đổi thành IP LAN của máy tính (ví dụ: 192.168.1.5)
  // static const String baseUrl = 'http://10.0.2.2:5000/api';
  // static const String socketUrl = 'http://10.0.2.2:5000';

  // static const String baseUrl = 'http://localhost:5000/api';
  // static const String socketUrl = 'http://localhost:5000';

  static const String baseUrl = 'http://192.168.1.19:5000/api';
  static const String socketUrl = 'http://192.168.1.19:5000';

  // API Endpoints
  static const String loginUrl = '/auth/login';
  static const String registerUrl = '/auth/register';
  static const String searchUsersUrl = '/users';
  static const String getConversationsUrl = '/messages/conversations';
  static const String accessConversationUrl = '/messages/conversation';
  static const String messagesUrl = '/messages';

  // Friendship Endpoints
  static const String friendRequestUrl = '/users/friend-request';
  static const String friendRequestsUrl = '/users/friend-requests';
  static const String getFriendsUrl = '/users/friends';
}
