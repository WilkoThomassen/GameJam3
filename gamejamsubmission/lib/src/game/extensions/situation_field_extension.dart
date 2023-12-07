import 'package:gamejamsubmission/src/game/processors/field_processor.dart';
import 'package:gamejamsubmission/src/game/state/game_provider.dart';
import 'package:gamejamsubmission/main.dart';

import '../models/models.dart';

extension SituationFieldExtension on SituationField {
  bool shouldExplodeOnPlaceBaki() {
    // count surrouding non-obstacle fields
    final availableSurroudingFields =
        FieldProcessor.getAvailableSurroundingFieldIds(field.fieldId);

    if (bakis.length == availableSurroudingFields.length) return true;

    return false;
  }
}
