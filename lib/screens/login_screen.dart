import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/provider/auth_notifier.dart';
import '../utils/functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final TextEditingController login = TextEditingController();
final TextEditingController password = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(''),
        ),
        body: Column(children: [
          const Center(
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const SizedBox(
            height: 60,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: login,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 250,
                ),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: () async {
                        if (login.text.isEmpty) {
                          snackbar('Enter username!', context);
                        } else if (password.text.isEmpty) {
                          snackbar('Enter password!', context);
                        } else if (login.text.isNotEmpty &&
                            password.text.isNotEmpty) {
                          await auth.userLogin(
                              context, login.text, password.text, snackbar);
                          if (!mounted) return;
                          AuthNotifier().user == null
                              ? null
                              : Navigator.of(context)
                                  .popUntil(((route) => route.isFirst));
                          login.clear();
                          password.clear();
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
