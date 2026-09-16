import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Constants/assets.dart';
import 'package:studia/Core/Routing/routes.dart';
import 'package:studia/Core/Theme/app_palette.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart';
import 'package:studia/Featurs/Auth/Presentation/Widgets/auth_text_field.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password.'),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
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
            authProvider.errorMessage ?? 'Login failed.',
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
              const SizedBox(height: 50),

              Center(
                child: Image.asset(
                  AppAssets.signin,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                AppStrings.signInTitle,
                style: TextStyle(
                  fontSize: 23.5,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 11),

              Text(
                AppStrings.signInSubTitle,
                style: TextStyle(
                  fontSize: 17,
                  color: context.textSecondaryColor,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 40),

              AuthTextField(
                hint: AppStrings.usernameEmailLabel,
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
                    width: 32,
                    height: 32,
                    color: context.textSecondaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.forgotpasswordScreen,
                    );
                  },
                  child: Text(
                    AppStrings.forgetPassword,
                    style: TextStyle(
                      color: context.textSecondaryColor,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),

              SizedBox(
                width: double.infinity,
                height: 42,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed:
                          authProvider.isLoading ? null : _signIn,
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
                              AppStrings.signInBtn,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.signupScreen,
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: AppStrings.dontHaveAccount,
                      style: TextStyle(
                        color: context.textSecondaryColor,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.signUpLink,
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