import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:weather_app/back/entities/weather.dart';
import 'package:weather_app/back/entities/weather_state.dart';
import 'package:weather_app/pages/forecast_page.dart';
import 'package:weather_app/widgets/weather_widget.dart';

class WeatherView extends StatelessWidget {
  const WeatherView(this.weather);
  final WeatherState weather;

  @override
  Widget build(BuildContext context) {
    return ListView(physics: BouncingScrollPhysics(), children: [
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WeatherWidget(weather: weather),
            SizedBox(
              height: 70,
            ),
            GestureDetector(
              child: Text(
                'Forecast for 5 days',
                style: _forecastButtonStyle,
              ),
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForecastPage())),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Text(
                'Share',
                style: _shareButtonStyle,
              ),
              onTap: () async =>
              await _shareWeather(context, weather),
            ),
            SizedBox(
              height: 30,
            )
          ])
    ]);
  }

  static const _shareButtonStyle =
  TextStyle(fontSize: 30, color: Colors.orange, fontWeight: FontWeight.w300);

  static const _forecastButtonStyle =
  TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.w300);

  Future<void> _shareWeather(BuildContext context, Weather weather) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(weather.toString(),
        subject: 'Weather',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

}