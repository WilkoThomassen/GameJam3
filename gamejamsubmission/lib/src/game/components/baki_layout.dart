import 'package:flame/collisions.dart';
import 'package:gamejamsubmission/src/game/graphics/models/baki_data.dart';
import 'package:gamejamsubmission/src/game/models/player.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'dart:ui';

import '../graphics/color_theme.dart';

class BakiLayout extends PositionComponent with CollisionCallbacks {
  final BakiData bakiData;
  late Paint body;
  late Paint bodyBorder;
  late Paint eye;
  late Paint eyeBorder;
  late Paint iris;

  late Offset leftEyeOffset;
  late Offset rightEyeOffset;
  late Offset leftIrisOffset;
  late Offset rightIrisOffset;
  late Offset leftIrisLookUpOffset;
  late Offset rightIrisLookUpOffset;

  VoidCallback? onJumpCompleted;

  bool toLeft = true;
  bool defeated = false;

  late ShapeHitbox hitbox;

  final int explodeAnimationDurationMs = 500;

  BakiLayout(this.bakiData)
      : super(
          size: Vector2(bakiData.size, bakiData.size),
          anchor: Anchor.topCenter,
        ) {
    body = Paint();
    body.color = bakiData.color;
    body.style = PaintingStyle.fill;
    _setShader();
    bodyBorder = Paint()
      ..color = const Color(0xFF000000)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    eye = Paint()
      ..color = const Color.fromARGB(255, 253, 252, 240)
      ..style = PaintingStyle.fill;
    eyeBorder = Paint()
      ..color = const Color.fromARGB(255, 68, 68, 68)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    iris = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.fill;

    double baseLeftEyeOffset = bakiData.size / 3;
    double baseRightEyeOffset = baseLeftEyeOffset * 1.4;
    leftEyeOffset = Offset(baseLeftEyeOffset, baseLeftEyeOffset);
    rightEyeOffset = Offset(baseRightEyeOffset, baseRightEyeOffset);

    leftIrisOffset = Offset(leftEyeOffset.dx, leftEyeOffset.dy);
    rightIrisOffset = Offset(rightEyeOffset.dx, rightEyeOffset.dy);

    leftIrisLookUpOffset = Offset(leftEyeOffset.dx, leftEyeOffset.dy / 1.25);
    rightIrisLookUpOffset = Offset(rightEyeOffset.dx, rightEyeOffset.dy / 1.25);

    if (bakiData.isFlipped) flipHorizontally();

    // define hitbox for collision
    hitbox = CircleHitbox()
      ..renderShape = false
      ..paint = eyeBorder;
    add(hitbox);
  }

  void _setShader() {
    double gradientOffset = bakiData.size / 2;
    body.shader = Gradient.linear(
      Offset(gradientOffset, gradientOffset), // right lower corner
      bakiData.startPoint,
      [
        body.color,
        body.color.withGreen(255),
      ],
    );
  }

  void jumpTo(Vector2 targetPosition) {
    // draw path (temp code)
    // see move along path effects: https://github.com/flame-engine/flame/blob/main/examples/lib/stories/effects/move_effect_example.dart

    // move this shit to extensions and preload paths for performance?

    //Path jumpToNeighborPath = Path()..moveTo(position.x, position.y);
    if (targetPosition.x > position.x && toLeft == true ||
        targetPosition.x < position.x && toLeft == false) {
      flipHorizontally();
      toLeft = !toLeft;
    }

    Path jumpToNeighborPath = Path()..moveTo(0, 0);

    // set relative target position offset for determining path
    final targetPositionOffset =
        Offset(targetPosition.x - position.x, targetPosition.y - position.y);

    // determine curved path to let the baki explode to
    jumpToNeighborPath.arcToPoint(targetPositionOffset,
        radius: Radius.circular(10),
        rotation: 45,
        largeArc: true,
        clockwise: targetPosition.x > position.x);

    add(MoveAlongPathEffect(onComplete: () {
      if (onJumpCompleted != null) {
        onJumpCompleted!();
      }
    },
        jumpToNeighborPath,
        EffectController(
            curve: Curves.fastEaseInToSlowEaseOut, duration: 0.4)));
  }

  void turnToPlayer(Player player) {
    Future.delayed(Duration(milliseconds: explodeAnimationDurationMs), () {
      body.color = player.color;
      _setShader();
    });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(bakiData.path, body);
    canvas.drawPath(bakiData.path, bodyBorder);
    if (!defeated) {
      canvas.drawCircle(leftEyeOffset, bakiData.leftEyeSize, eye);
      canvas.drawCircle(leftEyeOffset, bakiData.leftEyeSize, eyeBorder);
      canvas.drawCircle(leftIrisOffset, bakiData.leftEyeSize / 6, iris);
      canvas.drawCircle(rightEyeOffset, bakiData.rightEyeSize, eye);
      canvas.drawCircle(rightEyeOffset, bakiData.rightEyeSize, eyeBorder);
      canvas.drawCircle(rightIrisOffset, bakiData.rightEyeSize / 6, iris);
    } else {
      // dead eyes
      canvas.drawLine(leftEyeOffset,
          _getDeadEyeOffset(leftEyeOffset, bakiData.leftEyeSize), eyeBorder);

      canvas.drawLine(
          Offset(leftEyeOffset.dx, leftEyeOffset.dy + bakiData.leftEyeSize),
          Offset(leftEyeOffset.dx + bakiData.leftEyeSize, leftEyeOffset.dy),
          eyeBorder);

      canvas.drawLine(rightEyeOffset,
          _getDeadEyeOffset(rightEyeOffset, bakiData.rightEyeSize), eyeBorder);

      canvas.drawLine(
          Offset(rightEyeOffset.dx, rightEyeOffset.dy + bakiData.rightEyeSize),
          Offset(rightEyeOffset.dx + bakiData.rightEyeSize, rightEyeOffset.dy),
          eyeBorder);
    }
  }

  Offset _getDeadEyeOffset(Offset offset, double size) {
    return Offset(offset.dx + size, offset.dy + size);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    // only defeated when collision is with flame
    if ((other as BakiLayout).body.color == ColorTheme.flame ||
        body.color == ColorTheme.flame) {
      body.color = ColorTheme.frozen;
      defeated = true;
      _setShader();
    }
  }
}
