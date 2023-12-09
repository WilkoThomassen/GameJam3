import 'package:gamejamsubmission/main.dart';
import 'package:gamejamsubmission/src/game/models/field.dart';
import 'package:gamejamsubmission/src/game/models/gameplay/game_input.dart';
import 'package:gamejamsubmission/src/game/processors/situation_processor.dart';

import '../app/state/app_provider.dart';
import '../game/components/field.dart';
import '../game/graphics/graphics.dart';
import '../game/helpers/field_helper.dart';
import '../game/models/models.dart';
import '../game/processors/processors.dart';
import '../game/state/game_provider.dart';
import '../game_config/config.dart';

/// The GameEventProcessor is ment for handling every game-related even in the app
/// it comsumes the event and processes the event related functionality in every layer
class GameEventProcessor {
  /// Game gets created with a specific config
  void createGame() {
    // get config and setup game
    GameConfig config = globalScope.read(gameConfigProvider);
    // generate game
    globalScope.read(gameProvider.notifier).newGame(config);
  }

  void startGame() {
    // setup game in app (is temp because app still lacks game setup)
    globalScope.read(appProvider.notifier).setupGame();
  }

  void placeFlameOnField() {
    // generate players flame in game
    final placeResult = gameRef.placeFlameOnField();
    // manage it in game state
    globalScope
        .read(gameProvider.notifier)
        .placeFlameOnField(placeResult.placedBaki, placeResult.fieldId);
  }

  void jumpFlame(GameInput input) {
    final playerPositionFieldId =
        globalScope.read(gameProvider)!.situation.playerOnFieldId!;
    final surrFields =
        FieldProcessor.getAvailableSurroundingFieldIds(playerPositionFieldId);

    // resolve target field Id
    int targetFieldId =
        FieldHelper.getFieldIdByDirection(input, playerPositionFieldId);

    if (surrFields.contains(targetFieldId)) {
      gameRef.jumpTo(input, targetFieldId);
      globalScope.read(gameProvider.notifier).moveFlame(targetFieldId);
    }

    // get available fields by fieldId
    // see if field is available
    // jump to the direction
  }

  void quitGame() {
    throw UnimplementedError();
  }
}
