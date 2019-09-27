import 'dart:async';

import 'package:chat/auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _password;
  String _email;
  Map<String, dynamic> _profileData;
  StreamSubscription _subscription;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _subscription = authService.profile.listen(updateProfileData);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void updateProfileData(data) {
    _profileData = data;
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (input) {
              if (input.isEmpty) return "Please type a valid email";
              return null;
            },
            onSaved: (input) => _email = input,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextFormField(
            validator: (input) {
              if (input.length < 6)
                return "Your password needs to be at least 6 characters";
              return null;
            },
            onSaved: (input) => _password = input,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          RaisedButton(
            child: Text("Sign in"),
            onPressed: signIn,
          ),
          RaisedButton(
            child: Text("Sign in with Google"),
            onPressed: () async {
              authService.googleSignIn();
            },
          )
        ],
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (!formState.validate()) return;
    print("Valid Form");
    formState.save();
    try {
      authService.emailSignIn(_email, _password);
    } catch (e) {
      print(e);
    }
  }
}
