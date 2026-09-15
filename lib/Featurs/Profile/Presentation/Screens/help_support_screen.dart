import 'package:flutter/material.dart';

import 'package:studia/Core/Constants/app_color.dart';
import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Widgets/app_scaffold.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Widget _faqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.primaryCard10Color,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            iconColor: AppColors.primaryColor,
            collapsedIconColor: AppColors.primaryColor,
            title: Text(
              question,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  answer,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
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
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                AppStrings.profileHelpSupport,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                AppStrings.helpSupportFaqTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 14),

              _faqItem(
                AppStrings.helpSupportFaqAddTask,
                AppStrings.helpSupportFaqAddTaskAnswer,
              ),
              _faqItem(
                AppStrings.helpSupportFaqMarkCompleted,
                AppStrings.helpSupportFaqMarkCompletedAnswer,
              ),
              _faqItem(
                AppStrings.helpSupportFaqProductivity,
                AppStrings.helpSupportFaqProductivityAnswer,
              ),
              _faqItem(
                AppStrings.helpSupportFaqEditProfile,
                AppStrings.helpSupportFaqEditProfileAnswer,
              ),
              _faqItem(
                AppStrings.helpSupportFaqChangePassword,
                AppStrings.helpSupportFaqChangePasswordAnswer,
              ),

              const SizedBox(height: 30),

              const Text(
                AppStrings.helpSupportContactTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryCard10Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  AppStrings.helpSupportContactMessage,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
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