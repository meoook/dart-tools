import 'package:mylog/mylog.dart';

void main() async {
  var logger = Logging();
  logger.i('START');
  var _idx = 0;
  while (true) {
    logger.i('$_idx message');
    await Future.delayed(Duration(seconds: 1));
    _idx++;
    if (_idx > 4) break;
  }
  logger.e('STOPED');
  await Future.delayed(const Duration(seconds: 2));
  logger.c('WOWOW');
}
