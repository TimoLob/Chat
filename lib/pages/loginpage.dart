import 'package:chat/auth.dart';
import 'package:chat/widgets/loginForm.dart';
import 'package:chat/widgets/profile.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          print("SnapshotData: ${snapshot.data.toString()}");
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: () => authService.signOut(),
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Signout"),
                ),
                EditProfile(snapshot: snapshot),
              ],
            );
          } else {
            return LoginForm();
          }
        },
      ),
    );
  }
}
