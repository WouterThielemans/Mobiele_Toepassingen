import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() =>  new _ScanState();



}

class _ScanState extends State<ScanScreen> {
  String barcode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                color: Colors.purple,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.scanner, size: 40,),
                    SizedBox(width: 10,),
                    Column(
                      children: <Widget>[
                        Text('Camera scan', style: TextStyle(fontSize: 20.0),),
                        SizedBox(height: 2,),
                        Text('Click here for camera scan')
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(barcode, textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }


  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
        print(this.barcode);
        print('test');

      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Camera perm not granted';
        });
      } else {
        setState(() {
          this.barcode = 'error';
        });
      }
    } on FormatException {
      setState(() {
        this.barcode =
        'null(User returened using "back"-button before scanning anything, Result )';
      });
    } catch (e) {
      setState(() {
        this.barcode = 'Unkown error: $e';
      });
    }
  }


}