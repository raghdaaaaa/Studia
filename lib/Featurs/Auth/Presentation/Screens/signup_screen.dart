import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studia/Core/Constants/app_color.dart';
import 'package:studia/Core/Theme/app_palette.dart';
import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Constants/assets.dart';
import 'package:studia/Core/Routing/routes.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart';
import 'package:studia/Featurs/Auth/Presentation/Widgets/auth_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your username, email and password.'),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.signUp(
      username: username,
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.homeScreen,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Sign up failed.',
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
              const SizedBox(height: 30),

              Center(
                child: Image.asset(
                  AppAssets.signup,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                AppStrings.signUpTitle,
                style: TextStyle(
                  fontSize: 23.5,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                AppStrings.signUpSubTitle,
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 45),

              AuthTextField(
                hint: AppStrings.usernameLabel,
                prefixIconPath: AppAssets.user,
                controller: _usernameController,
              ),

              const SizedBox(height: 16),

              AuthTextField(
                hint: AppStrings.signUpEmailLabel,
                prefixIconPath: AppAssets.user,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),

              const SizedBox(height: 16),

              AuthTextField(
                hint: AppStrings.passwordHint,
                prefixIconPath: AppAssets.lock,
                obscureText: _obscurePassword,
                controller: _passwordController,
                suffixIcon: IconButton(
                  icon: Image.asset(
                    AppAssets.hide,
                    width: 27,
                    height: 27,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.reminderMe,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: _rememberMe,
                      onChanged: (val) {
                        setState(() {
                          _rememberMe = val;
                        });
                      },
                      activeThumbColor: Colors.white,
                      activeTrackColor: context.primaryColor,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 80),

              SizedBox(
                width: double.infinity,
                height: 42,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed:
                          authProvider.isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              AppStrings.signUpBtn,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.loginScreen,
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.alreadyHaveAccount,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextSpan(
                          text: AppStrings.signInLink,
                          style: TextStyle(
                            color: context.textPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}