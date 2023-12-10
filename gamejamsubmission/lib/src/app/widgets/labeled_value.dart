import 'package:flutter/material.dart';

class LabeledValue extends StatelessWidget {
  const LabeledValue(
      {super.key, required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(color: valueColor),
        )
      ],
    );
  }
}
