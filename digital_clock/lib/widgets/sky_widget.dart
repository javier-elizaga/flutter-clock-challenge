import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

enum Sky { sunrise, sunset, night }

class SkyWidget extends StatelessWidget {
  final Size size;
  final double sunPosition;
  final WeatherCondition weatherCondition;

  const SkyWidget({Key key, this.size, this.sunPosition, this.weatherCondition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: SkyPainter(
        sunPosition: sunPosition,
        weatherCondition: weatherCondition,
      ),
    );
  }
}

class SkyPainter extends CustomPainter {
  // -1: no sun
  // 0..1: position of sun in the sky
  final double sunPosition;
  final WeatherCondition weatherCondition;

  SkyPainter({
    this.sunPosition,
    this.weatherCondition = WeatherCondition.sunny,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size, sunPosition);
  }

  @override
  bool shouldRepaint(SkyPainter oldDelegate) =>
      oldDelegate.sunPosition != sunPosition;

  Sky get sky => sunPosition == -1
      ? Sky.night
      : sunPosition < 0.10
          ? Sky.sunrise
          : (sunPosition > 0.9 ? Sky.sunset : null);

  void _drawSky(Canvas canvas, Size size, double sunPosition) {
    var colors = List<Color>();
    var stops = List<double>();
    var scaledSunPosition = sunPosition * 10;
    if (sky == Sky.sunset) {
      scaledSunPosition = 10 - scaledSunPosition;
    }

    if (sky == Sky.sunrise || sky == Sky.sunset) {
      colors = [
        Color(0xff001E9A).withOpacity(1 - scaledSunPosition),
        Color(0xffd0456a).withOpacity(1 - scaledSunPosition),
        Color(0xffefdfa8).withOpacity(1 - scaledSunPosition),
      ];
      stops = [
        0,
        scaledSunPosition > 0.76 ? 0 : (1 - scaledSunPosition) / 2,
        scaledSunPosition > 0.76 ? 0 : 1 - scaledSunPosition,
      ];
    } else if (sky == Sky.night) {
      colors = [Color(0xff2c157a)];
      stops = [0];
    } else {
      colors = [Color(0xffe4f6f6)];
      stops = [0];
    }

    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: stops,
    );

    final rect = Rect.fromPoints(
      Offset(0, 0),
      Offset(size.width, size.height),
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
    if (this.weatherCondition != WeatherCondition.sunny) {
      // dim the sky
      canvas.drawRect(
        rect,
        Paint()..color = Colors.black12,
      );
    }
  }
}
