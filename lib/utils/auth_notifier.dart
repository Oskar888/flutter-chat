import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthNotifier with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user = FirebaseAuth.instance.currentUser;

  User? get user => _user;

  void logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  userLogin(BuildContext context, String login, String password,
      dynamic snackbar) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: '$login@gmail.com', password: password);
      _user = user.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackbar('User not found!', context);
      } else if (e.code == 'wrong-password') {
        snackbar('Wrong password!', context);
      } else if (e.code == 'network-request-failed') {
        snackbar('Network connection error!', context);
      }
    }
  }

  userRegister(BuildContext context, String registerLogin, String registerPass,
      dynamic snackbar) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '$registerLogin@gmail.com',
        password: registerPass,
      );
      _user = user.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackbar('Password is too weak!', context);
      } else if (e.code == 'email-already-in-use') {
        snackbar('The account already exist for that username!', context);
      } else if (e.code == 'network-request-failed') {
        snackbar('Network connection error!', context);
      }
    }
  }
}
