import 'package:gamejamsubmission/main.dart';
import 'package:gamejamsubmission/src/game/models/field.dart';
import 'package:gamejamsubmission/src/game/processors/situation_processor.dart';

import '../app/state/app_provider.dart';
import '../game/models/models.dart';
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
    SituationProcessor.placeBakiOnField(
        placeResult.placedBaki, placeResult.fieldId);
  }

  void quitGame() {
    throw UnimplementedError();
  }
}
