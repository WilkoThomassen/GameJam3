import 'package:gamejamsubmission/src/game/models/models.dart';

class BakiGame {
  BakiGame(
      {this.gameId = 1,
      required this.players,
      this.mode = GameMode.arcade,
      required this.level,
      required this.situation});
  final List<Player> players;
  final GameMode mode;
  final Level level;
  final Situation situation;
  final int gameId;

  BakiGame instanceWith(
      {int? gameId,
      List<Player>? players,
      GameMode? mode,
      Level? level,
      Situation? situation}) {
    return BakiGame(
        gameId: this.gameId,
        players: players ?? this.players,
        level: level ?? this.level,
        situation: situation ?? this.situation);
  }
}

enum GameMode { original, arcade }
