// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:digital_clock/services/sun_service.dart';
import 'package:digital_clock/widgets/background_widget.dart';
import 'package:digital_clock/widgets/date_time_widget.dart';
import 'package:digital_clock/widgets/moon_widget.dart';
import 'package:digital_clock/widgets/sky_widget.dart';
import 'package:digital_clock/widgets/sun_widget.dart';
import 'package:digital_clock/widgets/weather_badge.dart';
import 'package:digital_clock/widgets/weather_icon.dart';
import 'package:digital_clock/widgets/weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  final _sunService = SunService();
  final _earthRatio = 2 / 5;

  DateTime _dateTime = DateTime.now();
  Timer _timer;

  double _sunPosition = -1;
  double _moonPosition = -1;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
      _updateAnimations(_dateTime);
    });
  }

  void _updateAnimations(DateTime date) {
    final sunPosition = _sunService.getSunPosition(date);
    final moonPosition = _sunService.getMoonPosition(date);
    if (sunPosition != _sunPosition || moonPosition != _moonPosition) {
      setState(() {
        _sunPosition = sunPosition;
        _moonPosition = moonPosition;
      });
    }
  }

  bool get _is24 => widget.model.is24HourFormat;

  String get _hour => DateFormat(_is24 ? 'HH' : 'hh').format(_dateTime);

  String get _minutes => DateFormat('mm').format(_dateTime);

  String get _clockTime => '$_hour:$_minutes';

  String get _clockDate => DateFormat.yMMMMd().format(_dateTime);

  WeatherCondition get _weatherCondition => widget.model.weatherCondition;

  String get _temperatureString => widget.model.temperatureString;

  @override
  Widget build(BuildContext context) {
    final isThemeLight = Theme.of(context).brightness == Brightness.light;
    final colorTheme = isThemeLight ? Colors.green : Colors.blueGrey;
    final timeTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: _weatherCondition == WeatherCondition.foggy
          ? Colors.black87
          : Colors.white,
      shadows: [
        Shadow(
          blurRadius: 2,
          color: Colors.black38,
          offset: Offset(0.5, 0.5),
        ),
      ],
    );
    final dateTextStyle = timeTextStyle.copyWith(fontSize: 30);
    final iconSize = 20.0;
    final sunSize = 30.0;
    final size = MediaQuery.of(context).size;
    final badgeFontColor = timeTextStyle.color;

    var arSizeWidth = size.width;
    var arSizeHeight = size.height;
    arSizeHeight = min((size.width * 3 / 5), arSizeHeight);
    arSizeWidth = min((arSizeHeight * 5 / 3), arSizeWidth);
    final arSize = Size(arSizeWidth, arSizeHeight);
    final earthHeight = arSize.height * _earthRatio;
    final skySize = Size(arSize.width, arSize.height - earthHeight);
    return Stack(
      children: [
        SkyWidget(
          size: skySize,
          sunPosition: _sunPosition,
          weatherCondition: _weatherCondition,
        ),
        MoonWidget(
          canvasSize: arSize,
          iconSize: sunSize,
          position: _moonPosition,
        ),
        SunWidget(
          size: arSize,
          iconSize: sunSize,
          position: _sunPosition,
        ),
        BackgroundWidget(
          size: arSize,
          colorTheme: colorTheme,
          earthRatio: _earthRatio,
          isDay: _sunPosition != -1,
          weatherCondition: _weatherCondition,
        ),
        WeatherWidget(
          size: arSize,
          earthRatio: _earthRatio,
          condition: _weatherCondition,
        ),
        WeatherBadge(
          icon: WeatherIcon(
            condition: _weatherCondition,
            size: iconSize,
            color: badgeFontColor,
          ),
          label: _temperatureString,
          color: badgeFontColor,
        ),
        DateTimeWidget(
          size: Size(arSize.width, earthHeight),
          time: _clockTime,
          timeTextStyle: timeTextStyle,
          date: _clockDate,
          dateTextStyle: dateTextStyle,
        ),
      ],
    );
  }
}
