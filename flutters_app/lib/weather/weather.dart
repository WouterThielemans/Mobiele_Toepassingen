import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import '../view/CatalogView.dart';

String currentlocation;
var la;
var lo;

class WeatherPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    print(la);
    print(lo);
    return _WeatherState();

  }
}

class _WeatherState extends State<WeatherPage> {
  var temp;
  var desc;
  var currently;
  var humidity;
  var windspeed;
  var place;

  Future getWheather() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
          print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
        });

    la = position.latitude.toString();
    lo = position.longitude.toString();

    http.Response response =  await http.get('http://api.openweathermap.org/data/2.5/weather?lat='+ la +'&lon='+ lo +'&appid=079922382ac1ef7f93c36691f90eb025');
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = (results['main']['temp']) -273.15;
      this.desc = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
      this.place = results['name'];

      currentlocation = this.place.toString();
    });
  }

  @override
  void initState(){
    super.initState();
    this.getWheather();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WEATHER'),
            centerTitle: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() async { await Navigator.push(context, MaterialPageRoute(builder: (context) => CatalogView()));
          Navigator.pop(context);
          },
          ),
        ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text((currentlocation != null ? "Currently in " + currentlocation : " Location unknown"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Text(
                  temp != null ? temp.toStringAsFixed(1) + " \u2103" : "Loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    currently != null ? currently.toString() : "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text("Temperature"),
                    trailing: Text(temp != null ? temp.toStringAsFixed(1) + " \u2103" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Humidity"),
                    trailing: Text(humidity != null ? humidity.toString() + " %": "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Wind speed"),
                    trailing: Text(windspeed != null ? windspeed.toString() + " km/h" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Weather"),
                    trailing: Text(desc != null ? desc.toString() : "Loading"),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}