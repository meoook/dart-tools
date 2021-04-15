import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'date.dart';

abstract class LogFileController {
  static final _dir = Directory('logs');
  static int sizeLimit = 0;
  static late String _fileName;
  static late IOSink _sink;
  final _linesQueue = StreamController<String>(onPause: onPAUSE, sync: true);

  LogFileController() {
    _init();
  }

  void toFile(String line) => _linesQueue.add(line);

  /// Check for directory exist, set [_fileName] and [_file], start listen to stream
  Future<void> _init() async {
    // Directory creation
    if (!await _dir.exists()) await _dir.create();
    // File sinc init
    _fileName = DateTime.now().date;
    _sink = File('logs/$_fileName.log').openWrite(mode: FileMode.append);
    // Sibscribe logger to sink stream
    await _sink.addStream(_linesQueue.stream.transform(utf8.encoder));
  }

  static void onPAUSE() {
    _nameControl();
    _sizeControl();
  }

  /// Check new date to create [_file]
  static void _nameControl() {
    final _today = DateTime.now().date;
    if (_fileName != _today) {
      _sink.close();
      _fileName = _today;
      _sink = File('logs/$_fileName.log').openWrite(mode: FileMode.append);
    }
  }

  /// Check [_dir] for [sizeLimit] and control free space
  static void _sizeControl() async {
    if (sizeLimit == 0) return;
    var _total = 0;
    var _names = <String>[];
    try {
      var dirList = _dir.list();
      // Check dir for log files
      await for (FileSystemEntity _file in dirList) {
        if (_file is File) {
          _total += await _file.length();
          _names.add(_file.path.split(r'\').last.split('.').first);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    if (_names.isEmpty || _names.length == 1) return;
    // Check size
    if (_total > sizeLimit) {
      print('Log files size limit reached - $_total of $sizeLimit.');
      _names.sort();
      var _toRemove = File('logs/${_names.first}.log');
      if (await _toRemove.exists()) {
        print('Remove old file ${_names.first}.log');
        await _toRemove.delete();
      } else {
        print('Error - old log file $_toRemove not found to delete');
      }
    }
  }
}
