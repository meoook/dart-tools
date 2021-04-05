import 'dart:async';
import 'dart:io';

import 'utils.dart';

abstract class LogFileController {
  final _dir = Directory('logs');
  int sizeLimit;
  late File _file;
  late String _fileName;
  // late IOSink _sink;
  final _linesQueue = StreamController<String>();

  LogFileController({this.sizeLimit = 0, bool oneDayOneFile = true}) {
    // FIXME: oneDayOneFile not finished
    _init();
  }

  void toFile(String line) => _linesQueue.add(line);

  /// Check for directory exist, set [_fileName] and [_file], start listen to stream
  Future<void> _init() async {
    if (!await _dir.exists()) await _dir.create();
    _fileName = DateTime.now().date;
    _file = File('logs/$_fileName.log');
    _linesQueue.stream.listen((event) async => await _logFile(event));
  }

  Future<void> _logFile(String row) async {
    await _file.writeAsString(row, mode: FileMode.writeOnlyAppend);
    _nameControl();
    _sizeControl();
  }

  /// Check new date to create [_file]
  void _nameControl() {
    final _today = DateTime.now().date;
    if (_fileName != _today) {
      _fileName = _today;
      _file = File('logs/$_fileName.log');
    }
  }

  /// Check [_dir] for [sizeLimit] and control free space
  void _sizeControl() async {
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
    // TODO: file rotation for one file
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
