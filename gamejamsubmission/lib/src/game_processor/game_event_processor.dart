import 'package:gamejamsubmission/src/game/components/baki_layout.dart';
import 'package:gamejamsubmission/src/game/extensions/extensions.dart';
import 'package:gamejamsubmission/src/game/models/field.dart';
import 'package:gamejamsubmission/src/game/models/gameplay/placement_result.dart';
import 'package:gamejamsubmission/src/game/state/exploding_provider.dart';
import 'package:gamejamsubmission/main.dart';

import '../app/state/app_provider.dart';
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

  void placeBakiOnField(FieldConfig field) {
    // check if player can place its baki on the field
    // if placement is not allowed newBaki will be null
    final placementResult =
        globalScope.read(gameProvider.notifier).placeBaki(field.fieldId);

    if (placementResult.placedBaki != null) {
      // get baki position based on new field situation
      gameRef.addBakiOnField(placementResult.placedBaki!, field);
    }

    if (placementResult.placementStatus == PlacementStatus.explode) {
      // get bakis from fieldSituation
      final situationField = globalScope
          .read(gameProvider.notifier)
          .gameState
          .getSituationFieldById(field.fieldId);
      final fieldBakis =
          List<BakiLayout>.from(situationField.bakis.map((b) => b.bakiLayout));

      // remove baki from field place bakis on surrounding fields
      globalScope.read(gameProvider.notifier).explode(field.fieldId);

      // let the explosions begin
      gameRef.explode(field, fieldBakis);
    }

    if (placementResult.placedBaki != null &&
        placementResult.placementStatus != PlacementStatus.explode) {
      globalScope.read(gameProvider.notifier).nextTurn();
    }
  }

  void endTurn() {
    globalScope.read(gameProvider.notifier).nextTurn();
  }

  void explodeOnChainReaction(FieldConfig field, List<BakiLayout> fieldBakis) {
    // remove baki from field place bakis on surrounding fields
    globalScope.read(gameProvider.notifier).explode(field.fieldId);

    // let the explosions begin
    gameRef.explode(field, fieldBakis);
  }

  void quitGame() {
    throw UnimplementedError();
  }
}
