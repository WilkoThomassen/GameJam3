import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamejamsubmission/src/app/levels.dart';

import '../../main.dart';
import '../game/models/level.dart';

class LevelArena extends ConsumerWidget {
  final GlobalKey<RiverpodAwareGameWidgetState> gameWidgetKey =
      GlobalKey<RiverpodAwareGameWidgetState>();

  LevelArena({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RiverpodAwareGameWidget(
      game: gameRef,
      key: gameWidgetKey,
    );
  }
}
