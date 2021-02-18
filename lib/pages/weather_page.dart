import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:weather_app/back/bloc/forecast_bloc.dart';
import 'package:weather_app/back/bloc/weather_bloc.dart';
import 'package:weather_app/back/openweathermap_api.dart';
import 'package:weather_app/back/weather.dart';
import 'package:weather_app/widgets/weather_widget.dart';

import '../main.dart';
import 'forecast_page.dart';

class WeatherPage extends StatelessWidget {
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
              onPressed: () {
                context.read<ForecastBloc>().add(ForecastEvent.getNewForecast);
              },
              color: Colors.black54,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: BlocBuilder<WeatherBloc, Weather>(
        builder: (_, weather) {
          if (weather == null)
            context.read<ForecastBloc>().add(ForecastEvent.getNewForecast);
          return SizedBox.expand(
            child: Column(
              children: [
                Container(
                  height: 0.5,
                  color: Colors.black26,
                ),
                Expanded(
                  child: ListView(physics: BouncingScrollPhysics(), children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: (weather != null)
                          ? [
                              WeatherWidget(weather: weather),
                              SizedBox(
                                height: 70,
                              ),
                              GestureDetector(
                                child: Text(
                                  'Forecast for 5 days',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w300),
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
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w300),
                                ),
                                onTap: () async =>
                                    await _shareWeather(context, weather),
                              )
                            ]
                          : [
                              SizedBox(
                                height: 100,
                              ),
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                  )),
                              SizedBox(
                                height: 100,
                              ),
                              Text(
                                'initializing',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 20),
                              )
                            ],
                    ),
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
