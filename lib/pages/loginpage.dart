import 'package:chat/auth.dart';
import 'package:chat/pages/homepage.dart';
import 'package:chat/widgets/chatMessage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _password;
  String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
          TextFormField(
            validator: (input) {
              if(input.isEmpty)
                return "Please type a valid email";
              return null;
            },
            onSaved: (input) => _email = input,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextFormField(
            validator: (input) {
              if(input.length<6)
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
            onPressed: () {
              authService.googleSignIn();
            },
          )
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async{
    final formState = _formKey.currentState;
    if(!formState.validate())
      return;
    print("Valid Form");
    formState.save();
    try{
      
      FirebaseUser user = await authService.emailSignIn(_email,_password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user:user)));
    }catch(e) {
      print(e);
    }
  }
}
