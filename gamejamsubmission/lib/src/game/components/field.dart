import 'dart:async';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:gamejamsubmission/main.dart';
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

    fieldPaint = Paint()
      ..color = ColorTheme.fieldColorBoring
      ..style = PaintingStyle.fill;
    groundPaint = Paint()
      ..color = ColorTheme.fieldColorGround
      ..style = PaintingStyle.fill;
    obstaclePaint = Paint()
      ..color = ColorTheme.fieldColorObstacle
      ..style = PaintingStyle.fill;
    numberPaintStyle = TextStyle(color: ColorTheme.debugTextColor);
  }

  late PaintCoordinates fieldPaintCoordinates;
  late PaintCoordinates fieldLeftGroundPaintCoordinates;
  late PaintCoordinates fieldRightGroundPaintCoordinates;
  late Paint fieldPaint;
  late Paint groundPaint;
  late Paint obstaclePaint;
  late TextStyle numberPaintStyle;
  double get fieldSize => size.x / 2;
  double _perspective = 0;
  late double _fieldGroundDepth;
  late bool _showDebugInfo;

  @override
  void onMount() {
    addToGameWidgetBuild(() {
      var config = ref.read(gameConfigProvider);
      _perspective = config.perspective;
      _fieldGroundDepth = config.fieldGroundDepth;
      _showDebugInfo = config.showDebugInfo;
      ref.listen(gameConfigProvider, (previous, value) {
        if (previous?.perspective != value.perspective) {
          _perspective = value.perspective;
        }
        _showDebugInfo = value.showDebugInfo;
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
        top: Vector2(0, -fieldSize + _factorize(_perspective)),
        right: Vector2(fieldSize, 0),
        bottom: Vector2(0, fieldSize - _factorize(_perspective)));

    fieldLeftGroundPaintCoordinates = PaintCoordinates(
        left: Vector2(fieldPaintCoordinates.left.x,
            fieldPaintCoordinates.left.y + _factorize(_fieldGroundDepth)),
        top: fieldPaintCoordinates.left,
        right: fieldPaintCoordinates.bottom,
        bottom: Vector2(fieldPaintCoordinates.bottom.x,
            fieldPaintCoordinates.bottom.y + _factorize(_fieldGroundDepth)));

    fieldRightGroundPaintCoordinates = PaintCoordinates(
        left: fieldPaintCoordinates.bottom,
        top: fieldPaintCoordinates.right,
        right: Vector2(fieldPaintCoordinates.right.x,
            fieldPaintCoordinates.right.y + _factorize(_fieldGroundDepth)),
        bottom: Vector2(fieldPaintCoordinates.bottom.x,
            fieldPaintCoordinates.bottom.y + _factorize(_fieldGroundDepth)));

    canvas.drawPath(fieldPaintCoordinates.toPath(), fieldPaint);
    canvas.drawPath(
        fieldPaintCoordinates.toPath(), _getBorderPaint(fieldPaint));

    if (fieldConfig.hasGroundLeft) {
      canvas.drawPath(fieldLeftGroundPaintCoordinates.toPath(), groundPaint);
      canvas.drawPath(fieldLeftGroundPaintCoordinates.toPath(),
          _getBorderPaint(groundPaint));
    }
    if (fieldConfig.hasGroundRight) {
      canvas.drawPath(fieldRightGroundPaintCoordinates.toPath(), groundPaint);
      canvas.drawPath(fieldRightGroundPaintCoordinates.toPath(),
          _getBorderPaint(groundPaint));
    }

    if (_showDebugInfo) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: fieldConfig.fieldId.toString(),
          style: numberPaintStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: fieldSize,
      );
      textPainter.paint(canvas, Offset.zero);
    }

    super.render(canvas);
  }

  double _factorize(double input) {
    return input * fieldSize;
  }
}
