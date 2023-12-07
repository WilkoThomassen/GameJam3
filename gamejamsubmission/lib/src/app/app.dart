import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:gamejamsubmission/src/game/widgets/widgets.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import 'models/app.dart';
import 'state/app_provider.dart';

class BakiTakiApp extends ConsumerWidget {
  const BakiTakiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    App app = ref.watch(appProvider);
    gameRef.initialize(ref);

    return MaterialApp(
        title: 'BakiTaki',
        theme: ThemeData(
            textTheme: TextTheme()
                .apply(bodyColor: Colors.blue, displayColor: Colors.pink),
            primarySwatch: Colors.deepOrange,
            colorScheme: const ColorScheme.dark(
                primary: Color.fromARGB(255, 244, 197, 70),
                secondary: Color.fromARGB(255, 29, 26, 26))),
        home: Scaffold(
            body: Column(
          children: [
            Expanded(
                flex: 7,
                child: app.runningGame != null
                    ? Stack(
                        children: [
                          GameWidget(game: gameRef),
                          Status(),
                        ],
                      )
                    : Center(child: Text('Press regenerate'))),
            const Expanded(flex: 3, child: Configurator())
          ],
        )));
  }
}
