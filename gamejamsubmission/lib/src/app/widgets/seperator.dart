import 'package:flutter/material.dart';

class VerticalSeperator extends StatelessWidget {
  const VerticalSeperator({super.key, this.factor = 1});

  final double factor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 20 * factor);
  }
}

class HorizontalSeperator extends StatelessWidget {
  const HorizontalSeperator({super.key, this.factor = 1});

  final double factor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 20 * factor);
  }
}
