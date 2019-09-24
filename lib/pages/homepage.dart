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
  IdTokenResult _tokenResult;
  Future<IdTokenResult> _tokenResultFuture;
  @override
  void initState() {
    _tokenResultFuture = widget.user.getIdToken();
    _tokenResultFuture.then((value) => _tokenResult=value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Login Successful "),
          ),
          body: FutureBuilder(
            future: _tokenResultFuture,
            builder:
                (BuildContext context, AsyncSnapshot<IdTokenResult> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                  break;
                case ConnectionState.done:
                  return Text(snapshot.data.claims['user_id']);
                  break;
                default:
                  return Text("I don't know how I got here.");
              }
            },
          )),
    );
  }
}
