import 'package:gamejamsubmission/src/game/models/models.dart';

class Situation {
  final List<SituationField> fields;

  // fields purpose is only to access directly for performance reasons
  final int? flameOnFieldId;

  Situation({required this.fields, this.flameOnFieldId});

  Situation instanceWith(
      {int? turns, List<SituationField>? fields, int? flameOnFieldId}) {
    return Situation(
        flameOnFieldId: flameOnFieldId ?? this.flameOnFieldId,
        fields: fields ?? this.fields);
  }
}

class SituationField {
  SituationField({required this.characters, required this.field});

  final List<Character> characters;
  final FieldConfig field;

  SituationField instanceWith(
      {List<Character>? characters, FieldConfig? field}) {
    return SituationField(
        characters: characters ?? this.characters, field: field ?? this.field);
  }
}
