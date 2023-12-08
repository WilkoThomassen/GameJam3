import 'dart:ui';
import 'package:gamejamsubmission/src/game/graphics/graphics.dart';
import 'package:flame/extensions.dart';

extension FieldPainter on Canvas {
  void drawFieldPart(
      double size, Paint paint, PaintCoordinates paintCoordinates) {
    Path path = Path();
    path.moveTo(paintCoordinates.left.x, paintCoordinates.left.y);
    path.lineTo(paintCoordinates.top.x, paintCoordinates.top.y);
    path.lineTo(paintCoordinates.right.x, paintCoordinates.right.y);
    path.lineTo(paintCoordinates.bottom.x, paintCoordinates.bottom.y);
    path.close();

    // border is a tint darker than field color
    Paint border = Paint()
      ..color = paint.color.darken(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    drawPath(path, paint);
    drawPath(path, border);
  }
}
