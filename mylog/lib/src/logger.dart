import 'dart:io';

import 'file.dart';
import 'utils.dart';

class Logging extends LogFileController {
  Level _level = Level.DEBUG;

  static final Logging _singleton = Logging._internal();
  factory Logging() => _singleton;

  Logging._internal() : super();

  void d(String msg) => _log(msg, Level.DEBUG);
  void i(String msg) => _log(msg, Level.INFO);
  void w(String msg) => _log(msg, Level.WARNING);
  void e(String msg) => _log(msg, Level.ERROR);
  void c(String msg) => _log(msg, Level.CRITICAL);

  void setLvl(Level lvl) => _level = lvl;
  set lvl(Level lvl) => _level = lvl;

  /// Build log message, stdout/stderr it and put in [_msgQueue] (add middleware as listeners to this controller)
  void _log(String msg, Level lvl) {
    var _time = DateTime.now().full;
    String _line; // line for file
    if (lvl.index < _level.index) return;
    if (lvl == Level.DEBUG) {
      _line = '$_time [VERB] $msg\n';
      stdout.write(_line);
    } else if (lvl == Level.INFO) {
      _line = '$_time [INFO] $msg\n';
      stdout.write(_line);
    } else if (lvl == Level.WARNING) {
      _line = '$_time [WARN] $msg\n';
      stderr.write(_line);
    } else if (lvl == Level.ERROR) {
      _line = '$_time [ERRO] $msg\n';
      stderr.write(_line);
    } else if (lvl == Level.CRITICAL) {
      _line = '$_time [CRIT] $msg\n';
      stderr.write(_line);
    } else {
      _line = '$_time [UNKNOWN] $msg\n';
      stderr.write(_line);
    }
    super.toFile(_line);
  }
}
