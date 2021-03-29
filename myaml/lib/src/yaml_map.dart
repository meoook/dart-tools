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
// ^([\t ]*)?(\-|\- )?(?:([^:]+): )?(.*)$

RegExp exp = RegExp(r"(\w+)");
String str = "Parse my string";
Iterable<RegExpMatch> matches = exp.allMatches(str);

enum Adding { NULL, STR, MAP, ARR }

class YamlMap {
  final RegExp _exp = RegExp(r'^( *)(- |-)?(?:([^:]+): *)?(.*)$');

  final Map<String, dynamic> _map = {};
  Map<String, dynamic> get map => _map;

  int _lvl = 0;
  String _spaces = '';
  Adding _last = Adding.NULL;
  List? _current; // list of current tree keys to find value

  void add(String line) {
    if (line.trim().isEmpty) return;
    var _line = _fixLine(line);
    RegExpMatch? _matches = _exp.firstMatch(_line);
    if (_matches != null) {
      var _line_spaces = _matches.group(1);
      var _line_is_arr = _matches.group(2);
      var _line_key = _matches.group(3);
      var _line_value = _matches.group(4);
    }
  }

  /// Remove comments and replace tabs on spaces
  String _fixLine(String line) {
    var _comment_start = line.indexOf("#");
    var _line = _comment_start == -1 ? '$line' : line.substring(0, _comment_start).trim();
    return _line.replaceAll('\t', '  '); // replace all tabs on two spaces
  }
}
