import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/functions.dart';

class MessagesStream extends StatefulWidget {
  final String friendUsername;
  const MessagesStream(this.friendUsername, {super.key});

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

final ScrollController _sc = ScrollController();

class _MessagesStreamState extends State<MessagesStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('chatID',
              isEqualTo:
                  getChatRoomIdByUserId(getMyUsername(), widget.friendUsername))
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
                        getMyUsername()
                    ? Container(
                        margin: const EdgeInsets.only(
                            left: 80, right: 5, top: 5, bottom: 5),
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  streamSnapshot.data!.docs[index]['message'],
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
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  streamSnapshot.data!.docs[index]['message'],
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
    );
  }
}
