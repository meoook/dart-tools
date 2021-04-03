import 'dart:convert';
import 'dart:io';

import 'add.dart';

class YamlRead {
  final File _file;

  YamlRead(String name) : _file = _validFile(name);

  static File _validFile(String name) {
    final _path = Platform.script.resolve(name).toFilePath();
    assert(_path.isNotEmpty, 'path not found for $name');
    return File(name);
  }

  Future<Map<String, dynamic>> read() async {
    // Decode bytes to UTF-8 and convert stream to individual lines.
    final _lines = _file.openRead().transform(utf8.decoder).transform(LineSplitter());
    final _yaml = YamlAdd();
    try {
      await for (var _line in _lines) {
        _yaml.add(_line);
      }
      stdout.write('Yaml ${_file.path} read successfully');
    } catch (_err) {
      stderr.write('Error read yaml ${_file.path} - $_err');
    }
    return _yaml.map;
  }
}
