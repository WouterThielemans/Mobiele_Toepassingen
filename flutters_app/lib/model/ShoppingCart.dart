import 'package:flutter/foundation.dart';
import 'package:flutters_app/model/Purchase.dart';

import 'Item.dart';
import 'Purchase.dart';

class ShoppingCart with ChangeNotifier {
  List<Purchase> _purchases = new List();
  ShoppingCart();

  void addPurchase(Purchase purchase){
    _purchases.add(purchase);
    notifyListeners();
  }

  Future<Purchase> removePurchase(String item){
    List<Purchase> _itemsToRemove = new List();
    _purchases.forEach( (p) {
      if (p.getItemName() == item) {
        _itemsToRemove.add(p);
      }
    });
    _purchases.removeWhere( (p) => _itemsToRemove.contains(p));
    notifyListeners();
    return null;
  }

  List<Purchase> getPurchases(){
    return _purchases;
  }

  void updatePurchase(Purchase purchase){
    for(var purchase1 in _purchases){
      if(purchase1.getItemName()==purchase.getItemName()){
        if (purchase1.getAmount()!=0){
          purchase1.setAmount(purchase1.getAmount() + purchase.getAmount());
        }else{
          purchase1.setAmount(purchase.getAmount());
        }

      }
    }
    notifyListeners();
  }

  bool contains(Item item){
    for (var purchase in _purchases) {
      if (purchase.getItemName() == item.getName()){
        return true;
      }
    }
    return false;
  }
  
  double getTotal(){
    double totaal = 0;
    for(var purchase in _purchases){
      totaal+=purchase.getTotalPrice();
    }
    return totaal;
  }


  void clear(){
    _purchases.clear();
  }

  incrementPurchase(Purchase purchase){
    for(var purchase1 in _purchases){
      if(purchase1.getItemName()==purchase.getItemName()){
        purchase1.setAmount(purchase1.getAmount()+ 1);
      }
    }
    notifyListeners();
  }

  decrementPurchase(Purchase purchase){
    for(var purchase1 in _purchases){
      if(purchase1.getItemName()==purchase.getItemName()){
        purchase1.setAmount(purchase1.getAmount()- 1);

      }
    }
    notifyListeners();
  }

  String toStringPurchases(){
    String result ="";
    for(var p in _purchases){
      result += p.getAmount().toString() + " " + p.getItemName() + "\n Cost per item: €" + p.getItemPrice().toString() + "\n\n";
    }
    return result;
  }
}