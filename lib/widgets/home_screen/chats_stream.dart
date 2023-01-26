import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkchat_app/utils/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/screens/chat_screen.dart';

class ChatsStream extends StatelessWidget {
  const ChatsStream({super.key});

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
    String hourDate = DateFormat.Hm().format(date);
    String dayDate = DateFormat.E().format(date);
    String monthDayDate = DateFormat.MMMMd().format(date);

    var currentDateTime = DateTime.now();

    if (currentDateTime.difference(date).inHours < 24) {
      return hourDate.toString();
    } else if (currentDateTime.difference(date).inDays < 7) {
      return dayDate.toString();
    } else {
      return monthDayDate.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('users', arrayContains: getMyUsername())
            .orderBy('created', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            Set<String> processedChatIds = {};
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  String fullSizeMsg =
                      snapshot.data!.docs[index]['message'].toString();
                  String shortenedMsg = fullSizeMsg.substring(
                      0, fullSizeMsg.length <= 26 ? fullSizeMsg.length : 26);
                  final chatId = snapshot.data!.docs[index]['chatID'];
                  if (processedChatIds.contains(chatId)) {
                    return Container();
                  } else {
                    processedChatIds.add(chatId);
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) {
                        FirebaseFirestore.instance
                            .collection('messages')
                            .where('chatID',
                                isEqualTo: snapshot.data!.docs[index]['chatID'])
                            .get()
                            .then((querySnapshot) {
                          for (var doc in querySnapshot.docs) {
                            doc.reference.delete();
                          }
                        });
                      },
                      key: UniqueKey(),
                      background: Container(
                        margin: const EdgeInsets.all(4),
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                snapshot.data!.docs[index]['sender'] ==
                                        getMyUsername()
                                    ? snapshot.data!.docs[index]['receiver']
                                    : snapshot.data!.docs[index]['sender'],
                              ),
                            ));
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 191, 191, 191),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    minRadius: 25,
                                    maxRadius: 25,
                                    backgroundColor: Colors.white,
                                    child: SizedBox(
                                        height: 35,
                                        child:
                                            Image.asset('assets/img/user.png')),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      snapshot.data!.docs[index]['sender'] ==
                                              getMyUsername()
                                          ? Text(
                                              snapshot.data!.docs[index]
                                                  ['receiver'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          : Text(
                                              snapshot.data!.docs[index]
                                                  ['sender'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                      snapshot.data!.docs[index]['sender'] ==
                                              getMyUsername()
                                          ? shortenedMsg == fullSizeMsg
                                              ? Text(
                                                  'Me: $shortenedMsg',
                                                )
                                              : Text(
                                                  'Me: $shortenedMsg...',
                                                )
                                          : shortenedMsg == fullSizeMsg
                                              ? Text(shortenedMsg)
                                              : Text('$shortenedMsg...'),
                                    ],
                                  ),
                                  const Spacer(),
                                  snapshot.data!.docs[index]['created'] != null
                                      ? Text(
                                          timestampFormat(snapshot
                                              .data!.docs[index]['created']),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          )),
                    );
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
        });
  }
}
