import 'package:flutters_app/setup/sign_in.dart';
import 'package:flutters_app/setup/sign_up.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WELCOME TO BARSHOP'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child:RaisedButton(
            onPressed: navigateToSignIn,
            //textColor: Colors.amber,
            child: const Text('Sign in', style: TextStyle(fontSize: 20)),
            padding: const EdgeInsets.all(10.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child:RaisedButton(
            onPressed: navigateToSignUp,
            child: const Text('Sign up', style: TextStyle(fontSize: 20)),
            padding: const EdgeInsets.all(10.0),
            ),
          ),
        ],
      ),
    );
  }

  //functions
  void navigateToSignIn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  //functions
  void navigateToSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(), fullscreenDialog: true));
  }
}