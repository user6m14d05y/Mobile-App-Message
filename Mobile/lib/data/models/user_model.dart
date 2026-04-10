import '../../core/constants/app_constants.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final bool isOnline;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.isOnline = false,
    this.token,
  });

  String get fullAvatarUrl {
    if (avatar.startsWith('http')) return avatar;
    
    // Normalize path to handle "image.jpg", "/uploads/image.jpg", "uploads/image.jpg"
    String pivot = avatar;
    if (pivot.startsWith('/')) pivot = pivot.substring(1);
    
    if (!pivot.startsWith('uploads/')) {
      pivot = 'uploads/$pivot';
    }
    
    return '${AppConstants.socketUrl}/$pivot';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    bool? isOnline,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      token: token ?? this.token,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? 'https://icon-library.com/images/anonymous-avatar-icon/anonymous-avatar-icon-25.jpg',
      isOnline: json['isOnline'] ?? false,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'isOnline': isOnline,
      'token': token,
    };
  }
}
