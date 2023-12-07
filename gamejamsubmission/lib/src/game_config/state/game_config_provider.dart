import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:riverpod/riverpod.dart';

import '../../../main.dart';

final gameConfigProvider =
    StateNotifierProvider<GameConfigNotifier, GameConfig>(
        (ref) => GameConfigNotifier());

int get gridSize => globalScope.read(gameConfigProvider).gridSize;
double get obstacleFactor =>
    globalScope.read(gameConfigProvider).obstacleFactor;

class GameConfigNotifier extends StateNotifier<GameConfig> {
  GameConfigNotifier() : super(GameConfig());

  void setPerspective(double value) {
    state = state.instanceWith(perspective: value);
  }

  void setGridSize(int gridSize) {
    state = state.instanceWith(gridSize: gridSize);
  }

  void setObstacleFactor(double obstacleFactor) {
    state = state.instanceWith(obstacleFactor: obstacleFactor);
  }

  void setShowDebugInfo(bool showDebugInfo) {
    state = state.instanceWith(showDebugInfo: showDebugInfo);
  }

  void setPlayers(int players) {
    state = state.instanceWith(players: players);
  }

  void setConfig(GameConfig updatedConfig) {
    state = updatedConfig.instanceWith(id: updatedConfig.id++);
  }
}
