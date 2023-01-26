import 'package:darkchat_app/widgets/main/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'widgets/provider/auth_notifier.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/signup_screen.dart';
import './theme/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ChangeNotifierProvider<AuthNotifier>(
      create: (_) => AuthNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightTheme,
        title: ('DarkChat'),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
        },
        home: const Home(),
      ),
    );
  }
}
