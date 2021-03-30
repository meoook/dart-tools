A library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:myaml/yaml.dart';

void main() async {
  var yaml_cfg = await ReadYaml('./example/config.yaml').read();
  print('CFG: $yaml_cfg');
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
