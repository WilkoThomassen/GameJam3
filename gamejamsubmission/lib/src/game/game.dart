import 'dart:developer';

import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:gamejamsubmission/src/game/components/baki_layout.dart';
import 'package:gamejamsubmission/src/game/components/components.dart';
import 'package:gamejamsubmission/src/game/extensions/extensions.dart';
import 'package:gamejamsubmission/src/game/game_exports.dart';
import 'package:gamejamsubmission/src/game/helpers/field_helper.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:gamejamsubmission/main.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game_config/config.dart';
import 'graphics/graphics_constants.dart';

class BakiTakiGame extends FlameGame with RiverpodGameMixin {
  late GameConfig config;
  late BakiGame game;
  late Vector2 gameSize;
  WidgetRef? ref;

  void initialize(WidgetRef widgetRef) {
    ref ??= widgetRef;
    // redraw when game is re-created
    globalScope.listen(gameProvider, (previous, next) {
      if (hasLayout && previous!.gameId != next!.gameId) {
        _drawGame();
      } else {
        log('wont repaint');
      }
    });
  }

  @override
  Future<void> onLoad() async {
    _drawGame();
  }

  void _drawGame() {
    config = ref!.read(gameConfigProvider);
    game = ref!.read(gameProvider)!;
    // clear field before (re)drawing the game
    removeAll(children.whereType<Field>());
    removeAll(children.whereType<BakiLayout>());

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
            onTap: () {
              gameEventProcessor.placeBakiOnField(fieldConfig);
            }),
      );
    }

    globalScope.listen(gameConfigProvider, (previous, value) {
      // reposition field when perspective is changed
      if (value.perspective != previous?.perspective) {
        for (var field in children.whereType<Field>()) {
          field.position = _getFieldPosition(
              field.fieldConfig.locationX,
              field.fieldConfig.locationY,
              game.level.fieldSize,
              basePosition,
              field.fieldConfig.hasObstacle,
              value.perspective);
        }
      }
    });

    if (config.showDebugInfo) {
      add(FpsTextComponent(position: Vector2(size.x - 100, size.y - 24)));
    }
  }

  void addBakiOnField(Baki bakiToPlace, FieldConfig fieldConfig) {
    final fieldPosition =
        FieldHelper.getFieldComponentByFieldId(fieldConfig.fieldId).position;

    add(bakiToPlace.bakiLayout
      ..position = game.getLocationByFieldSituation(
          fieldPosition: fieldPosition, fieldId: fieldConfig.fieldId)
      ..priority =
          fieldConfig.fieldId + GraphicsConstants.drawLayerPriorityTreshold);
  }

  void explode(FieldConfig field, List<BakiLayout> fieldBakis) {
    for (var baki in fieldBakis.take(4)) {
      // get the position of the field on the side of the direction
      Field targetField = FieldHelper.getNeighboringField(
          field.fieldId, fieldBakis.indexOf(baki));

      final targetPosition = game.getLocationByFieldSituation(
          fieldPosition: targetField.position,
          fieldId: targetField.fieldConfig.fieldId);

      baki.priority = targetField.fieldConfig.fieldId +
          GraphicsConstants.drawLayerPriorityTreshold +
          2;
      baki.animateExplodeTo(targetPosition);
    }
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
