import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:gamejamsubmission/src/game/generators/generators.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:riverpod/riverpod.dart';

import '../processors/situation_processor.dart';

final gameProvider = StateNotifierProvider<GameNotifier, FlameFrostiesGame?>(
    (ref) => GameNotifier());

class GameNotifier extends StateNotifier<FlameFrostiesGame?> {
  GameNotifier() : super(null);

  FlameFrostiesGame get gameState => state!;

  void newGame(GameConfig config, int gameId) {
    //_clear();
    // (re)create Game
    Level playLevel = LevelGenerator.generateLevel(gameId.toString());

    var situationFields = playLevel.fields
        .map((f) => SituationField(characters: [], field: f))
        .toList();

    state = FlameFrostiesGame(
        gameId: state != null ? gameState.gameId + 1 : 1,
        level: playLevel,
        gameState: GameState.started,
        situation: Situation(fields: situationFields));
  }

  void placePlayerOnField(Character player, int fieldId) {
    // place the character on the field
    final updatedSituation =
        SituationProcessor.placePlayerOnField(player, fieldId);

    // make player know on what field it is

    player.locationFieldId = fieldId;

    // update situation state
    state = gameState.instanceWith(situation: updatedSituation);
  }

  void moveFreeze(Character freeze, int originFieldId, int targetFieldId) {
    // move freeze from one field to another
    final updatedSituation =
        SituationProcessor.moveFreeze(freeze, originFieldId, targetFieldId);

    freeze.locationFieldId = targetFieldId;

    state = gameState.instanceWith(situation: updatedSituation);
  }

  void moveFlame(int targetFieldId) {
    // update situation state
    state = gameState.instanceWith(
        situation:
            gameState.situation.instanceWith(flameOnFieldId: targetFieldId));
  }

  void endGame(GameState status) {
    _clear();
    state = gameState.instanceWith(gameState: status);
  }

  void _clear() {
    Future.delayed(Duration(seconds: 2), () {
      print('CLEAR');
      final updatedSituation = SituationProcessor.clear();
      state = gameState.instanceWith(situation: updatedSituation);
    });
  }
}
