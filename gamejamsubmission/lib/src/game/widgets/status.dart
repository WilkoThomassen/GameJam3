import 'package:gamejamsubmission/src/game/game_exports.dart';
import 'package:gamejamsubmission/src/app/widgets/custom_theme.dart';
import 'package:gamejamsubmission/src/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Status extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var game = ref.watch(gameProvider)!;
    return Padding(
        padding: EdgeInsets.all(Theme.of(context).defaultPadding),
        child: BorderedBox(
            width: 250,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LabeledValue(
                    label: 'Turn', value: game.situation.turns.toString()),
                LabeledValue(
                  label: 'Player',
                  value: game.situation.turnPlayer.name,
                  valueColor: game.situation.turnPlayer.color,
                )
              ],
            )));
  }
}
