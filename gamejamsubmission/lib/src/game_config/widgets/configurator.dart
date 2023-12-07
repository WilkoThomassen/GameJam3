import 'package:background_patterns/background_patterns.dart';
import 'package:gamejamsubmission/src/game/components/components.dart';
import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:gamejamsubmission/src/app/widgets/custom_theme.dart';
import 'package:gamejamsubmission/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Configurator extends ConsumerWidget {
  const Configurator({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GameConfig config = ref.watch(gameConfigProvider);
    return Container(
        color: Theme.of(context).colorScheme.secondary,
        child: PatternContainer(
            color: Theme.of(context).colorScheme.secondary,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            shapeSpacing: 30,
            shapeSize: 90,
            containerDepth: 0.5,
            shapes: [StarConfig(isOutlined: true)],
            shapeColor: Theme.of(context).shapeColor,
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
                              divisions: 10,
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
                    Button(
                      onPressed: () {
                        gameEventProcessor.createGame();
                        gameEventProcessor.startGame();
                      },
                      text: 'Regenerate level',
                    ),
                  ],
                ))
              ],
            )));
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
