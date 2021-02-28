import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/back/bloc/forecast_bloc.dart';
import 'package:weather_app/back/bloc/weather_bloc.dart';
import 'package:weather_app/back/entities/forecast_state.dart';
import 'package:weather_app/back/entities/weather_state.dart';
import 'package:weather_app/widgets/weather/weather_err.dart';
import 'package:weather_app/widgets/weather/weather_loading.dart';
import 'package:weather_app/widgets/weather/weather_view.dart';

class WeatherPage extends StatelessWidget {
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
                context.read<ForecastBloc>().add(ForecastEvent.getForecast);
              },
              color: Colors.black54,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, weather) {
          if (weather == null && (context.read<ForecastBloc>().state == null ||
              context.read<ForecastBloc>().state.state !=
                  ForecastStates.gettingValue))
            context.read<ForecastBloc>().add(ForecastEvent.getForecast);
          return SizedBox.expand(
              child: Column(children: [
            Container(
              height: 0.5,
              color: Colors.black26,
            ),
            Expanded(
              child: (weather != null && weather.state == WeatherStates.view)
                  ? WeatherView(weather)
                  : (weather != null && weather.state == WeatherStates.err)
                      ? WeatherErr(weather)
                      : WeatherLoading(),
            ),
          ]));
        },
      ),
    );
  }
}
