import 'dart:ui';

import 'package:gamejamsubmission/src/game/models/models.dart';

class Level {
  Level(
      {required this.fields,
      required this.fieldSize,
      required this.obstacles,
      this.theme});
  final List<FieldConfig> fields;
  final double fieldSize;
  final LevelTheme? theme;

  // supporting properties
  final List<int> obstacles;
}

class LevelTheme {
  LevelTheme(
      {required this.background,
      required this.foreground,
      required this.doodleType});
  final Color background;
  final Color foreground;
  final String doodleType; // patternsPackage > Star5, Star7, Triangle
}
