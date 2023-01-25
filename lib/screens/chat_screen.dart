import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../extensions/string_extension.dart';

class ChatScreen extends StatefulWidget {
  final String friendUsername;
  const ChatScreen(this.friendUsername, {super.key});

  getMyUsername() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String? usernameWithEmail = user!.email;
    String myUsername =
        usernameWithEmail!.substring(0, usernameWithEmail.indexOf('@'));

    return myUsername.capitalize();
  }

  String getChatRoomIdByUserId(String myUserID, String peerID) {
    return myUserID.hashCode <= peerID.hashCode
        ? '${myUserID}_$peerID'
        : '${peerID}_$myUserID';
  }

  Future<void> sendMsg() async {
    if (chatInput.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'sender': getMyUsername(),
        'receiver': friendUsername,
        'message': chatInput.text,
        'created': FieldValue.serverTimestamp(),
        'chatID': getChatRoomIdByUserId(getMyUsername(), friendUsername),
        'users': [getMyUsername(), friendUsername],
      });
    }
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final ScrollController _sc = ScrollController();
final TextEditingController chatInput = TextEditingController();
var lastMsg;

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.friendUsername),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          )),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chatID',
                      isEqualTo: widget.getChatRoomIdByUserId(
                          widget.getMyUsername(), widget.friendUsername))
                  .orderBy('created', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.active) {
                  return ListView.builder(
                      reverse: true,
                      controller: _sc,
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        return streamSnapshot.data!.docs[index]['sender'] ==
                                widget.getMyUsername()
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 80, right: 5, top: 5, bottom: 5),
                                decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          streamSnapshot.data!.docs[index]
                                              ['message'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(
                                    right: 80, left: 5, top: 5, bottom: 5),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 217, 217, 217),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          streamSnapshot.data!.docs[index]
                                              ['message'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      });
                }
                return Container();
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 10),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: chatInput,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    icon: const Icon(
                      Icons.send_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      await widget.sendMsg();
                      chatInput.clear();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
