import 'user_model.dart';

class FriendRequestModel {
  final String id;
  final UserModel sender;
  final String receiverId;
  final String status;
  final DateTime createdAt;

  FriendRequestModel({
    required this.id,
    required this.sender,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      id: json['_id'] ?? '',
      sender: UserModel.fromJson(json['sender']),
      receiverId: json['receiver'] is Map ? json['receiver']['_id'] : json['receiver'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
