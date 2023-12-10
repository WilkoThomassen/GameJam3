import 'package:gamejamsubmission/src/game/models/models.dart';

class Level {
  Level(
      {required this.fields,
      required this.fieldSize,
      required this.obstacles,
      required this.levelName});
  final List<FieldConfig> fields;
  final double fieldSize;
  final String levelName;

  // supporting properties
  final List<int> obstacles;
}
