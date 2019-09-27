import 'package:chat/auth.dart';
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
  Map<String, dynamic> _profile;
  Future profileFuture;
  @override
  void initState() {
    profileFuture = authService.getUserProfile(widget.user);
    profileFuture.then((value) => _profile = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Homepage"),
        ),
        body: FutureBuilder(
          future: profileFuture,
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot.connectionState);
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text("Loading...");
              case ConnectionState.done:
                return Text("Welcome ${_profile["displayName"]}");
              default:
                return Text("How did I get here?"); // TODO error handling

            }
          },
        ),
      ),
    );
  }
}
