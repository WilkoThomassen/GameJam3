import 'package:flutter/material.dart';
import 'package:gamejamsubmission/src/game/graphics/graphics.dart';
import 'package:flame/components.dart';

extension PaintCoordinatesExtension on PaintCoordinates {
  PaintCoordinates moveUp(int factor, double fieldGroundDepth) {
    return PaintCoordinates(
        left: _moveUp(left, factor, fieldGroundDepth),
        top: _moveUp(top, factor, fieldGroundDepth),
        right: _moveUp(right, factor, fieldGroundDepth),
        bottom: _moveUp(bottom, factor, fieldGroundDepth));
  }

  PaintCoordinates moveLeftUp(int factor, double fieldGroundDepth) {
    // left and bottom maximized on 1
    return PaintCoordinates(
        left: _moveUp(left, 1, fieldGroundDepth),
        top: _moveUp(top, factor, fieldGroundDepth),
        right: _moveUp(right, factor, fieldGroundDepth),
        bottom: _moveUp(bottom, 1, fieldGroundDepth));
  }

  PaintCoordinates moveRightUp(int factor, double fieldGroundDepth) {
    return PaintCoordinates(
        left: _moveUp(left, factor, fieldGroundDepth),
        top: _moveUp(top, factor, fieldGroundDepth),
        right: _moveUp(right, 1, fieldGroundDepth),
        bottom: _moveUp(bottom, 1, fieldGroundDepth));
  }

  Vector2 _moveUp(Vector2 input, int factor, double fieldGroundDepth) {
    double delta = fieldGroundDepth * factor;
    return Vector2(input.x, input.y - delta);
  }

  Path toPath() {
    Path result = Path();
    result.moveTo(left.x, left.y);
    result.lineTo(top.x, top.y);
    result.lineTo(right.x, right.y);
    result.lineTo(bottom.x, bottom.y);
    result.close();

    return result;
  }
}
