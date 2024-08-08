import 'package:assignment/config/poviders.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/config/routes.dart';
import 'package:assignment/screens/home_screen.dart';
import 'package:assignment/screens/login_screen.dart';
import 'package:assignment/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providerConfig,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: customTheme,
        initialRoute: '/',
        routes: routesConfig,
      ),
    );
  }
}

class AuthStateWidget extends StatelessWidget {
  const AuthStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const LoginScreen();
      }),
    );
  }
}

class AuthStateSignUpWidget extends StatelessWidget {
  const AuthStateSignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const SizedBox.shrink();
      }),
    );
  }
}