extension DateTimeExtension on DateTime {
  String get date => '$year-${_two(month)}-${_two(day)}';
  String get full => '$year-${_two(month)}-${_two(day)} ${_two(hour)}:${_two(minute)}:${_two(second)}';
  static String _two(int n) => (n >= 10) ? '$n' : '0$n';
}

enum Level { DEBUG, INFO, WARNING, ERROR, CRITICAL }
