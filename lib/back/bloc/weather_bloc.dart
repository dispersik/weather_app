import 'package:flutter_bloc/flutter_bloc.dart';

import '../weather.dart';

enum WeatherViewEvent {
  init,
  change,
}

class WeatherBloc extends Bloc<WeatherViewEvent, Weather> {
  WeatherBloc(Weather initialState) : super(initialState);

  @override
  Stream<Weather> mapEventToState(WeatherViewEvent event) async* {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}