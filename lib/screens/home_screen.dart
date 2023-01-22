import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkchat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../auth_notifier.dart';
import '../extensions/string_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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

  getMyUsername() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String? usernameWithEmail = user!.email;
    String myUsername =
        usernameWithEmail!.substring(0, usernameWithEmail.indexOf('@'));

    return myUsername.capitalize();
  }

  timestampFormat(document) {
    Timestamp timestamp = document;
    DateTime date = timestamp.toDate();
    return (date.toString());
  }

  snackbar(String text, BuildContext context) {
    final snackbar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TextEditingController userSearch = TextEditingController();

late String chatUsername;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthNotifier>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => print('123'), child: const Text('Edit')),
                  Text('Hi! ${widget.getMyUsername()}'),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                          icon: const Icon(Icons.logout_outlined),
                          onPressed: () {
                            auth.logout();
                          }),
                    ],
                  ),
                ],
              )),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: const [
                        Text('Chats',
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .where('users',
                                arrayContains: widget.getMyUsername())
                            .orderBy('created', descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            Set<String> processedChatIds = {};
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (ctx, index) {
                                  String fullSizeMsg = snapshot
                                      .data!.docs[index]['message']
                                      .toString();
                                  String shortenedMsg = fullSizeMsg.substring(
                                      0,
                                      fullSizeMsg.length <= 15
                                          ? fullSizeMsg.length
                                          : 15);
                                  final chatId =
                                      snapshot.data!.docs[index]['chatID'];
                                  if (processedChatIds.contains(chatId)) {
                                    return Container();
                                  } else {
                                    processedChatIds.add(chatId);
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              snapshot.data!.docs[index]
                                                          ['sender'] ==
                                                      widget.getMyUsername()
                                                  ? snapshot.data!.docs[index]
                                                      ['receiver']
                                                  : snapshot.data!.docs[index]
                                                      ['sender'],
                                            ),
                                          ));
                                        },
                                        child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 206),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                snapshot.data!.docs[index]
                                                            ['sender'] ==
                                                        widget.getMyUsername()
                                                    ? Text(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['receiver'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )
                                                    : Text(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['sender'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                Row(
                                                  children: [
                                                    snapshot.data!.docs[index]
                                                                ['sender'] ==
                                                            widget
                                                                .getMyUsername()
                                                        ? shortenedMsg ==
                                                                fullSizeMsg
                                                            ? Text(
                                                                'Me: $shortenedMsg',
                                                              )
                                                            : Text(
                                                                'Me: $shortenedMsg...',
                                                              )
                                                        : shortenedMsg ==
                                                                fullSizeMsg
                                                            ? Text(shortenedMsg)
                                                            : Text(
                                                                '$shortenedMsg...'),
                                                    const Spacer(),
                                                    snapshot.data!.docs[index]
                                                                ['created'] !=
                                                            null
                                                        ? Text(
                                                            widget.timestampFormat(
                                                                snapshot.data!
                                                                            .docs[
                                                                        index][
                                                                    'created']),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  }
                                });
                          }
                          return const SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              strokeWidth: 5,
                            ),
                          );
                        }),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                                        widget
                                                            .getMyUsername()) {
                                                      widget.addChat(
                                                          userSearch.text,
                                                          context,
                                                          userSearch);
                                                    } else {
                                                      widget.snackbar(
                                                          'You cannot chat with yourself!',
                                                          context);
                                                      userSearch.clear();
                                                      Navigator.of(context)
                                                          .pop();
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
                ),
              ],
            ),
          )),
    );
  }
}
