import 'package:intl/intl.dart';

enum Range { start, end }

class HourRange {
  final int startHour;
  final int endHour;

  HourRange(this.startHour, this.endHour);
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);

  bool inRange(DateTime date) {
    final inRange = start.isBefore(date) && end.isAfter(date);
    // print('InRange: [$start...$end] $date => $inRange');
    return inRange;
  }

  @override
  String toString() {
    return DateFormat.yMd().add_Hm().format(start) +
        " " +
        DateFormat.yMd().add_Hm().format(end);
  }
}

class SunService {
  double getSunPosition(DateTime date) =>
      _getPositionInRange(date, _sunRange(date));

  double getMoonPosition(DateTime date) =>
      _getPositionInRange(date, _moonRange(date));

  // Returns the position of date in range from 0 to 1.
  // Returns -1 if date is not in range
  double _getPositionInRange(DateTime date, DateRange range) {
    double position = 0;
    if (range.inRange(date)) {
      // scale date.start ... date.end to 0...1
      // (cur - min) / (max - min)
      final dividend = date.difference(range.start).inMilliseconds;
      final divisor = range.end.difference(range.start).inMilliseconds;
      position = dividend / divisor;
    } else {
      position = -1;
    }
    return position;
  }

  // No Api allowed :-(
  final _sunHourRange = HourRange(7, 18);
  final _moonHourRange = HourRange(18, 7);

  DateRange _sunRange(DateTime d) => _createRange(d, _sunHourRange);

  DateRange _moonRange(DateTime d) => _createRange(d, _moonHourRange);

  DateRange _createRange(DateTime d, HourRange range) {
    int startDay;
    int endDay;
    if (range.startHour > range.endHour) {
      startDay = d.hour >= range.startHour && d.hour < 24 ? d.day : d.day - 1;
      endDay = d.hour > range.startHour && d.hour < 24 ? d.day + 1 : d.day;
    } else {
      startDay = d.day;
      endDay = d.day;
    }
    return DateRange(
      DateTime(d.year, d.month, startDay, range.startHour),
      DateTime(d.year, d.month, endDay, range.endHour),
    );
  }
}
