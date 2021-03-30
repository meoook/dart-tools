enum Phase { NULL, ARR, KEY, VALUE }

// assets:
// - assets/rive/
// - assets/images/
//   test:
//     - name: Schyler
//       totals:
//         - fo: fonts/Schyler-Regular.ttf
//         - fo: fonts/Schyler-Italic.ttf
//           ke: italic
//     - name: Trajan Pro
//       totals:
//         - fo: fonts/TrajanPro.ttf
//         - fo: fonts/TrajanPro_Bold.ttf
//           za: 700

enum Adding { NULL, STR, MAP, ARR }

class YamlMap {
  final Map<String, dynamic> _map = {};
  Map<String, dynamic> get map => _map;

  int _lvl = 0;
  String _spaces = '';
  Adding _last = Adding.NULL;
  List _current = []; // list of current tree keys to find value

  void add(String line) {
    if (line.trim().isEmpty) return;
    var _line = _fixLine(line);
    var _yam_line = YamLine(_line);
    _lvl_select(_yam_line);
    _spaces = '${_yam_line._spaces}';
  }

  void _lvl_select(YamLine yamLine) {
    var _diff = yamLine._spaces.length - _spaces.length;
    print('Type ${yamLine.type}');
    if (_diff == 0) return _eq(yamLine);
    if (_diff > 0) return _gt(yamLine);
    if (_diff < 0) return _lt(yamLine);
  }

  void _eq(YamLine yamLine) {
    print('IS EQ $yamLine');
  }

  void _lt(YamLine yamLine) {
    print('IS LT $yamLine');
  }

  void _gt(YamLine yamLine) {
    print('IS GT $yamLine');
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
  final RegExp _exp = RegExp(r'^( *)(- |-)? *(?:([^:]+): *)?(.*)$');

  String _spaces = '';
  bool _isArr = false;
  String _key = '';
  dynamic _value;

  String get spaces => _spaces;
  bool get isArr => _isArr;
  String get key => _key;
  dynamic get value => _value;

  YamLine(String line) {
    _init(line);
  }

  void _init(String row) {
    var _matches = _exp.firstMatch(row);
    if (_matches != null) {
      _spaces = _matches.group(1) ?? '';
      _isArr = _matches.group(2) == null ? false : true;
      _key = _matches.group(3) ?? '';
      _value = _matches.group(4);
    }
  }

  LineType get type {
    if (_isArr) return _key.isEmpty ? LineType.arrKeyNull : LineType.arrKeyVal;
    return _value.isEmpty ? LineType.keyNull : LineType.keyVal;
  }

  @override
  String toString() => 'space:$_spaces|is arr:$_isArr|key:$_key|value:$_value';
}

// class Tracker {
//   int prevSpaces;
//   int curSpaces;
//   LineType type;
//
//   Tracker(this.prevSpaces);
// }
