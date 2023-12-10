import 'package:gamejamsubmission/src/game/components/components.dart';
import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:gamejamsubmission/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Configurator extends ConsumerStatefulWidget {
  const Configurator({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ConfiguratorState();
}

class ConfiguratorState extends ConsumerState<Configurator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween<double>(begin: 0.2, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GameConfig config = ref.watch(gameConfigProvider);
    return Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _getSetting(
                      'Perspective',
                      Slider(
                          value: config.perspective,
                          min: 0,
                          max: 1,
                          divisions: 100,
                          label: config.perspective.toString(),
                          onChanged: (double value) {
                            ref
                                .read(gameConfigProvider.notifier)
                                .setPerspective(value);
                          })),
                  _getSetting(
                      'Grid size',
                      Slider(
                          value: config.gridSize.toDouble(),
                          min: 5,
                          max: 15,
                          divisions: 5,
                          label: config.gridSize.toString(),
                          onChanged: (double value) {
                            ref
                                .read(gameConfigProvider.notifier)
                                .setGridSize(value.toInt());
                          })),
                  _getSetting(
                      'Obstacle factor',
                      Slider(
                          value: config.obstacleFactor,
                          min: 0,
                          max: 1,
                          divisions: 10,
                          label: config.obstacleFactor.toString(),
                          onChanged: (double value) {
                            ref
                                .read(gameConfigProvider.notifier)
                                .setObstacleFactor(value);
                          })),
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: [
                _getSetting(
                    'Debug info',
                    Switch(
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: config.showDebugInfo,
                        onChanged: (showDebugInfo) {
                          ref
                              .read(gameConfigProvider.notifier)
                              .setShowDebugInfo(showDebugInfo);
                        })),
                _getSetting(
                    'Players',
                    Slider(
                        value: config.players.toDouble(),
                        min: 1,
                        max: 4,
                        divisions: 3,
                        label: config.players.toString(),
                        onChanged: (double value) {
                          ref
                              .read(gameConfigProvider.notifier)
                              .setPlayers(value.toInt());
                        })),
                Row(
                  children: [
                    Button(
                      onPressed: () {
                        gameEventProcessor.createGame(1);
                        gameEventProcessor.startGame();
                      },
                      text: 'Regenerate level',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Button(
                      onPressed: () {
                        controller.reset();
                        controller.addListener(() {
                          ref
                              .read(gameConfigProvider.notifier)
                              .setPerspective(animation.value);

                          if (controller.isCompleted) {
                            // once the game is drawn, the flame can be placed
                            gameEventProcessor.placeFlameOnField();
                            gameEventProcessor.prepareFreeze();
                          }
                        });
                        controller.forward();
                      },
                      text: 'Start game',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Button(
                      onPressed: () async {
                        gameEventProcessor.placeFlameOnField();

                        // gameEventProcessor.prepareFreeze();
                        // spawn 3 freezes
                        for (int index = 1; index <= 5; index++) {
                          await Future.delayed(
                              const Duration(milliseconds: 1000), () async {
                            // introduce new freeze to the board
                            gameEventProcessor.prepareFreeze();

                            await Future.delayed(
                                const Duration(milliseconds: 500), () {
                              // spawn it
                              gameEventProcessor.spawnFreeze();
                            });
                          });
                        }
                      },
                      text: 'Just start',
                    ),
                  ],
                )
              ],
            ))
          ],
        ));
  }

  Widget _getSetting(String label, Widget child) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(label)),
        Expanded(flex: 7, child: child)
      ],
    );
  }
}
