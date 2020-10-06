import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutters_app/setup/sign_in.dart';
import 'package:flutters_app/view/CatalogView.dart';
import 'package:flutters_app/view/home.dart';
import 'package:flutter/material.dart';

import '../view/CatalogView.dart';
import 'package:flutters_app/setup/sign_up.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageStage createState() => new _ResetPasswordPageStage();
}

class _ResetPasswordPageStage extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('PASSWORD RESET'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Column(
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
              RaisedButton(
                color: Colors.black38,
                onPressed: SendResetEmail,
                child: const Text('Reset password', style: TextStyle(fontSize: 20)),
                padding: const EdgeInsets.all(10.0),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child:RaisedButton(
                  onPressed: navigateToSignIn,
                  //textColor: Colors.amber,
                  child: const Text('Sign in', style: TextStyle(fontSize: 20)),
                  padding: const EdgeInsets.all(10.0),
                ),
              ),
            ],
          )),
    );
  }
//        await Navigator.push(context, MaterialPageRoute(
//            builder: (context) => LoginPage(), fullscreenDialog: true));
//        Navigator.pop(context);

  void SendResetEmail() async{
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      try {
        await _firebaseAuth.sendPasswordResetEmail(email: _email);

        String resetemail = "Check your mailbox to reset your password";
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: new Text(resetemail),
              duration: new Duration(seconds: 10),
            )
        );

      }
      catch (e) {
        print(e.message);
        String noemail = "Email does not have an account yet.";
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: new Text(noemail),
              duration: new Duration(seconds: 10),
            )
        );
      }
    }
  }

  //functions
  Future<void> navigateToSignIn() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true));
    Navigator.pop(context);
    Navigator.of(context).pop();
  }
}
