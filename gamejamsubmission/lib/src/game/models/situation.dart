import 'package:gamejamsubmission/src/game/models/models.dart';

class Situation {
  final int turns;
  final Player turnPlayer;
  final List<SituationField> fields;

  Situation({this.turns = 1, required this.turnPlayer, required this.fields});

  Situation instanceWith(
      {int? turns, Player? turnPlayer, List<SituationField>? fields}) {
    return Situation(
        turns: turns ?? this.turns,
        turnPlayer: turnPlayer ?? this.turnPlayer,
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
