import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_notifier.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  snackbar(String text, BuildContext context) {
    final snackbar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final TextEditingController registerLogin = TextEditingController();
final TextEditingController registerPass = TextEditingController();

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(''),
        ),
        body: Column(children: [
          const Center(
            child: Text(
              'Sign Up',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          CircleAvatar(
            minRadius: 100,
            maxRadius: 100,
            backgroundColor: Colors.white,
            child: SizedBox(
                height: 100, child: Image.asset('assets/img/user.png')),
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
                  controller: registerLogin,
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
                  controller: registerPass,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Have an Account Already?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: () async {
                        if (registerLogin.text.isEmpty) {
                          widget.snackbar('Enter username!', context);
                        } else if (registerPass.text.isEmpty) {
                          widget.snackbar('Enter password!', context);
                        } else if (registerLogin.text.isNotEmpty &&
                            registerPass.text.isNotEmpty) {
                          await auth.userRegister(context, registerLogin.text,
                              registerPass.text, widget.snackbar);
                          registerLogin.clear();
                          registerPass.clear();
                        }
                      },
                      child: const Text(
                        'Sign Up',
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
