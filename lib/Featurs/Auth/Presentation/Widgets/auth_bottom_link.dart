import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';

class AuthBottomLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthBottomLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
            children: [
              TextSpan(
                text: linkText,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}