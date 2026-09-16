class AppRoutes {
  static const String onboardingScreen = '/onboarding';
  static const String loginScreen = '/signin';
  static const String signupScreen = '/signup';
  static const String forgotpasswordScreen = '/forgotpassword';
  static const String homeScreen = '/home';
  static const String notificationsScreen = '/notifications';
  static const String scheduleScreen = '/schedule';
  static const String addTaskScreen = '/add-task';
  static const String focusModeScreen = '/focus-mode';
  static const String productivityScreen = '/productivity';
  static const String profileScreen = '/profile';
  static const String helpSupportScreen = '/help-support';

  // for me
  static const String debugScreen = '/debug';
}

class FocusModeRouteArgs {
  const FocusModeRouteArgs({
    required this.taskId,
    required this.taskTitle,
  });

  final String taskId;
  final String taskTitle;
}

class NotFoundRouteArgs {
  const NotFoundRouteArgs(this.unknownRoute);

  final String? unknownRoute;
}
