import 'package:dog_app/providers/auth/auth_state.dart';
import 'package:dog_app/screens/main_screen.dart';
import 'package:dog_app/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthState>().authStatus;


    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => authStatus == AuthStatus.authenticated
              ? MainScreen()
              : SigninScreen(),
        ),
            (route) => route.isFirst,
      );
    });
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
