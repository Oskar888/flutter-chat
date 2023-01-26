import 'package:darkchat_app/utils/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

getMyUsername() {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? user = auth.currentUser;
  String? usernameWithEmail = user!.email;
  String myUsername =
      usernameWithEmail!.substring(0, usernameWithEmail.indexOf('@'));

  return myUsername.capitalize();
}

snackbar(String text, BuildContext context) {
  final snackbar = SnackBar(
    content: Text(text),
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

String getChatRoomIdByUserId(String myUserID, String peerID) {
  return myUserID.hashCode <= peerID.hashCode
      ? '${myUserID}_$peerID'
      : '${peerID}_$myUserID';
}
