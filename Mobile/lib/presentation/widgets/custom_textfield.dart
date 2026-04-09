import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final String? title;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.isPassword = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black38),
              prefixIcon: prefixIcon != null 
                  ? Icon(prefixIcon, color: Colors.black45) 
                  : const SizedBox(width: 16),
              suffixIcon: isPassword 
                  ? const Icon(Icons.remove_red_eye_outlined, color: Colors.black26) 
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 16, 
                horizontal: prefixIcon != null ? 12 : 16
              ),
            ),
          ),
        ),
      ],
    );
  }
}