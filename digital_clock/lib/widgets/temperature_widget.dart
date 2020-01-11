import 'package:flutter/material.dart';

class TemperatureWidget extends StatelessWidget {
  final num current;
  final num low;
  final num high;
  final String unit;

  const TemperatureWidget({
    Key key,
    this.current,
    this.low,
    this.high,
    this.unit,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            '$current $unit',
            style: TextStyle(fontSize: 45),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: 100,
            height: 1.0,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            '$low / $high $unit',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ],
    );
  }
}
