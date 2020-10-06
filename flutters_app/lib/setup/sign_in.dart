import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutters_app/setup/reset_password.dart';
import 'package:flutters_app/view/CatalogView.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../view/CatalogView.dart';
import 'package:flutters_app/setup/sign_up.dart';
import '../globals.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        title: Text('SIGN IN'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    bool matchemail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
                    if (input.isEmpty || matchemail == false){
                      return 'Provide an email';
                    }
                  },
                  decoration: InputDecoration(labelText: 'Email'),
                  onSaved: (input) => _email = input,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return "Password can not be empty";
                  }
                },
                decoration: InputDecoration(labelText: 'Password',
                  errorText: loginfail ? 'password not correct' : null,
                ),
                onSaved: (input) => _password = input,
                obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child:RaisedButton(
                color: Colors.black38,
                onPressed: signIn,
                  child: const Text('Sign in', style: TextStyle(fontSize: 20)),
                  padding: const EdgeInsets.all(10.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child:RaisedButton(
                onPressed: navigateToResetPassword,
                  child: const Text('Forgot password?', style: TextStyle(fontSize: 20)),
                  padding: const EdgeInsets.all(10.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child:RaisedButton(
                onPressed: navigateToSignUp,
                  child: const Text("Don't have an account yet?", style: TextStyle(fontSize: 20)),
                  padding: const EdgeInsets.all(10.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //functions
  Future<void> navigateToSignUp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(), fullscreenDialog: true));
  }

  Future<void> navigateToResetPassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage(), fullscreenDialog: true));
  }


  String message;
  String mes;
  bool loginfail=false;

  void signIn() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        globals.user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user: user)));

        if(globals.user.isEmailVerified){
          globals.cart.clear();
          await Navigator.push(context, MaterialPageRoute(builder: (context) => CatalogView()));
          Navigator.pop(context);
        }
        else{
          String novalid = "Email address not yet verified";
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: new Text(novalid),
                duration: new Duration(seconds: 5),
              )
          );
        }
      }catch(e){
        print(e.message);
        setState(() {
          loginfail = true;
        });
      }
    }
  }
}
