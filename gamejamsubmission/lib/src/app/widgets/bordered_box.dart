import 'package:gamejamsubmission/src/app/widgets/custom_theme.dart';
import 'package:flutter/material.dart';

class BorderedBox extends StatelessWidget {
  const BorderedBox({super.key, required this.child, this.width, this.height});
  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(Theme.of(context).defaultPadding),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).borderColor, width: 1),
          borderRadius: BorderRadius.circular(Theme.of(context).edgeRadius)),
      child: child,
    );
  }
}
