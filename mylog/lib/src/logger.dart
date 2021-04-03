import 'dart:async';
import 'dart:io';

import 'utils.dart';

class Logging {
  late File _file;
  late Stream<String> _stream;
  String _fileDate = DateTime.now().date;
  final List<String> messages = [];

  static final Logging _singleton = Logging._internal();
  factory Logging() => _singleton;

  Logging._internal() {
    _init();
  }

  void i(String msg) => _log(msg);
  void e(String msg) => _log(msg, err: true);

  Stream<String> _loggerStream() async* {
    for (var msg in messages) yield msg;
  }

  void _log(String msg, {bool err = false}) {
    String _final_msg;
    var _time = DateTime.now().full;
    if (err) {
      _final_msg = '$_time [WARN] $msg\n';
      // stderr.write(_final_msg);
    } else {
      _final_msg = '$_time [INFO] $msg\n';
      // stdout.write(_final_msg);
    }
    messages.add(_final_msg);
    print('ADDED MSG TO STREAM ${messages.length} $_final_msg');
  }

  Future<void> _logFile(String row) async {
    print('LOGGING FILE $row');
    // var _sink = _file.openWrite(mode: FileMode.writeOnlyAppend);
    await _file.writeAsString('asads');
    // _sink = _sink ?? _file.openWrite(mode: FileMode.append);
    // _sink.write(row);
    // Close the IOSink to free system resources.
    // _sink.close();
  }

  /// Check new date to change [_file]
  void _checkFileDate() {
    var _today = DateTime.now().date;
    if (_today != _fileDate) {
      _fileDate = _today;
      _file = File('logs/$_fileDate.log');
    }
  }

  /// Check for directory and set [_file]
  Future<void> _init() async {
    _stream = _loggerStream();
    _file = await _initialDirFile();
    // _listen(_stream);
    // _stream.listen(void Function(T event) onData, {Function onError, void Function() onDone, bool cancelOnError});
  }

  Future _listen(Stream<String> stream) async {
    print('START READ STREAM ${messages.length} !!!');
    while (true) {
      await for (var row in stream) {
        try {
          _logFile(row);
        } on IOException catch (_e) {
          stderr.write('System error - can\'t write to file ${_file.path}\n$_e\n');
        } catch (_e) {
          stderr.write('Unknown error while write to file ${_file.path}\n$_e\n');
        }
      }
      print('STREAM READ END WAIT...');
      _checkFileDate();
    }
  }

  /// Check exist or create logs directory then return [File]
  Future<File> _initialDirFile() async {
    final _dir = Directory('logs');
    if (!await _dir.exists()) await _dir.create();
    return File('logs/${DateTime.now().date}.log');
  }
}
