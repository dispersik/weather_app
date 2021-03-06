import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/back/helper.dart';
import 'package:weather_app/back/entities/weather.dart';
import 'package:weather_app/widgets/ui_helper.dart';

class WeatherWidget extends StatelessWidget {
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
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: SvgPicture.asset(
                      'assets/opensource_weather_icons/' +
                          weather.weatherDescription.iconName +
                          '.svg',
                      height: 220,
                      width: 220,
                      color: iconColorPicker(weather)
                  ),
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
                    Container(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/opensource_weather_icons/barometer.svg",
                            height: 30,
                            width: 30,
                            color: Colors.lightBlueAccent[700],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Pressure\n${weather.pressure} kPa',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    SizedBox(width: 20),
                    Container(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/opensource_weather_icons/humidity.svg",
                            width: 30,
                            height: 30,
                            color: Colors.lightBlueAccent[700],
                          ),
                        ],
                      ),
                    ),
                    Text('Humidity\n${weather.humidity}%',
                        textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w300)),
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
    if (DateTime.now().day == time.day)
      return 'Today';
    else
      return weekdayToReadableDay(time.weekday);
  }

  String _timeHelper(DateTime time) {
    var now = DateTime.now();
    if (now.isAfter(time) && _dateHelper(time) == 'Today') {
      var result = '${now.hour}:';
      if (now.minute < 10)
        return result + '0${now.minute}';
      else
        return result + now.minute.toString();
    } else
      return '${time.hour}:00';
  }
}
