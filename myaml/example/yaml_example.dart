import 'package:myaml/yaml.dart';

void main() {
  var yaml_cfg = ReadYaml('./example/config.yaml')..read();
  print('CFG: $yaml_cfg');
}
