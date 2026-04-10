import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  // Khởi tạo: Kiểm tra xem đã login chưa
  Future<void> initAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null) {
      await fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    try {
      final response = await _apiService.getUserProfile();
      if (response.statusCode == 200) {
        _user = UserModel.fromJson(response.data);
        notifyListeners();
      }
    } catch (e) {
      print('Fetch Profile Error: $e');
      logout();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      if (response.statusCode == 200) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        await fetchProfile();
        _isLoading = false;
        return true;
      }
    } catch (e) {
      print('Login Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateUser(String name, String? avatarUrl) async {
    try {
      final response = await _apiService.updateProfile(name, avatarUrl);
      if (response.statusCode == 200) {
        _user = UserModel.fromJson(response.data);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Update Profile Error: $e');
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _user = null;
    notifyListeners();
  }
}
