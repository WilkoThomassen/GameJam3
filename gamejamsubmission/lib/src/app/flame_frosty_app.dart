import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamejamsubmission/src/app/level.dart';
import 'package:gamejamsubmission/src/game/models/game.dart';
import 'package:gamejamsubmission/src/game_config/state/game_config_provider.dart';

import '../../main.dart';
import '../game/game_exports.dart';
import '../game/graphics/color_theme.dart';
import '../game/models/level.dart';
import 'levels.dart';

class FlameFrostyApp extends ConsumerStatefulWidget {
  const FlameFrostyApp({super.key});

  @override
  FlameFrostAppState createState() => FlameFrostAppState();
}

class FlameFrostAppState extends ConsumerState<FlameFrostyApp> {
  LevelDefinition get currentLevel => Levels.levels[currentLevelIndex];
  int currentLevelIndex = 0;
  GameState gameState = GameState.idle;

  @override
  void initState() {
    globalScope.listen(gameProvider, (previous, next) {
      if (previous != null && next != null) {
        if (previous.gameState != next.gameState) {
          setState(() {
            gameState = next.gameState;
          });
          if (next.gameState == GameState.finished) {
            // level finished, next one
            currentLevelIndex++;
            _startGame();
          }
        }
      }
    });

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
          body: gameState == GameState.idle
              ? _startScreen()
              : gameState == GameState.defeated
                  ? _defeatedScreen()
                  : LevelArena(),
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
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'assets/img/flame.png',
            width: 500,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
            'assets/img/frosty.png',
            width: 500,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/img/defeated.png',
            width: 500,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: IconButton(
                icon: const Icon(Icons.play_circle_fill_outlined),
                color: ColorTheme.buttonForeground,
                hoverColor: ColorTheme.bakiPlayerOne,
                iconSize: 150,
                onPressed: () {
                  _startGame();
                },
              )),
        )
      ]),
    );
  }

  Widget _defeatedScreen() {
    return Container(
      color: ColorTheme.fieldColorGround,
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/img/defeated.png',
            width: 600,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: EdgeInsets.only(bottom: 150),
              child: IconButton(
                icon: const Icon(Icons.replay_outlined),
                color: ColorTheme.buttonForeground,
                hoverColor: ColorTheme.bakiPlayerOne,
                iconSize: 200,
                onPressed: () {
                  currentLevelIndex = 0;
                  _startGame();
                },
              )),
        )
      ]),
    );
  }

  void _startGame() {
    // set config based on level
    ref.read(gameConfigProvider.notifier).setGridSize(currentLevel.gridSize);

    gameEventProcessor.createGame();
    gameEventProcessor.startGame();
    gameRef.initialize(ref);

    setState(() {
      gameState = GameState.started;
    });

    Future.delayed(const Duration(seconds: 1), () {
      gameEventProcessor.placeFlameOnField();
      _startSpawningFrosties();
    });
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
