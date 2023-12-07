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
}
