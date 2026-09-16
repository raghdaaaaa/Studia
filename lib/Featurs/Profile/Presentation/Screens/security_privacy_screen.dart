import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Constants/assets.dart';
import 'package:studia/Core/Theme/app_palette.dart';
import 'package:studia/Core/Widgets/app_scaffold.dart';
import 'package:studia/Core/Widgets/primary_button.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart';
import 'package:studia/Featurs/Auth/Presentation/Widgets/auth_text_field.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _currentEmail {
    final authUser = FirebaseAuth.instance.currentUser;
    return (authUser?.email ?? '').isNotEmpty ? authUser!.email! : '';
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all password fields.'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match.'),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully.'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Could not change password.',
          ),
        ),
      );
    }
  }

  Widget _passwordField(
    BuildContext context,
    String hint, {
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggleObscure,
  }) {
    return AuthTextField(
      hint: hint,
      prefixIconPath: AppAssets.lock,
      obscureText: obscure,
      controller: controller,
      suffixIcon: IconButton(
        icon: Image.asset(
          AppAssets.hide,
          width: 27,
          height: 27,
          color: context.textSecondaryColor,
        ),
        onPressed: onToggleObscure,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentNavIndex: 4,
      showFab: false,
      showBottomNav: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
child: Icon(
                  Icons.arrow_back_ios,
                  color: context.accentColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 16),

Text(
                AppStrings.profileSecurityPrivacy,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 24),

Text(
                AppStrings.signUpEmailLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 14),

              Text(
                _currentEmail,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondaryColor,
                ),
              ),

              const SizedBox(height: 35),

Text(
                AppStrings.securityCurrentPassword,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 8),

              _passwordField(
                context,
                AppStrings.securityCurrentPassword,
                controller: _currentPasswordController,
                obscure: _obscureCurrentPassword,
                onToggleObscure: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),

              const SizedBox(height: 24),

Text(
                AppStrings.securityNewPassword,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 8),

              _passwordField(
                context,
                AppStrings.securityNewPassword,
                controller: _newPasswordController,
                obscure: _obscureNewPassword,
                onToggleObscure: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),

              const SizedBox(height: 24),

Text(
                AppStrings.securityConfirmPassword,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 8),

              _passwordField(
                context,
                AppStrings.securityConfirmPassword,
                controller: _confirmPasswordController,
                obscure: _obscureConfirmPassword,
                onToggleObscure: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),

              const SizedBox(height: 45),

              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return PrimaryButton(
                    label: authProvider.isLoading
                        ? 'Changing...'
                        : AppStrings.securityChangePassword,
                    height: 80,
                    onPressed: authProvider.isLoading ? () {} : _changePassword,
                  );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
