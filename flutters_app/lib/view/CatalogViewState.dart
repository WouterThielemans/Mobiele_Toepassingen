import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutters_app/model/Catalog.dart';
import 'package:flutters_app/model/Item.dart';
import 'package:flutter/material.dart';
import 'package:flutters_app/model/Purchase.dart';
import 'package:flutters_app/model/ShoppingCart.dart';
import 'package:flutters_app/view/CatalogView.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:flutters_app/weather/weather.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/Purchase.dart';
import 'CatalogView.dart';
import '../globals.dart' as globals;
import 'CatalogView.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class CatalogViewState extends State<CatalogView> {
  String barcode = "";
  Catalog _catalog = new Catalog();
  final _biggerFont = const TextStyle(fontSize: 18);
  DateTime now = DateTime.now();

  Widget _buildSuggestions() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        // TODO: itereren
        _buildItem(_catalog.getItem(0)),
        _buildItem(_catalog.getItem(1)),
        _buildItem(_catalog.getItem(2)),
        _buildItem(_catalog.getItem(3)),
        _buildItem(_catalog.getItem(4)),
        _buildItem(_catalog.getItem(5)),
        _buildItem(_catalog.getItem(6)),
        _buildItem(_catalog.getItem(7)),
        _buildItem(_catalog.getItem(8)),
        _buildItem(_catalog.getItem(9)),
        _buildItem(_catalog.getItem(10)),
        _buildItem(_catalog.getItem(11)),
      ],
    );
  }

  Widget _buildItem(Item item) {
    final bool alreadySaved = globals.cart.contains(item);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage(item.getPicture()),
          fit: BoxFit.scaleDown,
        ),
      ),
      child: new ListTile(
        title: Text(
          item.getName() + "\n€" + item.getPrice().toString(),
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.check : Icons.add_shopping_cart,
        ),
        onTap: () {
          var alert = AlertDialog(
              title: Text("How many items do you need?"),
              content: TextField(
                  style: TextStyle(decoration: TextDecoration.none),
                  maxLines: 1,
                  maxLengthEnforced: false,
                  autofocus: true,
                  enabled: true,
                  keyboardType: TextInputType.number,
                  onSubmitted: (String text) async {
                    int amount = null;
                    var reg = new RegExp(r'^[0-9]+$');

                    if (reg.hasMatch(text)){
                      if(text.length < 6)
                      amount = int.parse(text);
                    }                     

                    Purchase purchase = new Purchase(item);
                    purchase.setAmount(amount);
                    if (amount > 0) {
                      if (globals.cart.contains(item)) {
                        globals.cart.updatePurchase(purchase);
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CatalogView()));
                        Navigator.pop(context);
                      } else {
                        globals.cart.addPurchase(purchase);
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CatalogView()));
                        Navigator.pop(context);
                      }
                    }
                    if (amount <= 0) {
                      if (globals.cart.contains(item)) {
                        globals.cart.removePurchase(item.getName());
                      }
                    }
                    Navigator.pop(context);
                  }));

          showDialog(
            context: context,
            builder: (context) {
              return alert;
            },
          );
        },
      ),
    );
  }

  bool isNumeric(String s) {
 if (s == null) {
   return false;
 }
 return int.tryParse(s) != null;
}


  void wheater() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WeatherPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BAR SHOP'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(FontAwesomeIcons.cloudSun), onPressed: wheater),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: scan),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      Iterable<ListTile> tiles = globals.cart.getPurchases().map(
        (Purchase purchase) {
          return ListTile(
              title: Text(
                purchase.getItemName() +
                    "\n€" +
                    purchase.getItemPrice().toStringAsFixed(2) +
                    "\nAmount " +
                    purchase.getAmount().toString(),
                style: _biggerFont,
              ),
              trailing: Wrap(spacing: 12, children: <Widget>[
                IconButton(
                  icon: Icon(Icons.plus_one),
                  onPressed: () async {
                    if (purchase.getAmount() >= 100000) {
                    } else {
                      await globals.cart.incrementPurchase(purchase);
                    }
                    Navigator.pop(context);
                    _pushSaved();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exposure_neg_1),
                  onPressed: () async {
                    await globals.cart.decrementPurchase(purchase);
                    if (purchase.getAmount() <= 0) {
                      globals.cart.removePurchase(purchase.getItemName());
                    }
                    Navigator.pop(context);
                    _pushSaved();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () async {
                    await globals.cart.removePurchase(purchase.getItemName());
                    Navigator.pop(context);
                    _pushSaved();
                  },
                ),
              ]));
        },
      );

      var total = ListTile(
        title: Text(
          "Total: €" + globals.cart.getTotal().toStringAsFixed(2),
          style: _biggerFont,
        ),
        trailing: RaisedButton(
          child: Text('Pay'),
          color: Theme.of(context).buttonColor,
          elevation: 1.0,
          splashColor: Colors.blueGrey,
          onPressed: () async {
            await animated_dialog_box.showCustomAlertBox(
                context: context,
                firstButton: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.white,
                  child: Text('Pay & Send email'),
                  onPressed: () async {
                    final Email email = Email(
                      body: 'Buyer: ' +
                          globals.user.email.toString() +
                          '\n Id: ' +
                          globals.user.uid.toString() +
                          '\n Date Stamp: ' +
                          now.toString() +
                          '\n-------------------------------------------' +
                          '\n\n ' +
                          globals.cart.toStringPurchases().toString() +
                          '\n-------------------------------------------' +
                          '\n Total Price: €' +
                          globals.cart
                              .getTotal()
                              .toStringAsFixed(2)
                              .toString() +
                          '\n\nAccount number: BE78 6942 0637 2304',
                      subject: 'Payment by id: ' + globals.user.uid.toString(),
                      recipients: ['caravan.haacht@gmail.com'],
                      isHTML: false,
                    );

                    await FlutterEmailSender.send(email);

                    _pushSaved();
                    globals.cart.clear();
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CatalogView()));
                    await Navigator.of(context).pop();
                    await Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                yourWidget: Container(
                  child: Text('You have to pay €' +
                      globals.cart.getTotal().toStringAsFixed(2) +
                      ' to Barshop NV' +
                      '\nBE78 6942 0637 2304' +
                      '\n\nOr pay cash at the bar.'),
                ));
            //globals.cart.clear();
            _pushSaved();
            //Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      );

      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      if (globals.cart.getTotal() == 0) {
        total = ListTile(
          title: Text("Your shopping cart is empty"),
        );
      }

      divided.add(total);

      return Scaffold(
        appBar: AppBar(
          title: Text('Shopping Cart'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      bool exist = false;
      setState(() {
        this.barcode = barcode;
        for (Item i in _catalog.getCatalog()) {
          if (i.getCode() == barcode) {
            exist = true;
            var alert = AlertDialog(
                title: Text("How many items do you need?"),
                content: TextField(
                    style: TextStyle(decoration: TextDecoration.none),
                    maxLines: 1,
                    maxLengthEnforced: false,
                    autofocus: true,
                    enabled: true,
                    keyboardType: TextInputType.number,
                    onSubmitted: (String text) async {
                      int amount = int.parse(text);
                      Purchase purchase = new Purchase(i);
                      purchase.setAmount(amount);
                      if (amount > 0) {
                        if (globals.cart.contains(i)) {
                          globals.cart.updatePurchase(purchase);
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CatalogView()));
                          Navigator.pop(context);
                        } else {
                          globals.cart.addPurchase(purchase);
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CatalogView()));
                          Navigator.pop(context);
                        }
                      }
                      if (amount <= 0) {
                        if (globals.cart.contains(i)) {
                          globals.cart.removePurchase(i.getName());
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CatalogView()));
                          Navigator.pop(context);
                        }
                      }
                      Navigator.pop(context);
                    }));
            showDialog(
              context: context,
              builder: (context) {
                return alert;
              },
            );
          }
        }
        if (!exist) {
          var alert = AlertDialog(
            title: Text("We do not sell this item"),
            backgroundColor: Color.fromRGBO(192, 192, 192, 1),
          );
          showDialog(
            context: context,
            builder: (context) {
              return alert;
            },
          );
        }
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
