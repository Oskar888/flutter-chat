import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_notifier.dart';
import '/screens/home_screen.dart';
import '/screens/signup_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, _) {
        if (authNotifier.user == null) {
          return const SignUpScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
