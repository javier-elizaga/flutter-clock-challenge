import 'package:flutter/material.dart';

class WeatherBadge extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color color;

  const WeatherBadge({
    Key key,
    this.icon,
    this.label,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(color: color)),
              HozLineWidget(color: color),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}

class HozLineWidget extends StatelessWidget {
  const HozLineWidget({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Container(
        height: 20.0,
        width: 1.0,
        color: color,
      ),
    );
  }
}
