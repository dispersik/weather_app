import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app/back/bloc/scheduler_bloc.dart';
import 'package:weather_app/back/forecast.dart';
import 'package:weather_app/back/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/pages/weather_page.dart';

import 'back/bloc/bloc_core.dart';
import 'back/bloc/forecast_bloc.dart';
import 'back/bloc/weather_bloc.dart';

List<Weather> forecast = List<Weather>();

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ForecastBloc()),
        BlocProvider(create: (context) => WeatherBloc()),
      ],
      child: BlocListener<ForecastBloc, Forecast>(
        listener: (context, state) {
          print('forecast new state: ${state.forecast[0]}');
          // TODO match timestamp after updating
          context.read<WeatherBloc>().add(WeatherEvent.setCurrentWeather);
          // Fluttertoast.showToast(
          //     msg: "MESSage".toUpperCase(),
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1
          // );
        },
        child: MaterialApp(home: WeatherPage()),
      ),
    );
  }
}
