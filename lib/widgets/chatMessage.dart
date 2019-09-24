import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  const ChatMessage({
    Key key,
    @required this.message,
    @required this.timestamp,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(message),
        leading: Text("${timestamp.hour}:${timestamp.minute}"),
        ),
    );
  }
}