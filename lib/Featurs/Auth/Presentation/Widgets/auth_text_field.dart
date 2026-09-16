import 'package:flutter/material.dart';
import 'package:studia/Core/Theme/app_palette.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final String? prefixIconPath;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.hint,
    this.prefixIconPath,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: context.fieldFillColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: context.textPrimaryColor,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: prefixIconPath != null
                ? Image.asset(prefixIconPath!, width: 17, height: 17)
                : const SizedBox.shrink(),
          ),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: TextStyle(
            color: context.textSecondaryColor,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}