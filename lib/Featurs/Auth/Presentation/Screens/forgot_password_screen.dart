import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Constants/assets.dart';
import '../../../../Core/Theme/app_palette.dart';
import '../Providers/auth_provider.dart';
import '../Widgets/auth_text_field.dart';
import '../Widgets/auth_back_button.dart';
import '../../../../Core/Widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email.'),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.resetPassword(email);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset link has been sent to your email.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ??
                'Could not send password reset email.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthBackButton(),

              const SizedBox(height: 60),

              Text(
                AppStrings.forgotPasswordTitle,
                style: TextStyle(
                  fontSize: 23.5,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 6),

              Text(
                AppStrings.forgotPasswordSubTitle,
                style: TextStyle(
                  fontSize: 17,
                  color: context.textSecondaryColor,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 40),

              AuthTextField(
                hint: AppStrings.forgotPasswordEmailHint,
                prefixIconPath: AppAssets.user,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),

              const SizedBox(height: 24),

              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return PrimaryButton(
                    label: authProvider.isLoading
                        ? 'Sending...'
                        : AppStrings.forgotPasswordConfirmButton,
                    onPressed: () {
                      if (!authProvider.isLoading) {
                        _resetPassword();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}