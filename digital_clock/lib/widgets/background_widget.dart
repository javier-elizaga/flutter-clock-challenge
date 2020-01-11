import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class BackgroundWidget extends StatelessWidget {
  final Size size;
  final MaterialColor colorTheme;
  final double earthRatio;
  final bool isDay;
  final WeatherCondition weatherCondition;

  const BackgroundWidget({
    Key key,
    this.size,
    this.colorTheme,
    this.earthRatio,
    this.isDay,
    this.weatherCondition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: BackgroundPainter(
        theme: colorTheme,
        earthRatio: earthRatio,
        isDay: isDay,
        weatherCondition: weatherCondition,
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final MaterialColor theme;
  final WeatherCondition weatherCondition;
  final bool isDay;
  final double earthRatio;

  Paint _earthPaint;
  Paint _moutain1Paint;
  Paint _moutain2Paint;
  Paint _treeCrownPaint;
  Paint _treeTrunkPaint;
  Paint _houseFrontPaint;
  Paint _houseBackPaint;
  Paint _houseRoofPaint;
  Paint _houseWoodPaint;
  Paint _houseWindowDayPaint;
  Paint _houseWindowNightPaint;
  Paint _snowPaintFill;
  Paint _snowPaintStroke;

  BackgroundPainter({
    this.theme = Colors.green,
    this.earthRatio = (2 / 5),
    this.isDay = false,
    this.weatherCondition = WeatherCondition.sunny,
  }) {
    _earthPaint = Paint()..color = theme[800];
    _moutain1Paint = Paint()..color = theme[500];
    _moutain2Paint = Paint()..color = theme[900];
    _treeCrownPaint = Paint()..color = theme[500];
    _treeTrunkPaint = Paint()..color = Colors.brown[600];
    _houseFrontPaint = Paint()..color = Colors.grey[100];
    _houseBackPaint = Paint()..color = Colors.grey[300];
    _houseRoofPaint = Paint()..color = Colors.red[900];
    _houseWoodPaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = Colors.brown[500];
    _houseWindowDayPaint = Paint()..color = Colors.blue[500];
    _houseWindowNightPaint = Paint()..color = Colors.yellow[600];
    _snowPaintFill = Paint()..color = Colors.white;
    _snowPaintStroke = Paint()
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawMtns(canvas, size);
    _drawTree(canvas, size);
    _drawEarth(canvas, size);
    _drawHouse(canvas, size);
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      oldDelegate.weatherCondition != weatherCondition;

  void _drawEarth(Canvas canvas, Size size) {
    final earthSize = _earthSize(size);
    canvas.drawRect(
      Rect.fromPoints(
        Offset(0, size.height - earthSize.height),
        Offset(earthSize.width, size.height),
      ),
      _earthPaint,
    );
  }

  void _drawMtns(Canvas canvas, Size size) {
    _drawSecondMtn(canvas, size);
    _drawFirstMtn(canvas, size);
  }

  void _drawFirstMtn(Canvas canvas, Size size) {
    final mtnSize = _firstMtnSize(size);
    final mtnOffset = _firstMtnOffset(size);

    canvas.drawPath(
      Path()
        ..moveTo(mtnOffset.dx, mtnOffset.dy)
        ..lineTo(
          mtnOffset.dx + mtnSize.width / 2,
          mtnOffset.dy - mtnSize.height,
        )
        ..lineTo(
          mtnOffset.dx + mtnSize.width,
          mtnOffset.dy,
        )
        ..close(),
      _moutain1Paint,
    );
    if (weatherCondition == WeatherCondition.snowy) {
      _drawSnowMtn(canvas, size, mtnSize, mtnOffset);
    }
  }

  void _drawSecondMtn(Canvas canvas, Size size) {
    final mtnSize = _secondMtnSize(size);
    final mtnOffset = _secondMtnOffset(size);
    canvas.drawPath(
      Path()
        ..moveTo(mtnOffset.dx, mtnOffset.dy)
        ..lineTo(
          mtnOffset.dx + mtnSize.width / 2,
          mtnOffset.dy - mtnSize.height,
        )
        ..lineTo(
          mtnOffset.dx + mtnSize.width,
          mtnOffset.dy,
        )
        ..close(),
      _moutain2Paint,
    );

    if (weatherCondition == WeatherCondition.snowy) {
      _drawSnowMtn(canvas, size, mtnSize, mtnOffset);
    }
  }

  void _drawTree(Canvas canvas, Size size) {
    final treeSize = _treeSize(size);
    final treeOffset = _treeOffset(size);
    final trunkSize = Size(treeSize.width / 5, treeSize.height / 4);
    final trunk = Rect.fromPoints(
      Offset(treeOffset.dx, treeOffset.dy),
      Offset(treeOffset.dx + trunkSize.width, treeOffset.dy - trunkSize.height),
    );
    canvas.drawRect(
      trunk,
      _treeTrunkPaint,
    );
    final crownRect = Rect.fromPoints(
      Offset(
        treeOffset.dx - treeSize.width / 2 + trunkSize.width / 2,
        treeOffset.dy - treeSize.height / 4,
      ),
      Offset(
        treeOffset.dx + treeSize.width / 2 + trunkSize.width / 2,
        treeOffset.dy - treeSize.height,
      ),
    );
    canvas.drawRect(
      crownRect,
      _treeCrownPaint,
    );

    if (weatherCondition == WeatherCondition.snowy) {
      canvas.drawRect(
        Rect.fromPoints(
          crownRect.topLeft,
          crownRect.centerRight,
        ),
        _snowPaintFill,
      );
      canvas.drawRect(
        Rect.fromPoints(
          crownRect.topLeft,
          crownRect.centerRight,
        ),
        _snowPaintStroke,
      );
    }
  }

  void _drawHouse(Canvas canvas, Size size) {
    final houseSize = Size(100, 80);
    final earthSize = _earthSize(size);
    final offset = Offset(size.width * (3 / 5),
        size.height - earthSize.height + (size.height / 10));
    canvas.drawPath(
      Path()
        ..moveTo(offset.dx, offset.dy)
        ..lineTo(
          offset.dx,
          offset.dy - (houseSize.height / 2),
        )
        ..lineTo(
          offset.dx + (houseSize.width / 4),
          offset.dy - houseSize.height,
        )
        ..lineTo(
          offset.dx + (houseSize.width / 2) + 1,
          offset.dy - (houseSize.height / 2),
        )
        ..lineTo(
          offset.dx + (houseSize.width / 2) + 1,
          offset.dy,
        )
        ..close(),
      _houseFrontPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        Offset(
          offset.dx + (houseSize.width / 2),
          offset.dy - (houseSize.height / 2),
        ),
        Offset(offset.dx + (houseSize.width), offset.dy),
      ),
      _houseBackPaint,
    );

    final roof = Path()
      // bottom left
      ..moveTo(
        offset.dx + (houseSize.width / 2),
        offset.dy - (houseSize.height / 2),
      )
      // top left
      ..lineTo(
        offset.dx + (houseSize.width / 4),
        offset.dy - houseSize.height,
      )
      // top right
      ..lineTo(
        offset.dx + (houseSize.width * 3 / 4),
        offset.dy - houseSize.height,
      )
      ..lineTo(
        offset.dx + houseSize.width,
        offset.dy - (houseSize.height / 2),
      )
      ..close();
    canvas.drawPath(roof, _houseRoofPaint);
    // door
    final doorSize = houseSize.width / 10;
    final doorOffset = Offset(houseSize.width / 5, houseSize.height / 4);
    canvas.drawRect(
      Rect.fromPoints(
        Offset(offset.dx + doorOffset.dx, offset.dy - doorOffset.dy),
        Offset(offset.dx + doorOffset.dx + doorSize, offset.dy),
      ),
      Paint()..color = Colors.brown,
    );

    // windows
    final windowSize = houseSize.width / 10;
    final windowPaint = isDay ? _houseWindowDayPaint : _houseWindowNightPaint;

    final windowOffset = Offset(houseSize.width / 5, houseSize.height / 2);
    final windowRect = Rect.fromPoints(
      Offset(
        offset.dx + windowOffset.dx,
        offset.dy - windowOffset.dy,
      ),
      Offset(offset.dx + windowOffset.dx + windowSize,
          offset.dy - windowOffset.dy - windowSize),
    );
    canvas.drawRect(windowRect, windowPaint);
    canvas.drawRect(windowRect, _houseWoodPaint);

    final window1Offset = Offset(55, houseSize.height / 4);
    final window1Rect = Rect.fromPoints(
      Offset(
        offset.dx + window1Offset.dx,
        offset.dy - window1Offset.dy,
      ),
      Offset(
        offset.dx + window1Offset.dx + windowSize,
        offset.dy - window1Offset.dy - windowSize,
      ),
    );
    canvas.drawRect(window1Rect, windowPaint);
    canvas.drawRect(window1Rect, _houseWoodPaint);

    final window2Offset = Offset(70, houseSize.height / 4);
    final window2Rect = Rect.fromPoints(
      Offset(offset.dx + window2Offset.dx, offset.dy - window2Offset.dy),
      Offset(offset.dx + window2Offset.dx + windowSize,
          offset.dy - window2Offset.dy - windowSize),
    );
    canvas.drawRect(window2Rect, windowPaint);
    canvas.drawRect(window2Rect, _houseWoodPaint);

    final window3Offset = Offset(85, houseSize.height / 4);
    final window3Rect = Rect.fromPoints(
      Offset(offset.dx + window3Offset.dx, offset.dy - window3Offset.dy),
      Offset(offset.dx + window3Offset.dx + windowSize,
          offset.dy - window3Offset.dy - windowSize),
    );
    canvas.drawRect(window3Rect, windowPaint);
    canvas.drawRect(window3Rect, _houseWoodPaint);
  }

  void _drawSnowMtn(
    Canvas canvas,
    Size size,
    Size mtnSize,
    Offset mtnOffset,
  ) {
    final m = mtnSize.height / (mtnSize.width / 2);
    final b = 0;
    final x = mtnSize.width / 3;
    final y = m * x + b;

    canvas.drawPath(
      Path()
        ..moveTo(
          mtnOffset.dx + x,
          mtnOffset.dy - y,
        )
        ..lineTo(
          mtnOffset.dx + mtnSize.width / 2,
          mtnOffset.dy - mtnSize.height,
        )
        ..lineTo(
          mtnOffset.dx + (mtnSize.width - x),
          mtnOffset.dy - y,
        )
        ..close(),
      _snowPaintFill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(
          mtnOffset.dx + x,
          mtnOffset.dy - y,
        )
        ..lineTo(
          mtnOffset.dx + mtnSize.width / 2,
          mtnOffset.dy - mtnSize.height,
        )
        ..lineTo(
          mtnOffset.dx + (mtnSize.width - x),
          mtnOffset.dy - y,
        )
        ..close(),
      _snowPaintStroke,
    );
  }

  // sizes
  Size _earthSize(Size size) => Size(size.width, size.height * earthRatio);

  Size _firstMtnSize(Size size) {
    final mtnSize = Size(size.width / 2, size.height / 2);
    return Size(
      mtnSize.width,
      mtnSize.height,
    );
  }

  Offset _firstMtnOffset(Size size) {
    final earthSize = _earthSize(size);
    return Offset(
      0,
      size.height - earthSize.height,
    );
  }

  Size _secondMtnSize(Size size) {
    final mtnSize = Size(size.width * (2 / 5), size.height * (1 / 3));
    return Size(
      mtnSize.width,
      mtnSize.height,
    );
  }

  Offset _secondMtnOffset(Size size) {
    final earthSize = _earthSize(size);
    return Offset(
      size.width / 4,
      size.height - earthSize.height,
    );
  }

  Size _treeSize(Size size) {
    final earthSize = _earthSize(size);
    final treeHeight = earthSize.height / 2;
    final treeWidth = treeHeight / 2;
    return Size(treeWidth, treeHeight);
  }

  Offset _treeOffset(Size size) {
    final earthSize = _earthSize(size);
    return Offset(
      size.width - (size.width / 7),
      size.height - earthSize.height,
    );
  }
}
