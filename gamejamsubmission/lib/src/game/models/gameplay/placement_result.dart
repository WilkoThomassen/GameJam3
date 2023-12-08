import 'package:gamejamsubmission/src/game/models/field.dart';

import '../baki.dart';

class PlacementResult {
  final Baki placedBaki;
  final int fieldId;

  PlacementResult({required this.placedBaki, required this.fieldId});
}
