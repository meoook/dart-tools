import 'dart:convert';
import 'dart:io';

import 'yaml_map.dart';

class ReadYaml {
  final File _file;
  final YamlMap _yaml = YamlMap();

  ReadYaml(String name) : _file = _validFile(name);

  static File _validFile(String name) {
    var _path = Platform.script.resolve(name).toFilePath();
    assert(_path.isNotEmpty, 'path not found for $name');
    return File(name);
  }

  Future<Map<String, dynamic>> read() async {
    // Decode bytes to UTF-8 and convert stream to individual lines.
    var lines = _file.openRead().transform(utf8.decoder).transform(LineSplitter());
    try {
      await for (var _line in lines) {
        _yaml.add(_line);
      }
      stdout.write('Yaml ${_file.path} read successfully');
    } catch (_err) {
      stderr.write('Error read yaml ${_file.path} - $_err');
    }
    return _yaml.map;
  }
}
