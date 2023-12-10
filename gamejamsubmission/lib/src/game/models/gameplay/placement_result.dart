import 'package:gamejamsubmission/src/game/models/field.dart';

import '../character.dart';

class PlacementResult {
  final Character placedCharacter;
  final int fieldId;

  PlacementResult({required this.placedCharacter, required this.fieldId});
}
