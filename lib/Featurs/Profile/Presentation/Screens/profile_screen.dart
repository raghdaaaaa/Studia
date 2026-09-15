import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studia/Core/Constants/app_color.dart';
import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Constants/assets.dart';
import 'package:studia/Core/Routing/routes.dart';
import 'package:studia/Core/Theme/theme_provider.dart';
import 'package:studia/Core/Widgets/app_scaffold.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart';
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

  void _showThemePicker(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
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
                const Text(
                  AppStrings.profileAppTheme,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: AppColors.primaryColor,
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
          color: AppColors.primaryCard10Color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: AppColors.primaryColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser ??
        context.watch<AuthProvider>().user;
    final displayName = (authUser?.displayName ?? '').isNotEmpty
        ? authUser!.displayName!
        : AppStrings.profileUserName;
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
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Image.asset(
                    AppAssets.profilePic,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Text(
                displayName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                email,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textSecondary,
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

                    if (!context.mounted) return;

                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.loginScreen,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
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