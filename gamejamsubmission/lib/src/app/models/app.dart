import 'package:gamejamsubmission/src/game/models/models.dart';

class App {
  App({this.runningGame, required this.userName, this.multiplayerGameKey});
  final FlameFrostiesGame? runningGame;
  final String userName;
  final String? multiplayerGameKey;

  App instanceWith(
      {FlameFrostiesGame? runningGame,
      String? userName,
      String? multiplayerGameKey}) {
    return App(
        runningGame: runningGame ?? this.runningGame,
        userName: userName ?? this.userName,
        multiplayerGameKey: multiplayerGameKey ?? this.multiplayerGameKey);
  }
}
