import 'dart:convert';
import 'dart:io';

import '../logger.dart';
import 'config.dart';

var _logger = Logging();

class ReadYaml {
  final File _file;
  final _repoConfigs = <RepositoryCfg>[];

  ReadYaml(String name) : _file = _validFile(name);

  static File _validFile(String name) {
    var _path = Platform.script.resolve(name).toFilePath();
    assert(_path.isNotEmpty, 'path not found for $name');
    return File(name);
  }

  Future<List<RepositoryCfg>> read() async {
    _repoConfigs.clear(); // null configs if read before
    Stream<String> lines = _file
        .openRead()
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(LineSplitter()); // Convert stream to individual lines.
    try {
      var _configBlock = <String>[];
      await for (var _line in lines) _configsAddControl(_line, _configBlock);
      if (_configBlock.isNotEmpty) _repoConfigs.add(RepositoryCfg.fromLines(lines: _configBlock)); // finish last block
      _logger.i('Config ${_file.path} read successfully - total configs ${_repoConfigs.length}');
    } catch (_err) {
      _logger.e('Error read configs - $_err');
    }
    return _repoConfigs;
  }

  void _configsAddControl(String line, List<String> block) {
    if (line.isEmpty)
      return;
    else if (line.startsWith('  '))
      block.add(line); // option for block
    else if (block.isEmpty)
      block.add(line); // first config
    else {
      // if many configs
      _repoConfigs.add(RepositoryCfg.fromLines(lines: block));
      block.clear();
      block.add(line);
    }
  }
}
