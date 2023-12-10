import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:flame/components.dart';

import '../../game_config/models/game_config.dart';

extension GameExtension on FlameFrostiesGame {
  List<int> getObstacleFieldIndexes() {
    return level.fields
        .where((f) => f.hasObstacle || f.hasHighObstacle)
        .map((f) => f.fieldId)
        .toList();
  }

  SituationField getSituationFieldById(int fieldId) {
    return situation.fields.firstWhere((f) => f.field.fieldId == fieldId);
  }

  Vector2 getLocationByFieldSituation(
      {required Vector2 fieldPosition, required int fieldId}) {
    final fieldSituation = getSituationFieldById(fieldId);
    final fieldCharacterCount = fieldSituation.characters.length;

    final centerOffset = level.fieldSize * 0.15;
    var characterXPosition = fieldPosition.x - (level.fieldSize / 2);

    var characterYPosition = fieldPosition.y - (level.fieldSize / 1.5);

    // more characters on field means placement more to the lef or right
    switch (fieldCharacterCount) {
      case 1:
        {
          characterXPosition -= centerOffset;
          break;
        }
      case 2:
        {
          characterXPosition -= -1 * centerOffset;
          break;
        }
      case 3:
        {
          characterYPosition += centerOffset;
          break;
        }
    }

    final centerOfField = Vector2(characterXPosition, characterYPosition);

    return centerOfField;
  }
}
