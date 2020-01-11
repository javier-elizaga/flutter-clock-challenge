import 'dart:ui';

import 'package:flutter/material.dart';

class FoggyWidget extends StatefulWidget {
  final Size canvasSize;

  FoggyWidget({Key key, this.canvasSize}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoggyWidgetState();
}

class _FoggyWidgetState extends State<FoggyWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    _animation = Tween(begin: .6, end: .8).animate(_controller);
    _animation
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => CustomPaint(
        size: widget.canvasSize,
        painter: FoggyPainter(value: _animation.value),
      ),
    );
  }
}

class FoggyPainter extends CustomPainter {
  final double value;

  FoggyPainter({this.value = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    _drawFog(canvas, size, value);
  }

  @override
  bool shouldRepaint(FoggyPainter oldDelegate) => oldDelegate.value != value;

  void _drawFog(Canvas canvas, Size size, double value) {
    var colors = List<Color>();
    var stops = List<double>();

    colors = [
      Color(0xffe4f6f6).withOpacity(0),
      Color(0xffe4f6f6),
    ];
    stops = [
      0,
      value,
    ];

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
  }
}
