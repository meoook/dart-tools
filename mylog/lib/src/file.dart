import 'dart:async';
import 'dart:io';

import 'utils.dart';

abstract class LogFileController {
  final _dir = Directory('logs');
  final _sizeLimit = 1024 * 5;
  late File _file;
  late String _fileName;
  // late IOSink _sink;
  final _linesQueue = StreamController<String>();

  LogFileController() {
    _init();
  }

  void toFile(String line) => _linesQueue.add(line);

  /// Check for directory exist, set [_fileName] and [_file], start listen to stream
  Future<void> _init() async {
    if (!await _dir.exists()) await _dir.create();
    _fileName = DateTime.now().date;
    _file = File('logs/$_fileName.log');
    _linesQueue.stream.listen((event) async => await _logFile(event));
    _checkDirSize();
  }

  Future<void> _logFile(String row) async {
    await _file.writeAsString(row, mode: FileMode.writeOnlyAppend);
    _checkFileDate();
  }

  /// Check new date to change [_file]
  void _checkFileDate() {
    final _today = DateTime.now().date;
    if (_fileName != _today) {
      _fileName = _today;
      _file = File('logs/$_fileName.log');
    }
  }

  /// Check [_dir] for file amount or size limit
  void _checkDirSize() async {
    var _total = 0;
    var _names = <String>[];
    try {
      var dirList = _dir.list();
      await for (FileSystemEntity f in dirList) {
        if (f is File) {
          _total += await f.length();
          _names.add(f.path.split(r'\').last.split('.').first);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    if (_total > _sizeLimit) {
      print('Log files size limit reached - $_total of $_sizeLimit.');
      _names.sort();
      var _toRemove = File('logs/${_names.first}.log');
      if (await _toRemove.exists()) {
        print('Remove old file ${_names.first}.log}');
        await _toRemove.delete();
      } else {
        print('Error - old log file $_toRemove not found to delete');
      }
    }
  }
}
