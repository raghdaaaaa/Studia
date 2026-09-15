import 'package:studia/Core/Constants/app_strings.dart';
import 'package:studia/Core/Constants/assets.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String desc;

  const OnboardingModel({
    required this.image,
    required this.title,
    required this.desc,
  });

  static List<OnboardingModel> onboardingList = [
    const OnboardingModel(
      image: AppAssets.onboarding1,
      title: AppStrings.onboardingTitle1,
      desc: AppStrings.onboardingDesc1,
    ),
    const OnboardingModel(
      image: AppAssets.onboarding2,
      title: AppStrings.onboardingTitle2,
      desc: AppStrings.onboardingDesc2,
    ),
    const OnboardingModel(
      image: AppAssets.onboarding3,
      title: AppStrings.onboardingTitle3,
      desc: AppStrings.onboardingDesc3,
    ),
  ];
}
