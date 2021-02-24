import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:weather_app/back/bloc/forecast_bloc.dart';
import 'package:weather_app/back/bloc/weather_bloc.dart';
import 'package:weather_app/back/repository/openweathermap_api.dart';
import 'package:weather_app/back/weather.dart';
import 'package:weather_app/widgets/ui_helper.dart';
import 'package:weather_app/widgets/weather_widget.dart';
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
              padding: const EdgeInsets.only(left: 50.0),
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
        builder: (context, weather) {
          if (weather == null && !context.read<ForecastBloc>().busy)
            context.read<ForecastBloc>().add(ForecastEvent.getNewForecast);
          return SizedBox.expand(
              child: Column(children: [
            Container(
              height: 0.5,
              color: Colors.black26,
            ),
            Expanded(
              child: (weather != null)
                  ? ListView(physics: BouncingScrollPhysics(), children: [
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
                    ])
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: (context.read<ForecastBloc>().state.haveError)
                          ? [
                              Text(
                                  'Cannot obtain forecast'),
                              ElevatedButton(
                                  onPressed: () => context
                                      .read<ForecastBloc>()
                                      .add(ForecastEvent.getNewForecast),
                                  child: Text('try again'))
                            ]
                          : [
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'initializing',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 20),
                              ),
                            ]),
            ),
          ]));
        },
      ),
    );
  }
}

final _shareButtonStyle =
    TextStyle(fontSize: 30, color: Colors.orange, fontWeight: FontWeight.w300);

final _forecastButtonStyle =
    TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.w300);
