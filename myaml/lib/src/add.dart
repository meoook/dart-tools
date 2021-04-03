class YamlMap {
  final RegExp _exp = RegExp(r'^( *)(- )? *(?:([^:]+): *)?(.*)$');
  final RegExp _exp_comment = RegExp(r'''^('.*'|".*")? +(#.*)$''');

  final Map<String, dynamic> _map = {};
  Map<String, dynamic> get map => _map;

  final List<YamLine> _lines = [];

  void add(String line) {
    if (line.trim().isEmpty) return;
    var _line = line.replaceAll('\t', '  ');
    var _match = _exp.firstMatch(_line);
    if (_match != null) {
      var spaces = _match.group(1) ?? '';
      var arr = _match.group(2) == null ? false : true;
      var key = _match.group(3) ?? '';
      var value = _match.group(4);
      var _yam_line = YamLine(spaces, arr, key, value);
      _lines.add(_yam_line);
    } else {
      print('Row not common for yaml: $line');
    }
  }

  /// Remove comments and similicons
  String? _fix(String? value) {
    if (value == null) return null;
    var _value = value.trim();
    if (_value.isEmpty) return '';
    var _idx = value.indexOf(' #');
    if (_idx != -1) {
      var _match = _exp_comment.firstMatch(_value);
      if (_match != null) {
        var _wrappedVal = _match.group(1);
        if (_wrappedVal != null) return _wrappedVal.substring(1, _wrappedVal.length - 1).trim();
      }
      return value.substring(0, _idx).trim();
    }
    return _value;
  }

  /// Remove comments and replace tabs on spaces
  String _fixLine(String line) {
    var _comment_start = line.indexOf('#');
    var _line = _comment_start == -1 ? '$line' : line.substring(0, _comment_start).trim();
    return _line.replaceAll('\t', '  '); // replace all tabs on two spaces
  }
}

enum LineType { keyVal, keyNull, arrKeyVal, arrKeyNull }

class YamLine {
  final String spaces;
  final bool isArr;
  final String key;
  final String? value;

  int get len => spaces.length;

  YamLine(this.spaces, this.isArr, this.key, this.value);

  LineType get type {
    if (isArr) return key.isEmpty ? LineType.arrKeyNull : LineType.arrKeyVal;
    return value.isEmpty ? LineType.keyNull : LineType.keyVal;
  }

  @override
  String toString() => 'space:$spaces|is arr:$isArr|key:$key|value:$value';
}

class Tracker {
  final int lvl;
  final String name;
  final LineType type;
  final String spaces;

  int get len => spaces.length;

  Tracker(this.lvl, this.name, this.type, this.spaces);
  Tracker.root()
      : lvl = 0,
        name = 'root',
        type = LineType.keyNull,
        spaces = '';
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
