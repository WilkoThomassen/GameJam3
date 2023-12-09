import 'dart:math';

import 'package:gamejamsubmission/src/game/processors/field_processor.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';

import '../../game_config/config.dart';

class LevelGenerator {
  static Level generateLevel() {
    int fieldId = 1;
    bool hasFinish = false;

    int totalFields = gridSize * gridSize;

    // first create all obstacles in the level
    List<int> obstacles = _generateObstacles(gridSize, obstacleFactor);
    var playGround = FieldProcessor.getBiggestPlayGround(obstacles);

    List<FieldConfig> fields = [];
    for (int rowIndex = gridSize; rowIndex > 0; rowIndex--) {
      for (int columnIndex = 0; columnIndex < gridSize; columnIndex++) {
        double darknessFactor = (0.4 / totalFields) * (totalFields - fieldId);
        bool isObstacle = obstacles.contains(fieldId);
        bool isHighObstacle = !isObstacle && !playGround.contains(fieldId);
        bool isFinish = false;
        if (!isObstacle && !hasFinish) {
          isFinish = true;
          hasFinish = true;
        }

        final field = FieldConfig(
            fieldId: fieldId,
            locationX: columnIndex,
            locationY: rowIndex,
            darkness: darknessFactor,
            isFinish: isFinish,
            hasGroundLeft: rowIndex == 1,
            hasGroundRight: columnIndex == gridSize - 1,
            hasObstacle: isObstacle || isHighObstacle,
            hasHighObstacle: isHighObstacle);
        fields.insert(0, field);
        fieldId++;
      }
    }

    return Level(
        fields: fields, fieldSize: 800 / gridSize, obstacles: obstacles);
  }

  /// returns a list of fieldIndexes (fieldId's) which should have an obstacle
  /// it creates islands of obstacles randomly across the level
  static List<int> _generateObstacles(int gridSize, double obstacleFactor) {
    List<int> result = [];
    int totalFields = gridSize * gridSize;
    // calc the total number of obstacles to create
    int totalObstacles = (totalFields * obstacleFactor).ceil();

    // create islands of obstacles until we run out of available obstacles
    while (result.length < totalObstacles) {
      // determine the size of the obstacle island (min 2 and max half of total)
      int islandSize = Random().nextInt((totalObstacles / 4).ceil());

      // determine the random position of the obstacle island
      int startPointFieldId = Random().nextInt(totalFields);
      result.add(startPointFieldId);

      int nextFieldId = startPointFieldId;
      for (int i = 0; i <= islandSize; i++) {
        // create island
        List<int> positionOptions =
            FieldProcessor.getSurroundingFieldIds(nextFieldId);

        nextFieldId = positionOptions[Random().nextInt(positionOptions.length)];
        // pick one of the surrounding options
        result.add(nextFieldId);
      }
    }

    // distincts the list
    return result.toSet().toList();
  }
}
