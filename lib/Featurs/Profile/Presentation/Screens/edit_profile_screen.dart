import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Theme/app_palette.dart';
import 'package:studia/Core/Widgets/app_scaffold.dart';
import 'package:studia/Core/Widgets/profile_avatar.dart';
import 'package:studia/Featurs/Add_Task/Presentation/Widgets/add_text_.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart' as studia;
import 'package:studia/Featurs/Profile/Presentation/Providers/profile_photo_provider.dart';
import 'package:studia/Core/Widgets/primary_button.dart';

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
    final authUser = firebase.FirebaseAuth.instance.currentUser;
    return (authUser?.displayName ?? '').isNotEmpty ? authUser!.displayName! : '';
  }

  String get _currentEmail {
    final authUser = firebase.FirebaseAuth.instance.currentUser;
    return (authUser?.email ?? '').isNotEmpty ? authUser!.email! : '';
  }

  Future<void> _pickAndUploadPhoto() async {
    final messenger = ScaffoldMessenger.of(context);
    final photoProvider = context.read<ProfilePhotoProvider>();

    final success = await photoProvider.updatePhoto();

    if (!context.mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Profile photo updated.'
              : (photoProvider.errorMessage ?? 'Could not update profile photo.'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoProvider = context.watch<ProfilePhotoProvider>();

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
                AppStrings.profileEditProfile,
style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: context.accentColor,
                ),
                ),
              const SizedBox(height: 24),

              Center(
                child: ProfileAvatar(
                  photoPath: photoProvider.path,
                  size: 110,
                  showEditBadge: true,
                  isUploading: photoProvider.isLoading,
                  onTap: _pickAndUploadPhoto,
                ),
              ),
              const SizedBox(height: 32),

Text(
                AppStrings.usernameLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 8),

              AppTextField(
                hint: AppStrings.usernameLabel,
                controller: _usernameController,
              ),

              const SizedBox(height: 35),

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

              const SizedBox(height: 45),

              Consumer<studia.AuthProvider>(
                builder: (context, authProvider, child) {
                  return PrimaryButton(
                    label: authProvider.isLoading
                        ? 'Saving...'
                        : AppStrings.profileSaveButton,
                    height: 80,
                    onPressed: authProvider.isLoading
                        ? () {}
                        : () async {
                            final username = _usernameController.text.trim();
                            if (username.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a username.'),
                                ),
                              );
                              return;
                            }
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
                          },
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
