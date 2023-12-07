import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:flame/components.dart';

import '../../game_config/models/game_config.dart';

extension GameExtension on BakiGame {
  int getNextPlayerIndex() {
    return situation.turns % players.length;
  }

  Player getNextPlayer() {
    return players[getNextPlayerIndex()];
  }

  /// field is available when it not holds obstacle or baki from another player
  bool isFieldAvailableForPlayer(int fieldId) {
    if (getObstacleFieldIndexes().contains(fieldId)) return false;

    var situationField = getSituationFieldById(fieldId);
    // if field is still empty then its available
    if (situationField.bakis.isEmpty) return true;
    // else field is available if any bakis are of its own
    return (situationField.bakis
        .any((sf) => sf.fromPlayer == situation.turnPlayer));
  }

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
    final fieldBakiCount = fieldSituation.bakis.length;

    var centerOffset = level.fieldSize * 0.15;
    var bakiXPosition = fieldPosition.x;
    var bakiYPosition = fieldPosition.y - (level.fieldSize / 4);

    // more baki's on field means placement more to the lef or right
    switch (fieldBakiCount) {
      case 1:
        {
          bakiXPosition -= centerOffset;
          break;
        }
      case 2:
        {
          bakiXPosition -= -1 * centerOffset;
          break;
        }
      case 3:
        {
          bakiYPosition += centerOffset;
          break;
        }
    }

    final centerOfField = Vector2(bakiXPosition, bakiYPosition);

    return centerOfField;
  }
}
