import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamejamsubmission/src/app/level.dart';
import 'package:gamejamsubmission/src/game/models/game.dart';
import 'package:gamejamsubmission/src/game_config/state/game_config_provider.dart';

import '../../main.dart';
import '../game/game_exports.dart';
import '../game/graphics/color_theme.dart';
import 'levels.dart';

class FlameFrostyApp extends ConsumerStatefulWidget {
  const FlameFrostyApp({super.key});

  @override
  FlameFrostAppState createState() => FlameFrostAppState();
}

class FlameFrostAppState extends ConsumerState<FlameFrostyApp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  LevelDefinition get currentLevel => Levels.levels[currentLevelIndex - 1];
  int currentLevelIndex = 1;
  GameState gameState = GameState.idle;

  bool _cancelSpawning = false;

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween<double>(begin: 0.2, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));

    controller.addListener(() {
      ref.read(gameConfigProvider.notifier).setPerspective(animation.value);

      if (controller.isCompleted) {
        _cancelSpawning = false;
        // once the game is drawn, the flame can be placed
        gameEventProcessor.placeFlameOnField();
        _startSpawningFrosties();
      }
    });

    globalScope.listen(gameProvider, (previous, next) {
      if (previous != null && next != null) {
        if (previous.gameState != next.gameState) {
          if (next.gameState == GameState.finished ||
              next.gameState == GameState.defeated) {
            _cancelSpawning = true;
          }
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
            textTheme: const TextTheme().apply(
                bodyColor: ColorTheme.freeze, displayColor: ColorTheme.flame),
            primarySwatch: Colors.deepOrange,
            colorScheme: ColorScheme.dark(
                primary: ColorTheme.freeze, secondary: ColorTheme.flame)),
        home: Scaffold(
          body: gameState == GameState.idle
              ? _startScreen()
              : gameState == GameState.defeated
                  ? _defeatedScreen()
                  : const LevelArena(),
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
        Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/img/defeated.png',
                width: 400,
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: IconButton(
                icon: const Icon(Icons.play_circle_fill_outlined),
                color: ColorTheme.buttonForeground,
                hoverColor: ColorTheme.fieldColorBoring,
                iconSize: 150,
                onPressed: () {
                  _startGame();
                },
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              'Use arrow keys to move around. Go to the green finish plate and avoid Frosties',
              style:
                  TextStyle(color: ColorTheme.buttonForeground, fontSize: 20),
            ),
          ),
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
              padding: const EdgeInsets.only(bottom: 80),
              child: IconButton(
                icon: const Icon(Icons.replay_outlined),
                color: ColorTheme.buttonForeground,
                hoverColor: ColorTheme.fieldColorBoring,
                iconSize: 200,
                onPressed: () {
                  // reset level
                  currentLevelIndex = 1;
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

    gameEventProcessor.createGame(currentLevelIndex);
    gameEventProcessor.startGame();
    gameRef.initialize(ref);

    setState(() {
      gameState = GameState.started;
    });

    // set animation here
    controller.reset();

    controller.forward();
  }

  Future _startSpawningFrosties() async {
    for (int index = 1; index <= currentLevel.frosties; index++) {
      if (_cancelSpawning) break;
      await Future.delayed(Duration(milliseconds: currentLevel.spawnDelay),
          () async {
        // cancel when game is over
        if (_cancelSpawning) return;
        // introduce new freeze to the board
        gameEventProcessor.prepareFreeze();
        final spawnDelay = (currentLevel.spawnDelay / 2).round();
        // ensure they dont jump in sync
        final actualSpawnDelay = spawnDelay - 100 + Random().nextInt(100);
        await Future.delayed(Duration(milliseconds: actualSpawnDelay), () {
          // cancel when game is over
          if (_cancelSpawning) return;
          // spawn it
          gameEventProcessor.spawnFreeze();
        });
      });
    }
  }
}
