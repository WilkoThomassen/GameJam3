import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import '../graphics/color_theme.dart';
import '../graphics/models/paint_coordinates.dart';

// see: https://github.com/flame-engine/flame/blob/main/examples/lib/stories/input/hover_callbacks_example.dart

// TODO: retry when polygon hitboxes are fixed
// https://github.com/flame-engine/flame/issues/2827

// draw based on polygon shit
class FieldDeck extends PositionComponent
    with TapCallbacks, HoverCallbacks, GestureHitboxes {
  FieldDeck(this.paintCoordinates, this.fieldPaint, this.parentSize,
      this.darkness, this.onTap) {
    hitbox = PolygonHitbox.relative(paintCoordinates.toVectors(),
        parentSize: parentSize, isSolid: true);
    hitbox.paint = fieldPaint..darken(darkness);
    hitbox.renderShape = true;
  }

  final PaintCoordinates paintCoordinates;
  final VoidCallback onTap;
  Paint fieldPaint;
  late Vector2 parentSize;
  late double darkness;
  late final ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    add(hitbox);
    super.onLoad();
  }

  @override
  void onHoverEnter() {
    fieldPaint.color = fieldPaint.color.darken(0.5);
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    fieldPaint.color = ColorTheme.fieldColorIce.darken(darkness);
    super.onHoverExit();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap();
  }
}
