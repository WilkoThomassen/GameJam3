import 'package:flutter/material.dart';

class CharacterData {
  double size;
  String? id;
  final Offset startPoint;
  Path path;
  final bool isFlipped;
  final List<Offset> animationStartingPoints;
  final double leftEyeSize;
  final double rightEyeSize;
  final EdgeInsets eyesPadding;
  final EdgeInsets? leftIrisPadding;
  final EdgeInsets? rightIrisPadding;
  Color color;
  final bool isAnimating;
  bool isShady;

  CharacterData(
      {required this.size,
      required this.startPoint,
      required this.color,
      required this.path,
      required this.leftEyeSize,
      required this.rightEyeSize,
      required this.eyesPadding,
      required this.animationStartingPoints,
      this.isFlipped = false,
      this.id,
      this.isShady = false,
      this.leftIrisPadding,
      this.rightIrisPadding,
      required this.isAnimating});
}
