import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkchat_app/widgets/chat_screen/messages_stream.dart';
import 'package:flutter/material.dart';
import '../utils/functions.dart';

class ChatScreen extends StatelessWidget {
  final String friendUsername;
  const ChatScreen(this.friendUsername, {super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(friendUsername),
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
            child: MessagesStream(friendUsername),
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
                      await sendMsg();
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

final TextEditingController chatInput = TextEditingController();
late String lastMsg;
