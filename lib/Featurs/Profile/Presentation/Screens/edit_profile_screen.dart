import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studia/Core/Constants/app_color.dart';
import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Widgets/app_scaffold.dart';
import 'package:studia/Core/Widgets/primary_button.dart';
import 'package:studia/Featurs/Add_Task/Presentation/Widgets/add_text_.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: _currentDisplayName);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  String get _currentDisplayName {
    final authUser = FirebaseAuth.instance.currentUser;
    return (authUser?.displayName ?? '').isNotEmpty ? authUser!.displayName! : '';
  }

  String get _currentEmail {
    final authUser = FirebaseAuth.instance.currentUser;
    return (authUser?.email ?? '').isNotEmpty ? authUser!.email! : '';
  }

  Future<void> _save() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a username.'),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.updateDisplayName(username);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated.'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Could not update username.',
          ),
        ),
      );
    }
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
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                AppStrings.profileEditProfile,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                AppStrings.usernameLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              AppTextField(
                hint: AppStrings.usernameLabel,
                controller: _usernameController,
              ),

              const SizedBox(height: 35),

              const Text(
                AppStrings.signUpEmailLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 14),

              Text(
                _currentEmail,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 45),

              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return PrimaryButton(
                    label: authProvider.isLoading
                        ? 'Saving...'
                        : AppStrings.profileSaveButton,
                    height: 80,
                    onPressed: authProvider.isLoading ? () {} : _save,
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