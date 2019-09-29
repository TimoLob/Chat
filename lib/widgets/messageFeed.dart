import 'package:chat/auth.dart';
import 'package:chat/widgets/chatMessage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageFeed extends StatefulWidget {
  MessageFeed({Key key}) : super(key: key);

  _MessageFeedState createState() => _MessageFeedState();
}

class _MessageFeedState extends State<MessageFeed> {
  Future<List<DocumentSnapshot>> _messagesFuture;
  List<DocumentSnapshot> _messages;
  @override
  void initState() {
    super.initState();
    _messagesFuture = authService.getCollection("messages");
    _messagesFuture.then((value) => _messages = value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _messagesFuture,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return Text("Loading messages...");
          case ConnectionState.done:
            return buildColumn();
          default:
            return Text("How did I get here?"); // TODO error handling
        }
      },
    );
  }

  Widget buildColumn() {
    _messages.sort((s1,s2) => s1.data["time"].millisecondsSinceEpoch - s2.data["time"].millisecondsSinceEpoch);
    List<Widget> messages = _messages
        .map((DocumentSnapshot documentSnap) => ChatMessage(
              message: documentSnap.data["message"],
              timestamp: documentSnap.data["time"],
            ))
        .toList();
    return Column(
      children: messages,
    );
  }
}
