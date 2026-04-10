import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../../data/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  // --- DÁN TỪ ĐÂY CHỞ XUỐNG ---
  bool isLoading = false; // Biến xoay vòng vòng
  void _handleRegister() async {
    // Ràng buộc nếu tay người dùng chưa nhập mật khẩu giống nhau
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu nhập lại không khớp!')),
      );
      return; 
    }
    setState(() => isLoading = true); // Hiện vòng xoay
    try {
      final api = ApiService();
      // Gọi API Đăng ký xuống Backend
      final response = await api.register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );
      // Nếu tạo account thành công
      if (response.statusCode == 201) {
        final token = response.data['token'];
        
        // Lưu token vào máy điện thoại
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thành công!'), backgroundColor: Colors.green),
        );
        print("TẠO ACCOUNT THÀNH CÔNG! TOKEN: $token");
        // Tạm thời chưa có màn hình chính, ta để nguyên
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi thực sự: $e')),
      );
    } finally {
      setState(() => isLoading = false); // Tắt vòng xoay
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Button back
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF223289)),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),

              // Logo TBS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D4AA0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('TBS', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 32),
              
              const Text('Create Account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF223289))),
              const SizedBox(height: 8),
              const Text('Join the curated conversation.', style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 40),

              // Form 
              CustomTextField(
                title: 'Full Name',
                hintText: 'Julianne Moore',
                controller: nameController,
              ),
              CustomTextField(
                title: 'Email Address',
                hintText: 'julianne@editorial.com',
                controller: emailController,
              ),
              CustomTextField(
                title: 'Password',
                hintText: '........',
                isPassword: true,
                controller: passwordController,
              ),
              CustomTextField(
                title: 'Confirm Password',
                hintText: '........',
                isPassword: true,
                controller: confirmPasswordController,
              ),

              const SizedBox(height: 13),
              CustomButton(
                text: 'Register',
                onPressed: _handleRegister,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
