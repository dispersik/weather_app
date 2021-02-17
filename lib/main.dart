import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/openweathermap_api.dart';
import 'package:weather_app/back/weather.dart';

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
  List<Weather> weatherList;

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
                  currentLocation = /*await getCurrentLocation() ??*/
                      Position(
                          // latitude: 52.42536875588388,
                          // longitude: 31.021136747104755
                          latitude: 52.35308471250674,
                          longitude: 31.106725359980484);
                  print(currentLocation);
                  weatherList = await apiResponseToWeatherList(
                      await getCurrentForecastByCoordinates(currentLocation));
                },
                child: Text('getCurrentLocation'))
          ],
        ),
      ),
    );
  }
}
