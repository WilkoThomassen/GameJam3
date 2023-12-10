import 'package:gamejamsubmission/src/game/models/gameplay/game_input.dart';
import 'package:gamejamsubmission/main.dart';
import 'package:gamejamsubmission/src/game_config/config.dart';

import '../components/field.dart';

class FieldHelper {
  static Field getFieldComponentByFieldId(int fieldId) {
    return gameRef.children
        .whereType<Field>()
        .firstWhere((f) => f.fieldConfig.fieldId == fieldId);
  }

  static Field getFieldOnTheTop(int fieldId) {
    return getFieldComponentByFieldId(fieldId - 1);
  }

  static int getFieldIdByDirection(GameInput input, int originFieldId) {
    final config = globalScope.read(gameConfigProvider);
    switch (input) {
      case GameInput.up:
        return originFieldId - 1;
      case GameInput.right:
        return originFieldId - config.gridSize;
      case GameInput.down:
        return originFieldId + 1;
      case GameInput.left:
        return originFieldId + config.gridSize;

      default:
        return originFieldId;
    }
  }
}
