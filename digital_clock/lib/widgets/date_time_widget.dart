import 'package:flutter/material.dart';

class DateTimeWidget extends StatelessWidget {
  final Size size;
  final String time;
  final String date;
  final TextStyle timeTextStyle;
  final TextStyle dateTextStyle;

  const DateTimeWidget({
    Key key,
    this.size,
    this.time,
    this.date,
    this.timeTextStyle,
    this.dateTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.only(bottom: 6.0, top: 12.0, left: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(time, style: timeTextStyle),
              ),
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(date, style: dateTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
