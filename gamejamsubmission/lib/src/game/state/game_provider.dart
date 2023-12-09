import 'package:gamejamsubmission/src/game/models/gameplay/game_input.dart';
import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:gamejamsubmission/src/game/generators/generators.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:riverpod/riverpod.dart';

import '../../../main.dart';
import '../processors/situation_processor.dart';

final gameProvider =
    StateNotifierProvider<GameNotifier, BakiGame?>((ref) => GameNotifier());

class GameNotifier extends StateNotifier<BakiGame?> {
  GameNotifier() : super(null);

  BakiGame get gameState => state!;

  void newGame(GameConfig config) {
    // (re)create Game
    Level playLevel = LevelGenerator.generateLevel();
    List<Player> players = PlayerGenerator.generatePlayers(config.players);

    var situationFields = playLevel.fields
        .map((f) => SituationField(bakis: [], field: f))
        .toList();

    state = BakiGame(
        gameId: state != null ? gameState.gameId + 1 : 1,
        players: players,
        level: playLevel,
        situation:
            Situation(turnPlayer: players.first, fields: situationFields));
  }

  void placePlayerOnField(Baki player, int fieldId) {
    // place the baki on the field
    final updatedSituation =
        SituationProcessor.placePlayerOnField(player, fieldId);

    // make player know on what field it is

    player.locationFieldId = fieldId;

    // update situation state
    state = gameState.instanceWith(situation: updatedSituation);
  }

  void moveFreeze(Baki freeze, int originFieldId, int targetFieldId) {
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
}
