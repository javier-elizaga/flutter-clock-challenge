import 'dart:ui';

import 'package:flutter/material.dart';

class CloudyWidget extends StatefulWidget {
  final Size canvasSize;
  final Duration cloudSpeed;
  final int numClouds;

  CloudyWidget({
    Key key,
    this.canvasSize,
    this.cloudSpeed = const Duration(seconds: 20),
    this.numClouds = 5,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CloudWidgetState();
}

class _CloudWidgetState extends State<CloudyWidget>
    with TickerProviderStateMixin {
  final _controllers = List<AnimationController>();
  final _animations = List<Animation>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  void didUpdateWidget(CloudyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cloudSpeed != widget.cloudSpeed ||
        oldWidget.numClouds != widget.numClouds) {
      _controllers.forEach((controller) {
        controller
          ..reset()
          ..dispose();
      });
      _animations.removeWhere((x) => true);
      _controllers.removeWhere((x) => true);
      _initialize();
    }
  }

  final _cloudHeights = [240.0, 200.0, 220.0, 180.0];

  @override
  Widget build(BuildContext context) {
    final children = _animations.asMap().keys.map((index) {
      return AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          return CustomPaint(
            size: widget.canvasSize,
            painter: CloudPainter(
              position: _animations[index].value,
              height: _cloudHeights[index % _cloudHeights.length],
            ),
          );
        },
      );
    }).toList();
    return Stack(children: children);
  }

  void _initialize() {
    final inc = (widget.cloudSpeed.inSeconds / widget.numClouds).floor();
    for (var i = 0; i < widget.numClouds; i++) {
      final controller = _createCloudController();
      Future.delayed(Duration(seconds: (i * inc) + 1), () {
        if (mounted) {
          controller.forward();
        }
      });
      _controllers.add(controller);
    }
    _animations.addAll(_controllers
        .map((controller) => Tween(
              begin: 0.0,
              end: 1.0,
            ).animate(controller))
        .toList());
  }

  AnimationController _createCloudController() {
    final controller = AnimationController(
      vsync: this,
      duration: widget.cloudSpeed,
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    return controller;
  }
}

class CloudPainter extends CustomPainter {
  // 0.0 to 1.0
  final double position;
  final double height;
  final Color color;

  final Size cloudSize;

  Paint _paint;

  CloudPainter({
    this.position = 0.0,
    this.height = 100.0,
    this.color = const Color(0xddffffff),
    this.cloudSize = const Size(85, 40),
  }) {
    _paint = Paint()..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final max = size.width;
    final min = -cloudSize.width;
    final x = (max - min) * position + min;
    final y = size.height - height;

    final o = Offset(x, y);

    final path = Path()
      ..moveTo(o.dx, o.dy)
      ..quadraticBezierTo(o.dx + 00, o.dy - 10, o.dx + 10, o.dy - 10)
      ..quadraticBezierTo(o.dx + 15, o.dy - 30, o.dx + 30, o.dy - 25)
      ..quadraticBezierTo(o.dx + 40, o.dy - 40, o.dx + 50, o.dy - 25)
      ..quadraticBezierTo(o.dx + 70, o.dy - 25, o.dx + 70, o.dy - 10)
      ..quadraticBezierTo(o.dx + 80, o.dy - 10, o.dx + 80, o.dy - 00)
      ..close();
    canvas
      ..clipRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CloudPainter oldDelegate) =>
      oldDelegate.position != position;
}
