import 'package:flame/components.dart';

class PaintCoordinates {
  final Vector2 left;
  final Vector2 top;
  final Vector2 right;
  final Vector2 bottom;

  PaintCoordinates({required this.left, required this.top, required this.right, required this.bottom});

  List<Vector2> toVectors() {
    return [left, bottom, right, top];
  }
}
