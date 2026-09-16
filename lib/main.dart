import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:studia/Core/Routing/router.dart';
import 'package:studia/Core/Routing/routes.dart';
import 'package:studia/Core/Theme/app_theme.dart';
import 'package:studia/Core/Theme/theme_provider.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart';
import 'package:studia/Featurs/Profile/Presentation/Providers/profile_photo_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (_) {}

  runApp(const Studia());
}

class Studia extends StatelessWidget {
  const Studia({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfilePhotoProvider()),
      ],
      child: _AuthObserver(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRouter.generateRoute,
              navigatorKey: _AuthObserver.navigatorKey,
              initialRoute: FirebaseAuth.instance.currentUser != null
                  ? AppRoutes.homeScreen
                  : AppRoutes.onboardingScreen,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
            );
          },
        ),
      ),
    );
  }
}

class _AuthObserver extends StatefulWidget {
  const _AuthObserver({required this.child});

  final Widget child;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<_AuthObserver> createState() => _AuthObserverState();
}

class _AuthObserverState extends State<_AuthObserver> {
  AuthProvider? _authProvider;
  bool _hadUser = false;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    _hadUser = _authProvider!.user != null;
    _authProvider!.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authProvider?.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    final hasUser = _authProvider!.user != null;

    if (_hadUser && !hasUser) {
      final navigator = _AuthObserver.navigatorKey.currentState;
      navigator?.pushNamedAndRemoveUntil(
        AppRoutes.loginScreen,
        (route) => false,
      );
    }

    _hadUser = hasUser;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}