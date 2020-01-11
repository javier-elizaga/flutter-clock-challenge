import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class RainyWidget extends StatefulWidget {
  final Size canvasSize;

  RainyWidget({Key key, this.canvasSize}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RainyWidgetState();
}

class _RainyWidgetState extends State<RainyWidget>
    with SingleTickerProviderStateMixin {
  final _numDrops = 50;
  final _animationDuration = Duration(milliseconds: 100);

  final _dropWidth = 2.0;
  final _dropColor = Color(0x77aec2f4);
  final _random = Random();

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _controller
      ..addListener(() {})
      ..addStatusListener((status) {
        // print('Status; $status');
        if (status == AnimationStatus.completed) {
          if (this.mounted) {
            setState(() {});
          }
          _controller
            ..reset()
            ..forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _createRainDrop(double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: _dropWidth,
        height: _random.nextDouble() * 5 + 5,
        color: _dropColor,
      ),
    );
  }

  List<Widget> _createRain(List<double> top, List<double> left) {
    final rain = List<Widget>();
    for (var i = 0; i < min(top.length, left.length); i++) {
      rain.add(_createRainDrop(top[i], left[i]));
    }
    return rain;
  }

  @override
  Widget build(BuildContext context) {
    final top = Iterable.generate(_numDrops)
        .map((_) => _random.nextDouble() * widget.canvasSize.height)
        .toList();
    final left = Iterable.generate(_numDrops)
        .map((_) => _random.nextDouble() * widget.canvasSize.width)
        .toList();
    final rain = _createRain(top, left);
    return Stack(
      children: rain,
    );
  }
}
