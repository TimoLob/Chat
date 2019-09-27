import 'package:chat/auth.dart';
import 'package:chat/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final AsyncSnapshot<FirebaseUser> snapshot;
  EditProfile({Key key, @required this.snapshot}) : super(key: key);

  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _displayName = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: widget.snapshot.data.displayName,
            validator: (input) {
              if (input.length < 4)
                return "Your display name needs to be at least 4 characters long.";
              return null;
            },
            onSaved: (input) => _displayName = input,
            decoration: InputDecoration(labelText: "DisplayName"),
          ),
          RaisedButton(
            onPressed: saveUserProfile,
            child: Text("Save profile"),
          ),
        ],
      ),
    );
  }

  Future<void> saveUserProfile() async {
    final formState = _formKey.currentState;
    final AsyncSnapshot<FirebaseUser> snapshot = widget.snapshot;
    if (!formState.validate()) return;
    formState.save();
    authService
        .updateUserDataWithMap(snapshot.data, {"displayName": _displayName});
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomePage(user: snapshot.data)));
  }
}
