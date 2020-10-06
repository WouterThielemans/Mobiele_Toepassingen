
import 'package:flutter/material.dart';
import 'package:flutters_app/view/home.dart';

import 'setup/welcome.dart';
import 'setup/welcome.dart';
import 'setup/welcome.dart';
import 'view/CatalogView.dart';
import 'view/CatalogView.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home:  WelcomePage(),
    );
  }
}


