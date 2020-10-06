import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutters_app/setup/sign_in.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('SIGN UP'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                decoration: InputDecoration(
                    labelText: 'Email'
                ),
                onSaved: (input) => _email = input,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                  validator: (input) {
                  if(input.length < 6){
                    return 'Longer password please';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
        ),
              RaisedButton(
                color: Colors.black38,
                onPressed: signUp,
                child: const Text('Create account', style: TextStyle(fontSize: 20)),
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
              )
            ],
          ),
          ),
      ),
    );
  }

  void signUp() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        try{
          await user.sendEmailVerification();
          print(user.uid);
          String verificationemail = "Your account has been created, check you email to verify.";
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: new Text(verificationemail),
                duration: new Duration(seconds: 10),
              )
          );
        }
        catch(e){
          print(e.message);
        }
      }catch(e){
        print(e.message);
        String alreadytaken = "Email address already in use.";

        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: new Text(alreadytaken),
              duration: new Duration(seconds: 10),
            )
        );
      }
    }
  }

  Future<void> navigateToSignIn() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true));
    Navigator.pop(context);
  }

}