import 'package:gamejamsubmission/src/game/game.dart';
import 'package:gamejamsubmission/src/game_processor/game_event_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app/flame_frosty_app.dart';

void main() {
  runApp(ProviderScope(parent: globalScope, child: const FlameFrostyApp()));
}

ProviderContainer globalScope = ProviderContainer();
GameEventProcessor gameEventProcessor = GameEventProcessor();
FlameFrostyGame gameRef = FlameFrostyGame();
