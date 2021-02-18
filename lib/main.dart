import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/geolocator_helper.dart';
import 'package:weather_app/back/openweathermap_api.dart';
import 'package:weather_app/back/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:weather_app/widgets/weather_widget.dart';

// void main() {
//   runApp(WeatherApp());
// }
//
// class WeatherApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weather',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       // home: MyHomePage(title: 'Weather'),
//       home: Home(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final weatherAPI = OpenWeatherMapAPI();
//   Position currentLocation;
//   List<Address> detailedAddress;
//   List<Weather> weatherList;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//                 onPressed: () async {
//                   currentLocation = /*await getCurrentLocation() ??*/
//                       Position(
//                           // latitude: 52.42536875588388,
//                           // longitude: 31.021136747104755
//                           latitude: 52.35308471250674,
//                           longitude: 31.106725359980484);
//                   print(currentLocation);
//                   weatherList = await weatherAPI.getForecastByCoordinates(currentLocation);
//                   print(weatherList);
//                 },
//                 child: Text('getCurrentLocation'))
//           ],
//         ),
//       ),
//     );
//   }
// }
/// Custom [BlocObserver] which observes all bloc and cubit instances.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}

List<Weather> forecast = List<Weather>();

Future<List<Weather>> _getForecastRoutine() async {
  final weatherAPI = OpenWeatherMapAPI();
  final currentLocation = /*await getCurrentLocation() ??*/
  Position(
    // latitude: 52.42536875588388,
    // longitude: 31.021136747104755
      latitude: 52.35308471250674,
      longitude: 31.106725359980484);
  print(currentLocation);
  final weatherList = await weatherAPI.getForecastByCoordinates(currentLocation);
  print(weatherList);
  return weatherList;
}

Future<void> main() async {
  forecast =  await _getForecastRoutine();
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

class App extends StatelessWidget {
  final Weather _weather = forecast[0];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => WeatherBloc(_weather),
        child: WeatherPage(),
      ),
    );
  }
}

class ForecastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Forecast'),
        ),
      ),
    );
  }
}

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text(
          'Weather',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        )),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: BlocBuilder<WeatherBloc, Weather>(
        builder: (_, weather) {
          return SizedBox.expand(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WeatherWidget(weather: weather),
                  SizedBox(
                    height: 100,
                  ),
                  GestureDetector(
                    child: Text('Forecast for 5 days'),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForecastPage())),
                  )
                ]
                // Text('$count', style: Theme.of(context).textTheme.headline1),
                ),
          );
        },
      ),
    );
  }
}

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

enum ForecastUpdateEvent { upToDate, outDated }

class ForecastUpdaterBloc extends Bloc<ForecastUpdateEvent, List<Weather>> {
  ForecastUpdaterBloc(List<Weather> initialState) : super(List<Weather>());
  final OpenWeatherMapAPI _api = OpenWeatherMapAPI();

  @override
  Stream<List<Weather>> mapEventToState(ForecastUpdateEvent event) async* {
    switch (event) {
      case ForecastUpdateEvent.outDated:
        var position = await getCurrentLocation();
        var newState = await _api.getForecastByCoordinates(position);
        yield newState;
        break;
      case ForecastUpdateEvent.upToDate:
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}

//
// class CounterBloc extends Bloc<CounterEvent, int> {
//   /// {@macro counter_bloc}
//   CounterBloc() : super(0);
//
//   @override
//   Stream<int> mapEventToState(CounterEvent event) async* {
//     switch (event) {
//       case CounterEvent.decrement:
//         yield state - 1;
//         break;
//       case CounterEvent.increment:
//         yield state + 1;
//         break;
//       default:
//         addError(Exception('unsupported event'));
//     }
//   }
// }
//
// /// {@template brightness_cubit}
// /// A simple [Cubit] which manages the [ThemeData] as its state.
// /// {@endtemplate}
// class ThemeCubit extends Cubit<ThemeData> {
//   /// {@macro brightness_cubit}
//   ThemeCubit() : super(_lightTheme);
//
//   static final _lightTheme = ThemeData(
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       foregroundColor: Colors.white,
//     ),
//     brightness: Brightness.light,
//   );
//
//   static final _darkTheme = ThemeData(
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       foregroundColor: Colors.black,
//     ),
//     brightness: Brightness.dark,
//   );
//
//   /// Toggles the current brightness between light and dark.
//   void toggleTheme() {
//     emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
//   }
// }
