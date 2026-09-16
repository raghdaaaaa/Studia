import 'package:flutter/material.dart';
import 'package:studia/Core/Theme/app_palette.dart';
import 'package:studia/Featurs/Onboarding/Data/Models/onboarding_model.dart';

class OnboardingBody extends StatelessWidget {
  final OnboardingModel data;
  final int currentPage;
  final int totalPages;

  const OnboardingBody({
    super.key,
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Large Top Margin
          SizedBox(height: screenHeight * 0.12),

          // 2. Centered Illustration with comfortable side margins
          SizedBox(
            height: screenHeight * 0.32,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Image.asset(
                data.image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 60),

          // 3. Dots indicator
          _buildDots(context),

          const SizedBox(height: 50),

          // 4. Texts section with Poppins Font
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: context.accentColor,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  data.desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: context.accentColor,
                    height: 1.4,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: currentPage == index
                ? context.accentColor
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: context.accentColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}