import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    // Dùng Interceptor để tự động gắn Token vào mọi request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Xử lý lỗi chung ở đây (vd: Token hết hạn -> đẩy về màn Login)
          print('API Error: ${e.response?.statusCode} - ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // --- AUTH API ---
  Future<Response> login(String email, String password) async {
    return await _dio.post(AppConstants.loginUrl, data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(String name, String email, String password) async {
    return await _dio.post(AppConstants.registerUrl, data: {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Response> getUserProfile() async {
    return await _dio.get('${AppConstants.baseUrl}/users/profile');
  }

  Future<Response> updateProfile(String name, String? avatarUrl) async {
    return await _dio.put('${AppConstants.baseUrl}/users/profile', data: {
      'name': name,
      'avatar': avatarUrl,
    });
  }

  Future<Response> uploadImageBytes(List<int> bytes, String fileName) async {
    FormData formData = FormData.fromMap({
      "image": MultipartFile.fromBytes(bytes, filename: fileName),
    });

    return await _dio.post('${AppConstants.baseUrl}/upload', data: formData);
  }

  // --- CHAT API ---
  Future<Response> fetchConversations() async {
    return await _dio.get(AppConstants.getConversationsUrl);
  }

  Future<Response> fetchMessages(String conversationId) async {
    return await _dio.get('${AppConstants.messagesUrl}/$conversationId');
  }

  Future<Response> sendMessage(String content, String conversationId) async {
    return await _dio.post(AppConstants.messagesUrl, data: {
      'content': content,
      'conversationId': conversationId,
    });
  }

  Future<Response> searchUsers(String query) async {
    return await _dio.get('${AppConstants.searchUsersUrl}?search=$query');
  }

  Future<Response> createOrGetConversation(String targetUserId) async {
    return await _dio.post(AppConstants.accessConversationUrl, data: {
      'userId': targetUserId,
    });
  }

  // --- FRIENDSHIP API ---
  Future<Response> sendFriendRequest(String receiverId) async {
    return await _dio.post(AppConstants.friendRequestUrl, data: {
      'receiverId': receiverId,
    });
  }

  Future<Response> fetchFriendRequests() async {
    return await _dio.get(AppConstants.friendRequestsUrl);
  }

  Future<Response> respondToFriendRequest(String requestId, String status) async {
    return await _dio.put('${AppConstants.friendRequestUrl}/$requestId', data: {
      'status': status, // 'accepted' or 'rejected'
    });
  }

  Future<Response> fetchFriends() async {
    return await _dio.get(AppConstants.getFriendsUrl);
  }
}
