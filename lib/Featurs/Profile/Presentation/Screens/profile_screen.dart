import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studia/Core/Constants/app_color.dart';
import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Constants/assets.dart';
import 'package:studia/Core/Theme/app_palette.dart';
import 'package:studia/Core/Theme/theme_provider.dart';
import 'package:studia/Core/Widgets/app_scaffold.dart';
import 'package:studia/Core/Widgets/profile_avatar.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart';
import 'package:studia/Featurs/Profile/Presentation/Providers/profile_photo_provider.dart';
import 'package:studia/Featurs/Profile/Presentation/Screens/edit_profile_screen.dart';
import 'package:studia/Featurs/Profile/Presentation/Screens/help_support_screen.dart';
import 'package:studia/Featurs/Profile/Presentation/Screens/security_privacy_screen.dart';
import '../Widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppStrings.profileThemeLight;
      case ThemeMode.dark:
        return AppStrings.profileThemeDark;
      case ThemeMode.system:
        return AppStrings.profileThemeSystemDefault;
    }
  }

  Future<void> _pickAndUploadPhoto(BuildContext context) async {
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

  void _showThemePicker(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.elevatedCardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.profileAppTheme,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: context.accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                _buildThemeOption(
                  sheetContext,
                  themeProvider,
                  ThemeMode.light,
                  AppStrings.profileThemeLight,
                ),
                _buildThemeOption(
                  sheetContext,
                  themeProvider,
                  ThemeMode.dark,
                  AppStrings.profileThemeDark,
                ),
                _buildThemeOption(
                  sheetContext,
                  themeProvider,
                  ThemeMode.system,
                  AppStrings.profileThemeSystemDefault,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeMode mode,
    String label,
  ) {
    final isSelected = themeProvider.themeMode == mode;

    return GestureDetector(
      onTap: () {
        themeProvider.setThemeMode(mode);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: context.accentColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final photoProvider = context.watch<ProfilePhotoProvider>();
    final authUser = authProvider.user ?? FirebaseAuth.instance.currentUser;
    final displayName = (authUser?.displayName ?? '').isNotEmpty
        ? authUser!.displayName!
        : authUser?.email?.split('@').first ?? '';
    final email = (authUser?.email ?? '').isNotEmpty
        ? authUser!.email!
        : AppStrings.profileUserEmail;

    return AppScaffold(
      currentNavIndex: 4,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 50,
          ),
          child: Column(
            children: [
              ProfileAvatar(
                photoPath: photoProvider.path,
                showEditBadge: true,
                isUploading: photoProvider.isLoading,
                onTap: () => _pickAndUploadPhoto(context),
              ),
              const SizedBox(height: 18),

              Text(
                displayName,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                email,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: context.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 37),

              ProfileMenuItem(
                icon: AppAssets.edit,
                title: AppStrings.profileEditProfile,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              ProfileMenuItem(
                icon: AppAssets.secure,
                title: AppStrings.profileSecurityPrivacy,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SecurityPrivacyScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              ProfileMenuItem(
                icon: AppAssets.theme,
                title: AppStrings.profileAppTheme,
                trailingLabel: _themeLabel(context.watch<ThemeProvider>().themeMode),
                onTap: () => _showThemePicker(context),
              ),
              const SizedBox(height: 14),

              ProfileMenuItem(
                icon: AppAssets.help,
                title: AppStrings.profileHelpSupport,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await context.read<AuthProvider>().logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: Image.asset(
                    AppAssets.logout,
                    width: 20,
                    height: 20,
                    color: AppColors.white,
                  ),
                  label: const Text(
                    AppStrings.profileLogout,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}