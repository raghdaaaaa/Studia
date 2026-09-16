import 'package:flutter/material.dart';

import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Theme/app_palette.dart';
import 'package:studia/Core/Widgets/app_scaffold.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Widget _faqItem(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: context.surfaceColor,
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
            iconColor: context.accentColor,
            collapsedIconColor: context.accentColor,
            title: Text(
              question,
style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: context.accentColor,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  answer,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.textSecondaryColor,
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
child: Icon(
                  Icons.arrow_back_ios,
                  color: context.accentColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                AppStrings.profileHelpSupport,
style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: context.accentColor,
                ),
                ),
              const SizedBox(height: 24),

Text(
                AppStrings.helpSupportFaqTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(height: 14),

              _faqItem(
                context,
                AppStrings.helpSupportFaqAddTask,
                AppStrings.helpSupportFaqAddTaskAnswer,
              ),
              _faqItem(
                context,
                AppStrings.helpSupportFaqMarkCompleted,
                AppStrings.helpSupportFaqMarkCompletedAnswer,
              ),
              _faqItem(
                context,
                AppStrings.helpSupportFaqProductivity,
                AppStrings.helpSupportFaqProductivityAnswer,
              ),
              _faqItem(
                context,
                AppStrings.helpSupportFaqEditProfile,
                AppStrings.helpSupportFaqEditProfileAnswer,
              ),
              _faqItem(
                context,
                AppStrings.helpSupportFaqChangePassword,
                AppStrings.helpSupportFaqChangePasswordAnswer,
              ),

              const SizedBox(height: 30),

Text(
                AppStrings.helpSupportContactTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.accentColor,
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
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  AppStrings.helpSupportContactMessage,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.textSecondaryColor,
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
