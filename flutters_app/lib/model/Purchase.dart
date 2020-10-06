import 'Item.dart';

class Purchase {
  Item _item;
  int _amount = 1;

  Purchase(this._item);
  Purchase.withAmount(this._item, this._amount);

  void setAmount(int amount){
    
    _amount = amount;
  }

  double getItemPrice() {
    return _item.getPrice();
  }

  int getAmount() {
    return _amount;
  }

  String getItemName(){
    return _item.getName();
  }

  double getTotalPrice(){
    return _amount * getItemPrice();
  }

}