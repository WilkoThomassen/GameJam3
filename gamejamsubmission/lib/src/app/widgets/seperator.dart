import 'package:flutter/material.dart';

class VerticalSeperator extends StatelessWidget {
  const VerticalSeperator({this.factor = 1});

  final double factor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 20 * factor);
  }
}

class HorizontalSeperator extends StatelessWidget {
  const HorizontalSeperator({this.factor = 1});

  final double factor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 20 * factor);
  }
}
