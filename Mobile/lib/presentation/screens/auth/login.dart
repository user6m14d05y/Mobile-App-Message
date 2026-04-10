import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import 'register.dart'; // Import trang đăng ký
import '../../../data/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void _handleLogin() async {
    setState(() => isLoading = true); // Hiện vòng xoay
    try {
      final success = await context.read<AuthProvider>().login(
            emailController.text,
            passwordController.text,
          );

      if (success) {
        print("ĐĂNG NHẬP THÀNH CÔNG!");
        // Không định hướng ở đây vì AuthProvider sẽ tự chuyển sang MainScreen trong MaterialApp
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi: Sai email hoặc mật khẩu!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi thực sự: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false); // Tắt xoay vòng
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FD), // Màu nền tổng thể
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
              
              const Text('Welcome Back', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF223289))),
              const SizedBox(height: 8),
              const Text('Continue your curated conversations.', style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 40),

              // Form
              CustomTextField(
                hintText: 'Email address',
                prefixIcon: Icons.email_outlined,
                controller: emailController,
              ),
              CustomTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: passwordController,
              ),
               
              Align(
                alignment: Alignment.centerRight,
                child: Text('Forgot Password?', style: TextStyle(color: const Color(0xFF3D4AA0), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),

              CustomButton(text: 'Login',
              onPressed: _handleLogin,
              isLoading: isLoading,
              ),

              const SizedBox(height: 32),
              // OR CONNECT WITH
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR CONNECT WITH', style: TextStyle(color: Colors.black38, fontSize: 12)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account? ', style: TextStyle(color: Colors.black54)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                    },
                    child: const Text('Sign Up', style: TextStyle(color: Color(0xFF3D4AA0), fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
