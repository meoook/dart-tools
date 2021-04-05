# Logger

- description: easy logger to console and file (with resources optimisation)
- version: 1.0.1
- author: [meok][author]

# Feachers

- [x] Easy to use
- [x] Log levels
- [x] Control file write (stream)
- [x] Log files rotation (by size limit)
- [ ] One log file (with rotation)

## Usage

A simple usage example:

```dart
import 'package:mylog/mylog.dart';

void main() async {
  var logger = Logging();
  logger.lvl = Level.ERROR; // DEBUG, INFO, WARNING, ERROR, CRITICAL
  logger.sizeLimit = 1000; // in bytes
  logger.i('START');  // Ignored by level (INFO)
  await Future.delayed(const Duration(seconds: 1));
  logger.e('STOP');  // Display "2021-04-05 13:23:54 [ERRO] STOP"
}
```

## Changelog

[Changelog][log]

[log]: CHANGELOG.md 'Changelog'
[author]: https://bazha.ru 'meok home page'
