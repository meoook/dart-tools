import 'package:mylog/mylog.dart';

void main() async {
  var logger = Logging();
  logger.sizeLimit = 1000;
  logger.lvl = Level.ERROR;
  logger.i('START');
  var _idx = 0;
  while (true) {
    logger.i('$_idx message');
    await Future.delayed(Duration(milliseconds: 100));
    _idx++;
    if (_idx > 4) break;
  }
  logger.e('STOPED');
  await Future.delayed(const Duration(seconds: 1));
  logger.c('WOWOW');
}
