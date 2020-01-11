import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SunWidget extends StatelessWidget {
  final Size size;
  final double iconSize;
  final double position;

  const SunWidget({
    Key key,
    this.size,
    this.iconSize,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (position == -1) {
      // no sun, nothing to do
      return Container();
    }

    final r = size.width / 3;
    final r2 = pow(r, 2);
    final x = (position * (2 * r)) - r;
    final x2 = pow(x, 2);
    final y = sqrt(r2 - x2);
    final offset = Offset(
      x + (size.width / 2),
      max(iconSize, (2 * size.height / 3) - y),
    );
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Icon(
        Icons.brightness_1,
        size: 30.0,
        color: Color(0xfffaba49),
      ),
    );
  }
}
