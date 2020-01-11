import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SnowyWidget extends StatefulWidget {
  final Size canvasSize;

  SnowyWidget({Key key, this.canvasSize}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SnowyWidgetState();
}

class _SnowyWidgetState extends State<SnowyWidget>
    with SingleTickerProviderStateMixin {
  final _numDrops = 50;
  final _animationDuration = Duration(milliseconds: 100);
  final _snowWidth = 5.0;
  final _snowFlakeColor = Color(0x88ffffff);
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

  Widget _createSnowFlake(double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: _random.nextDouble() + _snowWidth,
        height: _random.nextDouble() + _snowWidth,
        decoration: BoxDecoration(
          color: _snowFlakeColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  List<Widget> _createSnow(List<double> top, List<double> left) {
    final rain = List<Widget>();
    for (var i = 0; i < min(top.length, left.length); i++) {
      rain.add(_createSnowFlake(top[i], left[i]));
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
    final rain = _createSnow(top, left);
    return Stack(
      children: rain,
    );
  }
}
