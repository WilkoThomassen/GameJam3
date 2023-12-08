import 'dart:async';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:gamejamsubmission/main.dart';
import 'package:gamejamsubmission/src/game/components/field_deck.dart';
import 'package:gamejamsubmission/src/game_config/config.dart';
import 'package:gamejamsubmission/src/game/extensions/extensions.dart';
import 'package:gamejamsubmission/src/game/graphics/graphics.dart';
import 'package:gamejamsubmission/src/game/models/field.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Field extends PositionComponent with RiverpodComponentMixin {
  final FieldConfig fieldConfig;
  final VoidCallback onTap;
  late final PolygonComponent leftGround;
  late final PolygonComponent rightGround;

  Field(
      {required this.fieldConfig,
      required Vector2 size,
      required Vector2 position,
      required int priority,
      required this.onTap})
      : super(size: size, position: position, priority: priority) {
    anchor = Anchor.center;

    // fieldLeftGroundPaintCoordinates = PaintCoordinates(
    //     left: Vector2(fieldPaintCoordinates.left.x,
    //         fieldPaintCoordinates.left.y + gameConfig.fieldGroundDepth),
    //     top: fieldPaintCoordinates.left,
    //     right: fieldPaintCoordinates.bottom,
    //     bottom: Vector2(fieldPaintCoordinates.bottom.x,
    //         fieldPaintCoordinates.bottom.y + gameConfig.fieldGroundDepth));

    // fieldRightGroundPaintCoordinates = PaintCoordinates(
    //     left: fieldPaintCoordinates.bottom,
    //     top: fieldPaintCoordinates.right,
    //     right: Vector2(fieldPaintCoordinates.right.x,
    //         fieldPaintCoordinates.right.y + gameConfig.fieldGroundDepth),
    //     bottom: Vector2(fieldPaintCoordinates.bottom.x,
    //         fieldPaintCoordinates.bottom.y + gameConfig.fieldGroundDepth));

    fieldPaint = Paint()
      ..color = ColorTheme.fieldColorIce
      ..style = PaintingStyle.fill;
    groundPaint = Paint()
      ..color = ColorTheme.fieldColorGround
      ..style = PaintingStyle.fill;
    obstaclePaint = Paint()
      ..color = ColorTheme.fieldColorObstacle
      ..style = PaintingStyle.fill;
  }

  late PaintCoordinates fieldPaintCoordinates;
  late PaintCoordinates fieldLeftGroundPaintCoordinates;
  late PaintCoordinates fieldRightGroundPaintCoordinates;
  late Paint fieldPaint;
  late Paint groundPaint;
  late Paint obstaclePaint;
  double get fieldSize => size.x / 2;
  double perspective = 0;

  @override
  void onMount() {
    addToGameWidgetBuild(() {
      var config = ref.read(gameConfigProvider);
      perspective = config.perspective;
      ref.listen(gameConfigProvider, (previous, value) {
        perspective = value.perspective;
      });
    });

    super.onMount();
  }

  Paint _getBorderPaint(Paint basePaint) {
    return Paint()
      ..color = basePaint.color.darken(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
  }

  @override
  void render(Canvas canvas) {
    fieldPaintCoordinates = PaintCoordinates(
        left: Vector2(-fieldSize, -0),
        top: Vector2(0, -fieldSize + (perspective * fieldSize)),
        right: Vector2(fieldSize, 0),
        bottom: Vector2(0, fieldSize - (perspective * fieldSize)));
    canvas.drawPath(fieldPaintCoordinates.toPath(), fieldPaint);
    canvas.drawPath(
        fieldPaintCoordinates.toPath(), _getBorderPaint(fieldPaint));

    super.render(canvas);
  }

  // @override
  // Future<void> onLoad() async {
  //   super.onLoad();

  //   if (fieldConfig.hasObstacle) {
  //     // highObstacles should move up higher than normal obstacles
  //     int moveUpFactor = fieldConfig.hasHighObstacle ? 2 : 1;

  //     if (fieldConfig.hasHighObstacle) {
  //       obstaclePaint.darken(0.2);
  //     }

  //     add(PolygonComponent.relative(
  //         fieldLeftGroundPaintCoordinates
  //             .moveLeftUp(moveUpFactor, gameConfig.fieldGroundDepth)
  //             .toVectors(),
  //         parentSize: size,
  //         paint: obstaclePaint.clone()..darken(0.1)));
  //     add(PolygonComponent.relative(
  //         fieldRightGroundPaintCoordinates
  //             .moveRightUp(moveUpFactor, gameConfig.fieldGroundDepth)
  //             .toVectors(),
  //         parentSize: size,
  //         paint: obstaclePaint.clone()..darken(0.2)));
  //     add(PolygonComponent.relative(
  //         fieldPaintCoordinates
  //             .moveUp(moveUpFactor, gameConfig.fieldGroundDepth)
  //             .toVectors(),
  //         parentSize: size,
  //         paint: obstaclePaint));
  //     // and the borders
  //     add(PolygonComponent.relative(
  //         fieldLeftGroundPaintCoordinates
  //             .moveLeftUp(moveUpFactor, gameConfig.fieldGroundDepth)
  //             .toVectors(),
  //         parentSize: size,
  //         paint: _getBorderPaint(obstaclePaint)));
  //     add(PolygonComponent.relative(
  //         fieldRightGroundPaintCoordinates
  //             .moveRightUp(moveUpFactor, gameConfig.fieldGroundDepth)
  //             .toVectors(),
  //         parentSize: size,
  //         paint: _getBorderPaint(obstaclePaint)));
  //     add(PolygonComponent.relative(
  //         fieldPaintCoordinates
  //             .moveUp(moveUpFactor, gameConfig.fieldGroundDepth)
  //             .toVectors(),
  //         parentSize: size,
  //         paint: _getBorderPaint(obstaclePaint)));
  //   } else {
  //     add(FieldDeck(fieldPaintCoordinates, fieldPaint, size,
  //         fieldConfig.darkness, onTap));
  //     add(PolygonComponent.relative(fieldPaintCoordinates.toVectors(),
  //         parentSize: size, paint: _getBorderPaint(fieldPaint)));
  //   }

  //   if (fieldConfig.hasGroundLeft) {
  //     add(PolygonComponent.relative(fieldLeftGroundPaintCoordinates.toVectors(),
  //         parentSize: size, paint: groundPaint));
  //     add(PolygonComponent.relative(fieldLeftGroundPaintCoordinates.toVectors(),
  //         parentSize: size, paint: _getBorderPaint(groundPaint)));
  //   }
  //   if (fieldConfig.hasGroundRight) {
  //     add(PolygonComponent.relative(
  //         fieldRightGroundPaintCoordinates.toVectors(),
  //         parentSize: size,
  //         paint: groundPaint));
  //     add(PolygonComponent.relative(
  //         fieldRightGroundPaintCoordinates.toVectors(),
  //         parentSize: size,
  //         paint: _getBorderPaint(groundPaint)));
  //   }
  //   if (gameConfig.showDebugInfo) {
  //     TextPaint numberPaint = TextPaint(
  //         style: const TextStyle(color: Color.fromARGB(255, 161, 42, 42)));
  //     add(TextComponent(
  //         text: fieldConfig.fieldId.toString(),
  //         textRenderer: numberPaint,
  //         position: Vector2(size.x / 2.5, size.y / 2.5)));
  //   }
  //}
}
