import 'package:flutter/material.dart';

extension PaintExtension on Paint {
  Paint clone() {
    return Paint()
      ..color = color
      ..style = style;
  }
}
