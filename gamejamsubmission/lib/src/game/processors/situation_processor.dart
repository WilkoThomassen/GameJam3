import 'package:gamejamsubmission/src/game/components/character_layout.dart';
import 'package:gamejamsubmission/src/game/extensions/game_extension.dart';
import 'package:gamejamsubmission/src/game/generators/generators.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';

import '../../../main.dart';
import '../state/game_provider.dart';
import 'field_processor.dart';

class SituationProcessor {
  static Situation clear() {
    final game = globalScope.read(gameProvider)!;
    final situationFields = game.situation.fields;
    for (var situationField
        in globalScope.read(gameProvider)!.situation.fields) {
      situationField.characters.clear();
      // update situationfield
      _persistSituationField(situationField);
    }
    return game.situation.instanceWith(fields: situationFields);
  }

  static Situation placePlayerOnField(Character character, int fieldId) {
    final game = globalScope.read(gameProvider)!;
    final situationFields = game.situation.fields;
    final situationField = game.getSituationFieldById(fieldId);

    situationField.characters.add(character);

    // update situationfield
    _persistSituationField(situationField);

    // return updated situation field and new turn in game
    return game.situation.instanceWith(
        fields: situationFields,
        flameOnFieldId: character.isFlame ? fieldId : null);
  }

  static Situation moveFreeze(
      Character freeze, int originFieldId, int targetFieldId) {
    final game = globalScope.read(gameProvider)!;
    final situationFields = game.situation.fields;

    final originFieldSituation = game.getSituationFieldById(originFieldId);
    final targetFieldSituation = game.getSituationFieldById(targetFieldId);

    originFieldSituation.characters.remove(freeze);
    targetFieldSituation.characters.add(freeze);
    _persistSituationField(originFieldSituation);
    _persistSituationField(targetFieldSituation);

    return game.situation.instanceWith(fields: situationFields);
  }

  static void _persistSituationField(SituationField newSituationField) {
    final situationFields = globalScope.read(gameProvider)!.situation.fields;

    // replace situationField
    final indexOfField = situationFields
        .indexWhere((f) => f.field.fieldId == newSituationField.field.fieldId);
    situationFields[indexOfField] = newSituationField;
  }
}
