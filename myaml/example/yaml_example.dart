import 'package:myaml/yaml.dart';

void main() async {
  var yaml_cfg = await YamlRead('./example/config.yaml').read();
  print('CFG: $yaml_cfg');
}
