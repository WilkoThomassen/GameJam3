import 'package:flutter/material.dart';

extension CustomThemeData on ThemeData {
  Color get shapeColor => const Color.fromRGBO(57, 60, 14, 1);
  Color get borderColor => const Color.fromARGB(255, 218, 176, 48);
  double get edgeRadius => 10;
  double get defaultPadding => 10;
}
