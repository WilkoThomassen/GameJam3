import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

final GlobalKey<RiverpodAwareGameWidgetState> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState>();

class LevelArena extends ConsumerWidget {
  const LevelArena({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RiverpodAwareGameWidget(
      game: gameRef,
      key: gameWidgetKey,
    );
  }
}
