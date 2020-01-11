import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class WeatherIcon extends StatelessWidget {
  final WeatherCondition condition;
  final bool isDay;
  final double size;
  final Color color;

  const WeatherIcon({
    Key key,
    this.condition,
    this.isDay = true,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DayWeatherIcon(
      condition: condition,
      size: size,
      color: color,
    );
  }
}

class DayWeatherIcon extends StatelessWidget {
  final WeatherCondition condition;
  final double size;
  final Color color;

  const DayWeatherIcon({
    Key key,
    this.condition,
    this.size,
    this.color,
  }) : super(key: key);

  Widget sunnyIcon() {
    return Container(
      child: Icon(
        Icons.wb_sunny,
        size: size,
        color: color,
      ),
    );
  }

  Widget cloudyIcon() {
    return Stack(
      children: [
        Icon(
          Icons.wb_sunny,
          size: size * .5,
          color: color.withOpacity(0.8),
        ),
        Icon(
          Icons.wb_cloudy,
          size: size,
          color: color,
        ),
      ],
    );
  }

  Widget foggyIcon() {
    final lineHeight = size / 10;
    final lineBorderRadius = BorderRadius.all(Radius.circular(lineHeight));
    return Container(
      height: size,
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: lineHeight,
              left: 3.0,
              right: 3.0,
            ),
            child: Container(
              height: lineHeight,
              width: size,
              decoration: BoxDecoration(
                borderRadius: lineBorderRadius,
                color: color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: lineHeight,
              right: 6.0,
            ),
            child: Container(
              height: lineHeight,
              width: size,
              decoration: BoxDecoration(
                borderRadius: lineBorderRadius,
                color: color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 4.0,
              bottom: lineHeight,
            ),
            child: Container(
              height: lineHeight,
              width: size,
              decoration: BoxDecoration(
                borderRadius: lineBorderRadius,
                color: color,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 6.0,
            ),
            child: Container(
              height: lineHeight,
              width: size,
              decoration: BoxDecoration(
                borderRadius: lineBorderRadius,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget snowyIcon() {
    return Container(
      height: size,
      width: size,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.ac_unit,
              size: size * .3,
              color: color,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Icon(
              Icons.wb_cloudy,
              size: size * .8,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget dropIcon(double size) {
    return Container(
      height: size,
      width: size,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.lens,
              size: size * .55,
              color: color,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_drop_up,
              size: size * .8,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget rainyIcon() {
    return Container(
      height: size,
      width: size,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: dropIcon(size * .4),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Icon(
              Icons.wb_cloudy,
              size: size * .8,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget thunderstormIcon() {
    return Container(
      height: size,
      width: size,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.flash_on,
              size: size * .4,
              color: color,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Icon(
              Icons.wb_cloudy,
              size: size * .7,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget windyIcon() {
    return CustomPaint(
      size: Size(size, size),
      painter: WindPainter(
        size: size,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (condition == WeatherCondition.sunny) {
      return sunnyIcon();
    } else if (condition == WeatherCondition.cloudy) {
      return cloudyIcon();
    } else if (condition == WeatherCondition.foggy) {
      return foggyIcon();
    } else if (condition == WeatherCondition.rainy) {
      return rainyIcon();
    } else if (condition == WeatherCondition.snowy) {
      return snowyIcon();
    } else if (condition == WeatherCondition.thunderstorm) {
      return thunderstormIcon();
    } else if (condition == WeatherCondition.windy) {
      return windyIcon();
    }

    return Icon(
      Icons.no_encryption,
      size: size,
      color: color,
    );
  }
}

class NightWeatherIcon extends StatelessWidget {
  final WeatherCondition condition;
  final double size;
  final Color color;

  NightWeatherIcon({
    Key key,
    this.condition,
    this.size,
    this.color,
  }) : super(key: key);

  Widget sunnyIcon() {
    return Icon(
      Icons.brightness_low,
      size: size,
      color: color,
    );
  }

  Widget cloudyIcon() {
    return Icon(
      Icons.cloud,
      size: size,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return sunnyIcon();
  }
}

class WindPainter extends CustomPainter {
  final double size;
  final Color color;

  Paint _paint;

  WindPainter({
    this.size,
    this.color = Colors.black,
  }) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = size / 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final firstLineSize = Size(size * .50, size / 3);
    final secondLineSize = Size(size * .55, size / 3);
    final thirdLineSize = Size(size * .60, -size / 3);

    final firstLineOffset = Offset(size * .10, 0 + firstLineSize.height);
    final secondLineOffset =
        Offset(size * .30, size * .15 + firstLineSize.height);
    final thirdLineOffset =
        Offset(size * .20, size * .30 + firstLineSize.height);

    _drawWindLine(canvas, firstLineOffset, firstLineSize);
    _drawWindLine(canvas, secondLineOffset, secondLineSize);
    _drawWindLine(canvas, thirdLineOffset, thirdLineSize);
  }

  void _drawWindLine(Canvas canvas, Offset offset, Size size) {
    final windLine = Path()
      ..moveTo(offset.dx, offset.dy)
      ..lineTo(
        offset.dx + size.width,
        offset.dy,
      )
      ..arcToPoint(
        Offset(
          offset.dx + size.width,
          offset.dy - (2 * size.height / 3),
        ),
        radius: Radius.circular(size.height / 3),
        clockwise: size.height < 0,
      );
    canvas.drawPath(windLine, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
