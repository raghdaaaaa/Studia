import 'package:flutter/material.dart';
import './routes.dart';
import '../../../Featurs/Onboarding/Presentation/Screens/onboarding_screen.dart';
import '../../../Featurs/Auth/Presentation/Screens/signin_screen.dart';
import '../../../Featurs/Auth/Presentation/Screens/signup_screen.dart';
import '../../../Featurs/Auth/Presentation/Screens/forgot_password_screen.dart';
import '../../../Featurs/Auth/Presentation/Screens/otp_screen.dart';
import '../../../Featurs/Home/Presentation/Screens/home_screen.dart';
import '../../../Featurs/Schedule/Presentation/Screens/schedule_screen.dart';
import '../../../Featurs/Add_Task/Presentation/Screens/add_task_screen.dart';
import '../../../Featurs/Productivity/Presentation/Screens/productivity_screen.dart';
import '../../../Featurs/Profile/Presentation/Screens/profile_screen.dart';
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

case AppRoutes.otpScreen:
return MaterialPageRoute(builder: (_) => const OtpScreen());

case AppRoutes.homeScreen:
return MaterialPageRoute(builder: (_) => const HomeScreen());

case AppRoutes.scheduleScreen:
return MaterialPageRoute(builder: (_) => const ScheduleScreen());

case AppRoutes.addTaskScreen:
return MaterialPageRoute(builder: (_) => const AddTaskScreen());

case AppRoutes.productivityScreen:
return MaterialPageRoute(builder: (_) => const ProductivityScreen());

case AppRoutes.profileScreen:
return MaterialPageRoute(builder: (_) => const ProfileScreen());

 case AppRoutes.debugScreen:
return MaterialPageRoute(builder: (_) => const DebugScreen());

default:
return MaterialPageRoute(builder: (_) => const HomeScreen());
}
}
}
