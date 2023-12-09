import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:gamejamsubmission/src/game/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../game/graphics/color_theme.dart';
import 'models/app.dart';
import 'state/app_provider.dart';

final GlobalKey<RiverpodAwareGameWidgetState> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState>();

class FlameFrostyApp extends ConsumerWidget {
  const FlameFrostyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    App app = ref.watch(appProvider);
    gameRef.initialize(ref);

    return MaterialApp(
        title: 'Flame vs Frosties',
        theme: ThemeData(
            textTheme: TextTheme().apply(
                bodyColor: ColorTheme.freeze, displayColor: ColorTheme.flame),
            primarySwatch: Colors.deepOrange,
            colorScheme: ColorScheme.dark(
                primary: ColorTheme.freeze, secondary: ColorTheme.flame)),
        home: Scaffold(
          body: RiverpodAwareGameWidget(
            game: gameRef,
            key: gameWidgetKey,
          ),
        ));
  }
}
