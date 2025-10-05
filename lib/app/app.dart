import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../splash/splash_gate.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../app/home_shell.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Klarifikasi.id',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routes: {
          '/': (context) => const SplashGate(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomeShell(),
        },
        initialRoute: '/',
      ),
    );
  }
}
