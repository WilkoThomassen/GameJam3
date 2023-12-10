import 'dart:math';

import 'package:gamejamsubmission/main.dart';
import 'package:gamejamsubmission/src/game/models/gameplay/game_input.dart';

import '../app/state/app_provider.dart';
import '../game/helpers/field_helper.dart';
import '../game/models/models.dart';
import '../game/processors/processors.dart';
import '../game/state/game_provider.dart';
import '../game_config/config.dart';

/// The GameEventProcessor is ment for handling every game-related even in the app
/// it comsumes the event and processes the event related functionality in every layer
class GameEventProcessor {
  /// Game gets created with a specific config
  void createGame(int gameId) {
    // get config and setup game
    GameConfig config = globalScope.read(gameConfigProvider);
    // generate game
    globalScope.read(gameProvider.notifier).newGame(config, gameId);
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
        .placePlayerOnField(placeResult.placedCharacter, placeResult.fieldId);
  }

  void jumpFlame(GameInput input) {
    if (globalScope.read(gameProvider)!.situation.flameOnFieldId == null) {
      return;
    }
    final playerPositionFieldId =
        globalScope.read(gameProvider)!.situation.flameOnFieldId!;
    final surrFields =
        FieldProcessor.getAvailableSurroundingFieldIds(playerPositionFieldId);

    // resolve target field Id
    int targetFieldId =
        FieldHelper.getFieldIdByDirection(input, playerPositionFieldId);

    if (surrFields.contains(targetFieldId)) {
      globalScope.read(gameProvider.notifier).moveFlame(targetFieldId);
      gameRef.jumpTo(input, targetFieldId);
    }
  }

  void prepareFreeze() {
    gameRef.prepareFreeze();
  }

  void spawnFreeze() {
    // spawn
    final placeResult = gameRef.spawnFreeze();
    // manage it in game state
    globalScope
        .read(gameProvider.notifier)
        .placePlayerOnField(placeResult.placedCharacter, placeResult.fieldId);
  }

  void jumpFreeze(Character freezeToJump) {
    if (globalScope.read(gameProvider)!.gameState != GameState.started) return;
    final surrFields = FieldProcessor.getAvailableSurroundingFieldIds(
        freezeToJump.locationFieldId);
    surrFields.sort();

    // jump to one of the two highest fieldIds, that is most likely to the
    // bottom of the field
    int random = Random().nextInt(2);
    final targetFieldId =
        surrFields.reversed.toList()[surrFields.length > 1 ? random : 0];

    gameRef.jumpFreeze(targetFieldId, freezeToJump);
    // manage it in game state
    globalScope
        .read(gameProvider.notifier)
        .moveFreeze(freezeToJump, freezeToJump.locationFieldId, targetFieldId);
  }

  void flameDefeated() {
    // give it a couple a seconds to display defeated transformation of the
    // flame player and then stop the game
    Future.delayed(const Duration(seconds: 2), () {
      globalScope.read(gameProvider.notifier).endGame(GameState.defeated);
    });
  }

  void flameFinished() {
    globalScope.read(gameProvider.notifier).endGame(GameState.finished);
  }

  void quitGame() {
    throw UnimplementedError();
  }
}
