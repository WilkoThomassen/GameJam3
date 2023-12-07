import 'package:gamejamsubmission/src/game/extensions/situation_field_extension.dart';
import 'package:gamejamsubmission/src/game/models/gameplay/placement_result.dart';
import 'package:gamejamsubmission/src/game/processors/field_processor.dart';
import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:gamejamsubmission/src/game/extensions/game_extension.dart';
import 'package:gamejamsubmission/src/game/generators/generators.dart';
import 'package:gamejamsubmission/src/game/processors/situation_processor.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:riverpod/riverpod.dart';

import '../../../main.dart';

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

  PlacementResult placeBaki(int fieldId) {
    if (gameState.isFieldAvailableForPlayer(fieldId)) {
      // place the baki on the field
      final updatedSituation =
          SituationProcessor.placeBakiOnField(gameState, fieldId);

      // update situation state
      state = gameState.instanceWith(situation: updatedSituation);

      // get latest baki and return it to add it to the game
      final situationField = gameState.getSituationFieldById(fieldId);
      final latestBaki = situationField.bakis.last;

      return PlacementResult(
          placementStatus: situationField.shouldExplodeOnPlaceBaki()
              ? PlacementStatus.explode
              : PlacementStatus.placed,
          placedBaki: latestBaki);
    }
    return PlacementResult(placementStatus: PlacementStatus.notPlaced);
  }

  void explode(int fieldId) {
    final updatedSituation = SituationProcessor.explode(fieldId);

    state = gameState.instanceWith(situation: updatedSituation);
  }

  void nextTurn() {
    state = gameState.instanceWith(
        situation: gameState.situation.instanceWith(
      turnPlayer: gameState.getNextPlayer(),
      turns: gameState.situation.turns + 1,
    ));
  }
}
