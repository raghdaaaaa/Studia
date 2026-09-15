import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studia/Core/Routing/router.dart';
import 'package:studia/Core/Routing/routes.dart';
import 'package:studia/Core/Theme/app_theme.dart';
import 'package:studia/Core/Theme/theme_provider.dart';
import 'package:studia/Featurs/Auth/Presentation/Providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('FIREBASE OK');
  } catch (e) {
    print('FIREBASE ERROR: $e');
  }

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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.onboardingScreen,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }
}