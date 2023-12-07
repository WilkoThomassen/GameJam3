import 'package:gamejamsubmission/src/game/processors/field_processor.dart';
import 'package:gamejamsubmission/main.dart';

import '../components/field.dart';

class FieldHelper {
  static Field getFieldComponentByFieldId(int fieldId) {
    return gameRef.children
        .whereType<Field>()
        .firstWhere((f) => f.fieldConfig.fieldId == fieldId);
  }

  static Field getNeighboringField(int fieldId, int neighborIndex) {
    var surrFields = FieldProcessor.getAvailableSurroundingFieldIds(fieldId);

    try {
      var field = surrFields[neighborIndex];
    } catch (e) {
      print('gaat fout');
    }

    return getFieldComponentByFieldId(surrFields[neighborIndex]);
    // int neighborFieldId =
    //     FieldProcessor.getAvailableSurroundingFieldIds(fieldId)[neighborIndex];
    // return getFieldComponentByFieldId(neighborFieldId);
  }
}
