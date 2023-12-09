import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamejamsubmission/src/app/level.dart';
import 'package:gamejamsubmission/src/game_config/state/game_config_provider.dart';

import '../../main.dart';
import '../game/graphics/color_theme.dart';
import '../game/models/level.dart';
import 'levels.dart';

class FlameFrostyApp extends ConsumerStatefulWidget {
  const FlameFrostyApp({super.key});

  @override
  FlameFrostAppState createState() => FlameFrostAppState();
}

class FlameFrostAppState extends ConsumerState<FlameFrostyApp> {
  late LevelDefinition currentLevel;
  int currentLevelIndex = 0;
  bool isStarted = false;

  @override
  void initState() {
    currentLevel = Levels.levels[currentLevelIndex];

    super.initState();
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flame vs Frosties',
        theme: ThemeData(
            textTheme: TextTheme().apply(
                bodyColor: ColorTheme.freeze, displayColor: ColorTheme.flame),
            primarySwatch: Colors.deepOrange,
            colorScheme: ColorScheme.dark(
                primary: ColorTheme.freeze, secondary: ColorTheme.flame)),
        home: Scaffold(
          body: isStarted ? LevelArena() : _startScreen(),
        ));
  }

  Widget _startScreen() {
    return Container(
      color: ColorTheme.appBackground,
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/img/appheader.png',
            width: 500,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: EdgeInsets.only(bottom: 150),
              child: IconButton(
                icon: const Icon(Icons.play_circle_fill_outlined),
                color: ColorTheme.buttonForeground,
                hoverColor: ColorTheme.bakiPlayerOne,
                iconSize: 150,
                onPressed: () {
                  setState(() {
                    // set config based on level
                    ref
                        .read(gameConfigProvider.notifier)
                        .setGridSize(currentLevel.gridSize);

                    gameEventProcessor.createGame();
                    gameEventProcessor.startGame();
                    gameRef.initialize(ref);

                    Future.delayed(const Duration(seconds: 1), () {
                      gameEventProcessor.placeFlameOnField();
                      _startSpawningFrosties();
                    });

                    isStarted = true;
                  });
                },
              )),
        )
      ]),
    );
  }

  Future _startSpawningFrosties() async {
    for (int index = 1; index <= currentLevel.frosties; index++) {
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        // introduce new freeze to the board
        gameEventProcessor.prepareFreeze();

        await Future.delayed(const Duration(milliseconds: 500), () {
          // spawn it
          gameEventProcessor.spawnFreeze();
        });
      });
    }
  }
}
