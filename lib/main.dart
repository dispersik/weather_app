import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app/back/entities/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/pages/weather_page.dart';

import 'back/bloc/bloc_core.dart';
import 'back/bloc/forecast_bloc.dart';
import 'back/bloc/weather_bloc.dart';
import 'back/entities/forecast_state.dart';

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
      child: BlocListener<ForecastBloc, ForecastState>(
        listener: (context, state) {
          if (state != null) {
            if (state.haveError) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1);
              context
                  .read<WeatherBloc>()
                  .add(WeatherEvent(type: WeatherEventType.error));
            }
            if (state.gettingValue) {
              context
                  .read<WeatherBloc>()
                  .add(WeatherEvent(type: WeatherEventType.waitForWeather));
            }
            if (!state.haveError && !state.gettingValue) {
              context.read<WeatherBloc>().add(WeatherEvent(
                  type: WeatherEventType.setWeather,
                  value: (state.forecast != null) ? state.forecast[0] : null));
            }
          } else {}
          // print('forecast new state: ${state.forecast[0]}');
          // TODO match timestamp after updating
          // if (state.forecast != null)

          // context.read<WeatherBloc>().add(WeatherEvent(
          //     type: WeatherEventType.setWeather,
          //     value: (state.forecast != null) ? state.forecast[0] : null));
        },
        child: MaterialApp(home: WeatherPage()),
      ),
    );
  }
}
