import 'package:digital_clock/widgets/cloudy_widget.dart';
import 'package:digital_clock/widgets/foogy_widget.dart';
import 'package:digital_clock/widgets/rainy_widget.dart';
import 'package:digital_clock/widgets/snowy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class WeatherWidget extends StatelessWidget {
  final Size size;
  final double earthRatio;
  final WeatherCondition condition;

  const WeatherWidget({
    Key key,
    this.size,
    this.earthRatio,
    this.condition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skySize = Size(size.width, size.height - earthRatio * size.height);
    Widget widget;
    if (condition == WeatherCondition.rainy) {
      widget = RainyWidget(canvasSize: skySize);
    } else if (condition == WeatherCondition.snowy) {
      widget = SnowyWidget(canvasSize: skySize);
    } else if (condition == WeatherCondition.thunderstorm) {
      widget = RainyWidget(canvasSize: skySize);
    } else if (condition == WeatherCondition.foggy) {
      widget = FoggyWidget(canvasSize: size);
    } else if (condition == WeatherCondition.cloudy) {
      widget = CloudyWidget(canvasSize: size);
    } else if (condition == WeatherCondition.windy) {
      widget = CloudyWidget(
        canvasSize: size,
        numClouds: 5,
        cloudSpeed: Duration(seconds: 5),
      );
    } else {
      widget = Container();
    }
    return widget;
  }
}
