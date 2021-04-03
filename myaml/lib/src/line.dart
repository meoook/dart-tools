// enum LineType { keyVal, keyNull, arrKeyVal, arrKeyNull }


class YamLine {
  final int spaces;
  final bool isArr;
  final String key;
  final String? value;

  YamLine(this.spaces, this.isArr, this.key, this.value);
  //
  // LineType get type {
  //   if (isArr) return key.isEmpty ? LineType.arrKeyNull : LineType.arrKeyVal;
  //   return value.isEmpty ? LineType.keyNull : LineType.keyVal;
  // }

  @override
  String toString() => 'space:$spaces|is arr:$isArr|key:$key|value:$value';
}