import 'package:gamejamsubmission/src/game/game_exports.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app.dart';

final appProvider =
    StateNotifierProvider<AppNotifier, App>((ref) => AppNotifier(ref));

class AppNotifier extends StateNotifier<App> {
  // TODO: use random nickname generator for name
  AppNotifier(this.ref) : super(App(userName: 'FrostyLord'));

  final Ref ref;

  void setupGame() {
    // TODO: this will change when game setup is in place
    FlameFrostiesGame? currentGame = ref.read(gameProvider);
    state = state.instanceWith(runningGame: currentGame);
  }
}
