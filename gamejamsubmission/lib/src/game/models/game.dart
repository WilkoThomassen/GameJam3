import 'package:gamejamsubmission/src/game/models/models.dart';

class BakiGame {
  BakiGame(
      {this.gameId = 1,
      required this.players,
      this.gameState = GameState.started,
      required this.level,
      required this.situation});
  final List<Player> players;
  final GameState gameState;
  final Level level;
  final Situation situation;
  final int gameId;

  BakiGame instanceWith(
      {int? gameId,
      List<Player>? players,
      GameState? gameState,
      Level? level,
      Situation? situation}) {
    return BakiGame(
        gameId: this.gameId,
        gameState: gameState ?? this.gameState,
        players: players ?? this.players,
        level: level ?? this.level,
        situation: situation ?? this.situation);
  }
}

enum GameState { idle, started, defeated, finished }
