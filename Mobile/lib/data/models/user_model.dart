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
