import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/helper.dart';
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
    final weatherList =
        await weatherAPI.getForecastByCoordinates(currentLocation);
    print(weatherList);
  }

  const WeatherWidget({this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            child: Column(
              children: [
                Image.asset(
                  'assets/openweathermap_icons/' +
                      weather.weatherDescription.iconName +
                      '.png',
                  scale: 0.4,
                  isAntiAlias: true,
                ),
                Text(
                  "${weather.city}\n${_dateHelper(weather.datetime)}, ${_timeHelper(weather.datetime)}",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                ),
                Text(
                  '${weather.temperature}°C | ${weather.weatherDescription.main}',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.w300),
                ),
                Text(
                  '${weather.weatherDescription.description}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pressure\n${weather.pressure.round()} kPa',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 20),
                    Text('Humidity\n${weather.humidity.round()}%',
                        textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  String _dateHelper(DateTime time) {
    if (DateTime.now().day==time.day) return 'Today';
    else return weekdayToReadableDay(time.weekday);
  }
  String _timeHelper(DateTime time) {
    var now = DateTime.now();
    if (now.isAfter(time)&&_dateHelper(time)=='Today') {
      var result = '${now.hour}:';
      if (now.minute<10) return result+'0${now.minute}';
      else return result+now.minute.toString();
    }
    else return '${time.hour}:00';
  }
}
