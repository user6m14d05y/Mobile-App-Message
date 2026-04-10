import 'package:flutter/material.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/friend_request_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/socket_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SocketService _socketService = SocketService();

  List<ConversationModel> _conversations = [];
  List<MessageModel> _messages = [];
  List<FriendRequestModel> _friendRequests = [];
  List<UserModel> _friends = [];
  bool _isLoading = false;

  List<ConversationModel> get conversations => _conversations;
  List<MessageModel> get messages => _messages;
  List<FriendRequestModel> get friendRequests => _friendRequests;
  List<UserModel> get friends => _friends;
  bool get isLoading => _isLoading;

  // --- CONVERSATIONS ---
  Future<void> fetchConversations() async {
    _isLoading = true;
    try {
      final response = await _apiService.fetchConversations();
      if (response.statusCode == 200) {
        _conversations = (response.data as List)
            .map((c) => ConversationModel.fromJson(c))
            .toList();
      }
    } catch (e) {
      print('Fetch Conversations Error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // --- MESSAGES ---
  Future<void> fetchMessages(String conversationId) async {
    _messages = [];
    notifyListeners();
    try {
      final response = await _apiService.fetchMessages(conversationId);
      if (response.statusCode == 200) {
        _messages = (response.data as List)
            .map((m) => MessageModel.fromJson(m))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Fetch Messages Error: $e');
    }
  }

  void addMessage(MessageModel message) {
    _messages.add(message);
    notifyListeners();
  }

  // --- FRIENDSHIP ---
  Future<void> fetchFriends() async {
    try {
      final response = await _apiService.fetchFriends();
      if (response.statusCode == 200) {
        _friends = (response.data as List)
            .map((u) => UserModel.fromJson(u))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Fetch Friends Error: $e');
    }
  }

  Future<void> fetchFriendRequests() async {
    try {
      final response = await _apiService.fetchFriendRequests();
      if (response.statusCode == 200) {
        _friendRequests = (response.data as List)
            .map((r) => FriendRequestModel.fromJson(r))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Fetch Friend Requests Error: $e');
    }
  }

  // --- SOCKETS ---
  void initSocket(UserModel user) {
    _socketService.connect(user);
    _socketService.onMessageReceived((data) {
      final newMessage = MessageModel.fromJson(data);
      addMessage(newMessage);
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }
}
