import 'package:flutters_app/model/Roles.dart';

class User {
  int _id;
  String _name;
  Roles _role = Roles.Customer;
  
  

  User(this._id, this._name);

  String getName(){
    return _name;
  }

  int getId(){
    return _id;
  }

  void setName(String name){
    _name = name;
  }

  void setId(int id){
    _id = id;
  }

  void setRole(Roles role){
    _role = role;
  }

  Roles getRole(){
    return _role;
  }

}