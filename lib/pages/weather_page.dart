
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:weather_app/back/bloc/weather_bloc.dart';
import 'package:weather_app/back/openweathermap_api.dart';
import 'package:weather_app/back/weather.dart';
import 'package:weather_app/widgets/weather_widget.dart';

import '../main.dart';
import 'forecast_page.dart';

Future<void> _getForecastRoutine() async {
  final weatherAPI = OpenWeatherMapAPI();
  final currentLocation = /*await getCurrentLocation() ??*/
  Position(latitude: 59.99622572385836, longitude: 29.760391924380315);
  print(currentLocation);
  final weatherList =
  await weatherAPI.getForecastByCoordinates(currentLocation);
  print(weatherList);
  forecast = weatherList;
}


class WeatherPage extends StatelessWidget {
  WeatherPage(this._weather);
  final Weather _weather;

  Future<void> _shareWeather(BuildContext context, Weather weather) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(weather.toString(),
        subject: 'Weather',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: const Text(
                    'Weather',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                )),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _getForecastRoutine,
              color: Colors.black54,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: BlocBuilder<WeatherBloc, Weather>(
        builder: (_, weather) {
          return SizedBox.expand(
            child: Column(
              children: [
                Container(height: 0.5, color: Colors.black26,),
                Expanded(
                  child: ListView(physics: BouncingScrollPhysics(), children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          WeatherWidget(weather: weather),
                          SizedBox(
                            height: 100,
                          ),
                          GestureDetector(
                            child: Text('Forecast for 5 days'),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForecastPage())),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            child: Text(
                              'Share',
                              style: TextStyle(fontSize: 30, color: Colors.orange),
                            ),
                            onTap: () async => await _shareWeather(context, weather),
                          )
                        ]),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}