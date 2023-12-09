import 'package:gamejamsubmission/src/game/models/models.dart';

class Situation {
  final int turns;
  final Player turnPlayer;
  final List<SituationField> fields;

  // fields purpose is only to access directly for performance reasons
  final int? playerOnFieldId;

  Situation(
      {this.turns = 1,
      required this.turnPlayer,
      required this.fields,
      this.playerOnFieldId});

  Situation instanceWith(
      {int? turns,
      Player? turnPlayer,
      List<SituationField>? fields,
      int? playerOnFieldId}) {
    return Situation(
        turns: turns ?? this.turns,
        turnPlayer: turnPlayer ?? this.turnPlayer,
        playerOnFieldId: playerOnFieldId ?? this.playerOnFieldId,
        fields: fields ?? this.fields);
  }
}

class SituationField {
  SituationField({required this.bakis, required this.field});

  final List<Baki> bakis;
  final FieldConfig field;

  SituationField instanceWith({List<Baki>? bakis, FieldConfig? field}) {
    return SituationField(
        bakis: bakis ?? this.bakis, field: field ?? this.field);
  }
}
