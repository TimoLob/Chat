import 'package:chat/auth.dart';
import 'package:chat/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChooseDisplayName extends StatefulWidget {
  final FirebaseUser user;
  ChooseDisplayName({Key key, @required this.user}) : super(key: key);

  _ChooseDisplayNameState createState() => _ChooseDisplayNameState();
}

class _ChooseDisplayNameState extends State<ChooseDisplayName> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose your unique display name."),),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Display Name"),
              validator: validateDisplayName,
              onSaved: (input) => _displayName = input,
            ),
            RaisedButton(
              child: Text("OK"),
              onPressed: chooseDisplayName,
            )
          ],
        ),
      ),
    );
  }

  String validateDisplayName(String name)
  {
    if(name.length<4)
      return "Please choose a name with at least 4 characters";
    return null;
  }

  Future<void> chooseDisplayName() async {
    final FormState currentState = _formKey.currentState;
    if(!currentState.validate())
    {
      return;
    }
    currentState.save();
    await authService.updateUserDataWithMap(widget.user, {"displayName":_displayName});
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: widget.user,)));
  }
}
