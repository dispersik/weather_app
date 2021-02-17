import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/geocoder_helper.dart';
import 'package:weather_app/back/geolocator_helper.dart';
import 'package:weather_app/back/openweathermap_api.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position currentLocation;
  List<Address> detailedAddress;
  String currentWeather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  currentLocation = await getCurrentLocation();
                  print(currentLocation);
                  detailedAddress = await getAddressFromCoordinates(
                      currentLocation.latitude, currentLocation.longitude);
                  // detailedAddress.forEach((element)=>print(element.toMap()));
                  currentWeather = await getCurrentWeather(
                          addressToLocation(detailedAddress[0]), apiKey)
                      .then((value) => value.body);
                  print(currentWeather);
                },
                child: Text('getCurrentLocation'))
          ],
        ),
      ),
    );
  }
}
