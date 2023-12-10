import 'dart:developer';

import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gamejamsubmission/src/game/components/baki_layout.dart';
import 'package:gamejamsubmission/src/game/components/components.dart';
import 'package:gamejamsubmission/src/game/extensions/extensions.dart';
import 'package:gamejamsubmission/src/game/game_exports.dart';
import 'package:gamejamsubmission/src/game/generators/baki_generator.dart';
import 'package:gamejamsubmission/src/game/helpers/field_helper.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:gamejamsubmission/main.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamejamsubmission/src/game_processor/game_event_processor.dart';

import '../game_config/config.dart';
import 'graphics/graphics.dart';
import 'graphics/graphics_constants.dart';
import 'models/gameplay/game_input.dart';

class BakiTakiGame extends FlameGame
    with RiverpodGameMixin, KeyboardEvents, HasCollisionDetection {
  late GameConfig config;
  late BakiGame game;
  late Vector2 gameSize;
  WidgetRef? ref;
  Baki? playerFlame;

  final regularText = TextPaint(
      style: TextStyle(color: ColorTheme.fieldColorBoring, fontSize: 80));

  late AudioPool pool;

  List<Baki> freezes = [];

  BakiTakiGame({super.children, super.world, super.camera});

  Iterable<Field> get fields => children.whereType<Field>();

  void initialize(WidgetRef widgetRef) {
    ref ??= widgetRef;
    // redraw when game is re-created
    globalScope.listen(gameProvider, (previous, next) {
      if (hasLayout && previous!.gameId != next!.gameId) {
        _drawGame();
      }
    });
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('music/harp.mp3');
  }

  @override
  Future<void> onLoad() async {
    _drawGame();
    startBgmMusic();
  }

  void _drawGame() {
    config = ref!.read(gameConfigProvider);
    game = ref!.read(gameProvider)!;
    // clear field before (re)drawing the game
    removeAll(children.whereType<Field>());
    removeAll(children.whereType<BakiLayout>());
    removeAll(children.whereType<TextComponent>());

    // add level nr
    add(TextComponent(text: game.level.levelName, textRenderer: regularText)
      ..position = Vector2(50, 50));

    // define position of the first field
    Vector2 basePosition = Vector2(game.level.fieldSize * 0.7, size.y * 0.5);

    for (FieldConfig fieldConfig in game.level.fields) {
      Vector2 fieldPosition = _getFieldPosition(
          fieldConfig.locationX,
          fieldConfig.locationY,
          game.level.fieldSize,
          basePosition,
          fieldConfig.hasObstacle,
          config.perspective);
      add(
        Field(
          fieldConfig: fieldConfig,
          size: Vector2(game.level.fieldSize, game.level.fieldSize),
          position: fieldPosition,
          priority: fieldConfig.getFieldDrawPriority(),
        ),
      );
    }

    globalScope.listen(gameConfigProvider, (previous, value) {
      // reposition field when perspective is changed
      if (value.perspective != previous?.perspective) {
        for (var field in fields) {
          field.position = _getFieldPosition(
              field.fieldConfig.locationX,
              field.fieldConfig.locationY,
              game.level.fieldSize,
              basePosition,
              field.fieldConfig.hasObstacle,
              value.perspective);

          // TODO: get flames and freezes on field and reposition as well
          // TODO: only do this when game is actually started
        }
      }
    });

    if (config.showDebugInfo) {
      add(FpsTextComponent(position: Vector2(size.x - 100, size.y - 24)));
    }
  }

  PlacementResult placeFlameOnField() {
    final flameSize = game.level.fieldSize / 2.5;

    // create flame to spawn
    final flameData =
        BakiGenerator().generate(flameSize, color: ColorTheme.flame);
    final flamePlayer = BakiLayout(flameData);

    playerFlame = Baki(
        isFlame: true,
        fromPlayer: Player(id: 'flame', name: 'flame', color: ColorTheme.flame),
        bakiLayout: flamePlayer);

    // drop it on the first available field on the left side of the board
    for (final field in fields.toList().reversed) {
      if (!field.fieldConfig.hasObstacle &&
          !field.fieldConfig.hasHighObstacle) {
        add(playerFlame!.bakiLayout
          ..position = game.getLocationByFieldSituation(
              fieldPosition: field.position, fieldId: field.fieldConfig.fieldId)
          ..priority = field.fieldConfig.fieldId +
              GraphicsConstants.drawLayerPriorityTreshold);
        return PlacementResult(
            placedBaki: playerFlame!, fieldId: field.fieldConfig.fieldId);
      }
    }
    // todo: find another solution for this dummy (actual dead code)
    return PlacementResult(placedBaki: playerFlame!, fieldId: 1);
  }

  GameInput getInput(Set<LogicalKeyboardKey> keysPressed) {
    if (gameRef.playerFlame!.bakiLayout.defeated) return GameInput.none;

    if (keysPressed.contains(LogicalKeyboardKey.space)) return GameInput.action;
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) return GameInput.up;
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      return GameInput.down;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      return GameInput.left;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      return GameInput.right;
    }
    return GameInput.none;
  }

  void jumpTo(GameInput direction, int targetFieldId) {
    FlameAudio.play('sfx/jump.mp3');
    // get field on the left
    Field targetField = FieldHelper.getFieldComponentByFieldId(targetFieldId);

    if (targetField.fieldConfig.isFinish) {
      GameEventProcessor().flameFinished();
    }

    gameRef.playerFlame!.bakiLayout.priority = targetField.fieldConfig.fieldId +
        GraphicsConstants.drawLayerPriorityTreshold;

    gameRef.playerFlame!.bakiLayout.jumpTo(game.getLocationByFieldSituation(
        fieldPosition: targetField.position,
        fieldId: targetField.fieldConfig.fieldId));
  }

  void prepareFreeze() {
    final freezeSize = game.level.fieldSize / 2.5;

    // create flame to spawn
    final freezeData = BakiGenerator()
        .generate(freezeSize, color: ColorTheme.freeze, isShady: true);
    final freezePlayer = BakiLayout(freezeData);

    final preparedFreeze = Baki(
        isFlame: false,
        fromPlayer:
            Player(id: 'freeze', name: 'freeze', color: ColorTheme.freeze),
        bakiLayout: freezePlayer);

    freezes.insert(0, preparedFreeze);

    final startPositionOffset = game.level.fieldSize * 1.1;

    add(preparedFreeze.bakiLayout
      ..position = fields.first.position
      ..x += startPositionOffset
      ..y -= startPositionOffset);

    freezePlayer.onJumpCompleted = () {
      Future.delayed(const Duration(milliseconds: 500), () {
        // let the freeze jump and also spawn a new one
        GameEventProcessor().jumpFreeze(preparedFreeze!);
      });
    };
  }

  /// spawns the latest freezes
  PlacementResult spawnFreeze() {
    int resultFieldId = 0;
    for (final field in fields.toList()) {
      if (!field.fieldConfig.hasObstacle &&
          !field.fieldConfig.hasHighObstacle &&
          !field.fieldConfig.isFinish) {
        final targetPosition = game.getLocationByFieldSituation(
            fieldPosition: field.position, fieldId: field.fieldConfig.fieldId);
        freezes.first.bakiLayout.priority = field.fieldConfig.fieldId +
            GraphicsConstants.drawLayerPriorityTreshold;
        freezes.first.bakiLayout.jumpTo(targetPosition);
        resultFieldId = field.fieldConfig.fieldId;
        break;
      }
    }

    return PlacementResult(placedBaki: freezes.first, fieldId: resultFieldId);
  }

  void jumpFreeze(int targetFieldId, Baki freeze) {
    final field = FieldHelper.getFieldComponentByFieldId(targetFieldId);
    final targetPosition = game.getLocationByFieldSituation(
        fieldPosition: field.position, fieldId: field.fieldConfig.fieldId);
    freeze.bakiLayout.priority =
        field.fieldConfig.fieldId + GraphicsConstants.drawLayerPriorityTreshold;
    freeze.bakiLayout.jumpTo(targetPosition);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      final input = getInput(keysPressed);

      GameEventProcessor().jumpFlame(input);
    }

    return KeyEventResult.handled;
  }

  Vector2 _getFieldPosition(int row, int column, double size,
      Vector2 basePosition, bool hasObstacle, double perspective) {
    double halfHeight = size * (1 - perspective) / 2;

    // x = x + (halfOfWidth) * column + (halfOfWidth) * row   >> for relative indenting each row
    // y = y + (halfOfHeight) * row - (halfOfHeight) * column  >> for relative indenting each row
    return Vector2(basePosition.x + (size / 2) * column + (size / 2) * row,
        basePosition.y + (halfHeight * row) - (halfHeight * column));
  }
}
