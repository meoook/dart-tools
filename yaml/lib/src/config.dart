import '../logger.dart';

var _logger = Logging();

enum Position { LINK, CONDITIONS, COMMANDS }

class RepositoryCfg {
  final link;
  final List<Map<String, String>>? conditions;
  final List<Map<String, dynamic>> commands;

  const RepositoryCfg({required this.link, required this.commands, this.conditions});

  factory RepositoryCfg.fromLines({required List<String> lines}) {
    Position _position = Position.LINK;
    String _link = '';
    var conditions = <Map<String, String>>[];
    var _commands = <Map<String, dynamic>>[];

    for (var _line in lines) {
      if (_line.startsWith('    ')) {
        if (_position == Position.CONDITIONS) {
          conditions.add(_parse(_line));
        } else if (_position == Position.COMMANDS) {
          var _command = _parse(_line);
          var _params = _command['value']?.split(' ') ?? [];
          if (_command['name'] != null) _commands.add({'name': _command['name'], 'value': _params});
        } else {
          _logger.e('Error parsing yaml: unknown position for option line $_line');
        }
      } else if (_line.startsWith('conditions', 2)) {
        _position = Position.CONDITIONS;
      } else if (_line.startsWith('commands', 2)) {
        _position = Position.COMMANDS;
      } else if (_line.startsWith('  ')) {
        _logger.e('Error parsing yaml: unknown option ${_line.trim().split(':').first}');
      } else if (_position == Position.LINK) {
        _link = _line.substring(0, _line.length - 1);
      } else {
        _logger.e('Error parsing yaml: unknown position for line $_line');
      }
    }
    assert(_link.isNotEmpty, 'repository config must contain full_name');
    assert(_commands.isNotEmpty, 'repository config must contain commands to run on hook');
    return RepositoryCfg(link: _link, commands: _commands, conditions: conditions.isNotEmpty ? conditions : null);
  }

  static Map<String, String> _parse(String row) {
    var _idx = row.indexOf(":"); // key: value
    var _value = row.substring(_idx + 1).trim();
    var _comment_start = _value.indexOf("#"); // remove comments
    _value = (_comment_start == -1) ? _value : _value.substring(0, _comment_start).trim();
    // remove ' or "
    if (_value.startsWith("'") && _value.endsWith("'") || _value.startsWith('"') && _value.endsWith('"')) {
      _value = _value.substring(1, _value.length - 1);
    }
    return {'name': row.substring(0, _idx).trim(), 'value': _value};
  }

  @override
  String toString() => 'Repository cfg $link with ${commands.length} commands';
}
