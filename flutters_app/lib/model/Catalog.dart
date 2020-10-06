

import 'Item.dart';

class Catalog {
  List<Item> _catalog = new List();

  Catalog(){
    // TODO: in databank bijhouden ipv hardcoden
    _catalog.add(Item.withPicture("Stella", 1.00, "assets/images/bieren/stella.jpg","5410228141235"));
    _catalog.add(Item.withPicture("Primus", 1.00, "assets/images/bieren/primus.jpg","54085107"));
    _catalog.add(Item.withPicture("Cara", 0.80, "assets/images/bieren/cara.jpg","5400141267105"));

    _catalog.add(Item.withPicture("Rodeo", 1.00, "assets/images/Frisdranken/rodeo.jpg","8711900013992"));
    _catalog.add(Item.withPicture("Ice Tea", 1.00, "assets/images/Frisdranken/icetea.jpg","8717163936795"));
    _catalog.add(Item.withPicture("Cola", 1.00, "assets/images/Frisdranken/cola.jpg","8712561255530"));

    _catalog.add(Item.withPicture("Shot Rum Bruin", 1.50, "assets/images/SterkeDranken/rum_bruin.jpg","8712561249393"));
    _catalog.add(Item.withPicture("Shot Vodka Zwart", 1.50, "assets/images/SterkeDranken/vodka_black.jpg","8715342031903"));
    _catalog.add(Item.withPicture("Shot Jenever", 1.50, "assets/images/SterkeDranken/jenever.jpg","7610100088056"));

    _catalog.add(Item.withPicture("Paprika Chips", 0.50, "assets/images/Snacks/chips.jpg","CHIPS"));
    _catalog.add(Item.withPicture("Party Snacks", 4.00, "assets/images/Snacks/party_snacks.jpg","SNACKS"));
    _catalog.add(Item.withPicture("Hot Dog", 1.00, "assets/images/Snacks/worst.jpg","HOTDOG"));





  }

  List<Item> getCatalog(){
    return _catalog;
  }

  void addItem(Item item){
    _catalog.add(item);
  }

  Item getItem(int i){
    return _catalog[i];
  }
}