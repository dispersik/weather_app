import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/back/bloc/forecast_bloc.dart';
import 'package:weather_app/back/bloc/weather_bloc.dart';
import 'package:weather_app/back/forecast.dart';
import 'package:weather_app/back/helper.dart';
import 'package:weather_app/pages/weather_page.dart';

import '../main.dart';

class ForecastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Center(
            child: Text('Forecast for ${forecast[0].city}',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w300)),
          ),
        ),
        body: BlocBuilder<ForecastBloc, Forecast>(
            builder: (context, _forecast) => Column(
                  children: [
                    Container(
                      height: 0.5,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemCount: _forecast.forecast.length + 5,
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.black,
                              ),
                          itemBuilder: (context, index) =>
                              _buildTiles(context, index, _forecast)),
                    ),
                  ],
                )));
  }

  Widget _buildTiles(BuildContext context, int index, Forecast forecast) {
    var itemsList = List<ListTile>();
    var _forecast = forecast.forecast;
    itemsList.add(ListTile(
      title: Text('Today',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
    ));
    _forecast.forEach((element) {
      itemsList.add(ListTile(
        shape: Border(
          top: BorderSide(width: double.infinity, color: Colors.black),
        ),
        leading:
        // Image.asset(
        //   'assets/openweathermap_icons/' +
        //       element.weatherDescription.iconName +
        //       '.png',
        //   scale: 1,
        //   isAntiAlias: true,
        // ),
        SvgPicture.asset(
            'assets/opensource_weather_icons/' +
                element.weatherDescription.iconName +
                '.svg',
            height: 40,
            width: 40,
            color:
            (!(element.weatherDescription.iconName.indexOf('n') !=
                -1||element.weatherDescription.iconName.indexOf('13') !=
                -1))
                ? Colors.yellow[800]
                : Colors.black26),
        title: Text('${element.datetime.hour}:00'),
        subtitle: Text('${element.weatherDescription.description}'),
        trailing: Text(
          '${element.temperature}°C',
          style: TextStyle(
              fontSize: 40,
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.w300),
        ),
        onTap: () {
          context.read<WeatherBloc>()
            ..index(_forecast.indexOf(element))
            ..add(WeatherEvent.setByIndex);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => WeatherPage()));
        },
      ));
      if (element.datetime.hour == 21)
        itemsList.add(ListTile(
            title: Text(
          weekdayToReadableDay(
              element.datetime.weekday == 7 ? 1 : element.datetime.weekday + 1),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
        )));
    });
    return itemsList[index];
  }
}
