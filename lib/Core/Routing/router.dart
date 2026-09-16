import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './routes.dart';
import '../../../Core/Constants/app_color.dart';
import '../../../Core/Theme/app_palette.dart';
import '../../../Featurs/Onboarding/Presentation/Screens/onboarding_screen.dart';
import '../../../Featurs/Auth/Presentation/Screens/signin_screen.dart';
import '../../../Featurs/Auth/Presentation/Screens/signup_screen.dart';
import '../../../Featurs/Auth/Presentation/Screens/forgot_password_screen.dart';

import '../../../Featurs/Home/Presentation/Screens/home_screen.dart';
import '../../../Featurs/Home/Presentation/Screens/notifications_screen.dart';
import '../../../Featurs/Schedule/Presentation/Screens/schedule_screen.dart';
import '../../../Featurs/Add_Task/Presentation/Screens/add_task_screen.dart';
import '../../../Featurs/Focus%20Mode/Presentation/Screens/focus_mode_screen.dart';
import '../../../Featurs/Productivity/Presentation/Screens/productivity_screen.dart';
import '../../../Featurs/Profile/Presentation/Screens/profile_screen.dart';
import '../../../Featurs/Profile/Presentation/Screens/help_support_screen.dart';
import '../../debug_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => const SigninScreen());

      case AppRoutes.signupScreen:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.forgotpasswordScreen:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.notificationsScreen:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case AppRoutes.scheduleScreen:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());

      case AppRoutes.addTaskScreen:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());

      case AppRoutes.focusModeScreen:
        final args = settings.arguments as FocusModeRouteArgs?;
        return MaterialPageRoute(
          builder: (_) => FocusModeScreen(
            taskId: args?.taskId ?? '',
            taskTitle: args?.taskTitle ?? '',
          ),
        );

      case AppRoutes.productivityScreen:
        return MaterialPageRoute(builder: (_) => const ProductivityScreen());

      case AppRoutes.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.helpSupportScreen:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());

      case AppRoutes.debugScreen:
        if (kDebugMode) {
          return MaterialPageRoute(builder: (_) => const DebugScreen());
        }
        return _notFound(settings);

      default:
        return _notFound(settings);
    }
  }

  static Route<dynamic> _notFound(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => _NotFoundScreen(
        unknownRoute: settings.name,
      ),
      settings: RouteSettings(name: '/not-found'),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({this.unknownRoute});

  final String? unknownRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDarkMode
          ? AppColors.darkBackground
          : AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Page not found',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: context.accentColor,
              ),
            ),
            const SizedBox(height: 8),
            if (unknownRoute != null && unknownRoute!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'No route matches "$unknownRoute".',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: context.textSecondaryColor,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeScreen,
                (route) => false,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Go to home',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
