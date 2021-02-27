import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
        ]);
  }
}