import 'package:intl/intl.dart';

class TimeFormater {
  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = DateFormat('HH:mm');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'day ago';
      } else {
        time = diff.inDays.toString() + 'days ago';
      }
    }
    return time;
  }
}