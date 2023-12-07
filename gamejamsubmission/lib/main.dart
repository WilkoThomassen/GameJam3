import 'package:gamejamsubmission/src/app/app.dart';
import 'package:gamejamsubmission/src/game/game.dart';
import 'package:gamejamsubmission/src/game_processor/game_event_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(parent: globalScope, child: BakiTakiApp()));
}

ProviderContainer globalScope = ProviderContainer();
GameEventProcessor gameEventProcessor = GameEventProcessor();
BakiTakiGame gameRef = BakiTakiGame();
