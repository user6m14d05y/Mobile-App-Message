import 'user_model.dart';
import 'message_model.dart';

class ConversationModel {
  final String id;
  final String? chatName;
  final bool isGroupChat;
  final List<UserModel> users;
  final MessageModel? latestMessage;
  final UserModel? groupAdmin;

  ConversationModel({
    required this.id,
    this.chatName,
    required this.isGroupChat,
    required this.users,
    this.latestMessage,
    this.groupAdmin,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'] ?? '',
      chatName: json['chatName'],
      isGroupChat: json['isGroupChat'] ?? false,
      users: (json['users'] as List?)
              ?.map((u) => UserModel.fromJson(u))
              .toList() ??
          [],
      latestMessage: json['latestMessage'] != null
          ? MessageModel.fromJson(json['latestMessage'])
          : null,
      groupAdmin: json['groupAdmin'] != null
          ? UserModel.fromJson(json['groupAdmin'])
          : null,
    );
  }
}
