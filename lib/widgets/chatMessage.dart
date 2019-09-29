import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final Timestamp timestamp;
  const ChatMessage({
    Key key,
    @required this.message,
    @required this.timestamp,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return Container(
      child: ListTile(
        title: Text(message),
        leading: Text("${date.hour}:${date.minute}"),
        ),
    );
  }
}