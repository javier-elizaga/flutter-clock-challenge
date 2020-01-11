import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class MoonWidget extends StatelessWidget {
  final Size canvasSize;
  final double iconSize;
  final double position;

  const MoonWidget({
    Key key,
    this.canvasSize,
    this.iconSize,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (position == -1) {
      // no sun, nothing to do
      return Container();
    }
    final r = canvasSize.width / 3;
    final r2 = pow(r, 2);
    final x = (position * (2 * r)) - r;
    final x2 = pow(x, 2);
    final y = sqrt(r2 - x2);
    final offset =
        Offset(x + (canvasSize.width / 2), (2 * canvasSize.height / 3) - y);
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Transform.rotate(
        angle: 300 * pi / 360,
        child: Icon(
          Icons.brightness_3,
          size: iconSize,
          color: Color(0xfffaba49),
        ),
      ),
    );
  }
}
