import 'user_model.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final String conversationId;
  final DateTime createdAt;
  final UserModel? sender;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.conversationId,
    required this.createdAt,
    this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      senderId: json['sender'] is Map ? (json['sender']['_id'] ?? '') : (json['sender'] ?? ''),
      content: json['content'] ?? '',
      conversationId: json['conversation'] is Map ? json['conversation']['_id'] : (json['conversation'] ?? ''),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      sender: json['sender'] is Map ? UserModel.fromJson(json['sender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': senderId,
      'content': content,
      'conversation': conversationId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
