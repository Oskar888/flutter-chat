import 'package:darkchat_app/utils/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../screens/chat_screen.dart';
import '../../utils/functions.dart';

class BottomsheetButton extends StatefulWidget {
  const BottomsheetButton({super.key});

  addChat(String username, BuildContext context,
      TextEditingController userSearch) async {
    try {
      await FirebaseAuth.instance
          .fetchSignInMethodsForEmail('$username@gmail.com')
          .then((value) => value.isNotEmpty
              ? {
                  chatUsername = username.capitalize(),
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(chatUsername)))
                }
              : {
                  snackbar('User not found!', context),
                  userSearch.clear(),
                  Navigator.of(context).pop(),
                });
    } catch (error) {
      return true;
    }
  }

  @override
  State<BottomsheetButton> createState() => _BottomsheetButtonState();
}

TextEditingController userSearch = TextEditingController();
late String chatUsername;

class _BottomsheetButtonState extends State<BottomsheetButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        controller: userSearch,
                        decoration: const InputDecoration(
                            hintText: 'Type friend\'s name...'),
                      ),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: userSearch,
                        builder: (context, value, child) {
                          return SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: value.text.isNotEmpty
                                    ? () {
                                        if (userSearch.text !=
                                            getMyUsername()) {
                                          widget.addChat(userSearch.text,
                                              context, userSearch);
                                        } else {
                                          snackbar(
                                              'You cannot chat with yourself!',
                                              context);
                                          userSearch.clear();
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    : null,
                                child: const Text('Add')),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: const Icon(Icons.add),
    );
  }
}
