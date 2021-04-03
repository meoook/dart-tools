class YamlAdd {
  final RegExp _exp = RegExp(r'^( *)(- )? *(?:([^:]+): *)?(.*)$');
  final RegExp _exp_comment = RegExp(r'''^('.*'|".*")? +(#.*)$''');

  final Map<String, dynamic> _map = {};
  Map<String, dynamic> get map => _map;

  final List<YamLine> _lines = [];

  void add(String line) {
    if (line.trim().isEmpty) return;
    final _line = line.replaceAll('\t', '  ');
    final _match = _exp.firstMatch(_line);
    if (_match != null) {
      final spaces = _match.group(1) ?? '';
      final arr = _match.group(2) == null ? false : true;
      final key = _match.group(3) ?? '';
      final value = _match.group(4);
      if (!arr && key.isEmpty) return;  // Yaml error
      final _yam_line = YamLine(spaces.length, arr, key, _fix(value));
      _lines.add(_yam_line);
    } else {
      print('Row not common for yaml: $line');
    }
  }

  /// Remove comments and quotes
  String? _fix(String? value) {
    if (value == null) return null;
    final _value = value.trim();
    if (_value.isEmpty) return '';
    final _idx = value.indexOf(' #');
    if (_idx != -1) {
      final _match = _exp_comment.firstMatch(_value);
      if (_match != null) {
        final _wrappedVal = _match.group(1);
        if (_wrappedVal != null) return _wrappedVal.substring(1, _wrappedVal.length - 1).trim();
      }
      return value.substring(0, _idx).trim();
    }
    return _value;
  }
}

// void _lvl_select(YamLine yamLine) {
//   var _diff = yamLine.len - _last.len;
//   if (_diff == 0) return _eq(yamLine);
//   if (_diff > 0) return _gt(yamLine);
//   if (_diff < 0) return _lt(yamLine);
// }
//
// void _eq(YamLine yamLine) {
//   print('IS EQ $yamLine');
//   if (_tree.isNotEmpty) _tree.remove(_tree.last);
// }
//
// void _lt(YamLine yamLine) {
//   print('IS LT $yamLine');
// }
//
// void _gt(YamLine yamLine) {
//   print('IS GT $yamLine');
// }
//
// void _setCurrent(YamLine yamLine) {
//   _tree.forEach((element) {
//     _map[element.name];
//   });
// }
