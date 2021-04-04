import 'dart:async';
import 'dart:io';

import 'utils.dart';

class Logging {
  late File _file;
  String _fileDate;
  Level _level = Level.DEBUG;
  final _msgQueue = StreamController<String>();

  static final Logging _singleton = Logging._internal();
  factory Logging() => _singleton;

  Logging._internal() : _fileDate = DateTime.now().date {
    _init();
  }

  void d(String msg) => _log(msg, Level.DEBUG);
  void i(String msg) => _log(msg, Level.INFO);
  void w(String msg) => _log(msg, Level.WARNING);
  void e(String msg) => _log(msg, Level.ERROR);
  void c(String msg) => _log(msg, Level.CRITICAL);

  /// Check for directory and set [_file]
  Future<void> _init() async {
    // _stream = _loggerStream();
    _file = await _initialDirFile();
    var _stream = _msgQueue.stream;
    _stream.listen((event) async => await _logFile(event));
  }

  /// Check exist or create logs directory then return [File]
  Future<File> _initialDirFile() async {
    final _dir = Directory('logs');
    if (!await _dir.exists()) await _dir.create();
    return File('logs/${DateTime.now().date}.log');
  }

  /// Build log message, stdout/stderr it and put in [_msgQueue] (add middleware as listeners to this controller)
  void _log(String msg, Level lvl) {
    var _time = DateTime.now().full;
    String _line; // line for file
    if (lvl.index > _level.index) return;
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
    _msgQueue.add(_line);
  }

  Future<void> _logFile(String row) async {
    // await _file.writeAsString(row);
    var _sink = _file.openWrite(mode: FileMode.writeOnlyAppend);
    _sink.write(row);
    // Close the IOSink to free system resources.
    await _sink.close();
  }

  /// Check new date to change [_file]
  void _checkFileDate() {
    var _today = DateTime.now().date;
    if (_fileDate != _today) {
      _fileDate = _today;
      _file = File('logs/$_fileDate.log');
    }
  }
}
