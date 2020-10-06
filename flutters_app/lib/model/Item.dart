class Item {
  String _name;
  double _price;
  // TODO: add link to picture in this variable
  String _picture;
  String _code;

  Item(this._name, this._price,this._code);

  Item.withPicture(this._name, this._price, this._picture, this._code);


 String getCode(){
   return _code;
 }

  String getPicture() {
    return _picture;
  }

  String getName() {
    return _name;
  }

  double getPrice() {
    return _price;
  }

  void setPrice(double price){
    _price = price;
  }

  void setName(String name){
    _name = name;
  }

  void setPicture(String picture){
    _picture = picture;
  }

}