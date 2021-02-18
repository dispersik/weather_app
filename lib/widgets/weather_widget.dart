import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/openweathermap_api.dart';
import 'package:weather_app/back/weather.dart';

class WeatherWidget extends StatelessWidget {
  Future<void> _getForecastRoutine() async {
    final weatherAPI = OpenWeatherMapAPI();
    final currentLocation = /*await getCurrentLocation() ??*/
    Position(
      // latitude: 52.42536875588388,
      // longitude: 31.021136747104755
        latitude: 52.35308471250674,
        longitude: 31.106725359980484);
    print(currentLocation);
    final weatherList = await weatherAPI.getForecastByCoordinates(currentLocation);
    print(weatherList);
  }
  const WeatherWidget({this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            // height: 500,
            // color: Colors.grey,
            child: Column(
              children: [
                Image.asset(
                  'assets/openweathermap_icons/' + '13n.png',
                  /*+ weather.weatherDescription.iconName*/
                  scale: 0.4,
                  isAntiAlias: true,
                ),
                Text(
                  'Location',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
                Text(
                  '${weather.temperature}°C | Snow',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.w300),
                ),
                ElevatedButton(
                    onPressed: () async => _getForecastRoutine(),
                    child: null
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
