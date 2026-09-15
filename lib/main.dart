import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studia/Core/Routing/router.dart';
import 'package:studia/Core/Routing/routes.dart';
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
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRoutes.onboardingScreen,
      ),
    );
  }
}