import 'package:gamejamsubmission/src/game/models/models.dart';

class FlameFrostiesGame {
  FlameFrostiesGame(
      {this.gameId = 1,
      this.gameState = GameState.started,
      required this.level,
      required this.situation});
  final GameState gameState;
  final Level level;
  final Situation situation;
  final int gameId;

  FlameFrostiesGame instanceWith(
      {int? gameId,
      List<Player>? players,
      GameState? gameState,
      Level? level,
      Situation? situation}) {
    return FlameFrostiesGame(
        gameId: this.gameId,
        gameState: gameState ?? this.gameState,
        level: level ?? this.level,
        situation: situation ?? this.situation);
  }
}

enum GameState { idle, started, defeated, finished }
