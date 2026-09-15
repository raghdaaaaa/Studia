import 'package:flutter/material.dart';
import '../../../../Core/Constants/app_color.dart';
import '../../../../Core/Constants/app_strings.dart';
import '../../../../Core/Routing/routes.dart';
import '../Widgets/onboarding_body.dart';
import '../../../../Core/Widgets/primary_button.dart';
import '../../Data/Models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingModel> _models = OnboardingModel.onboardingList;

  void _goToNext() {
    if (_currentPage < _models.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _models.length,
                itemBuilder: (context, index) => OnboardingBody(
                  data: _models[index],
                  currentPage: index,
                  totalPages: _models.length,
                ),
              ),
            ),
            _buildButtons(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    final isLast = _currentPage == _models.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: isLast
          ? Center(
        child: PrimaryButton(
          label: AppStrings.start,
          onPressed: _navigateToLogin,
          width: 140,
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _navigateToLogin,
            child: const Text(
              AppStrings.skip,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          PrimaryButton(
            label: AppStrings.next,
            onPressed: _goToNext,
            width: 140,
          ),
        ],
      ),
    );
  }
}