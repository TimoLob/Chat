import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  HomePage({
    Key key,
    @required this.user,
  }) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _displayName;
  @override
  void initState() {
     _displayName = widget.user.displayName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Login Successful "),
          ),
          body: Text("Welcome $_displayName"),
    ),
    );
  }
}
