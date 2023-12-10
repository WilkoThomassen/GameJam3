import 'package:gamejamsubmission/src/game/components/character_layout.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';

class Character {
  Character(
      {required this.fromPlayer,
      this.isAnimating = false,
      this.isFlame = false,
      required this.characterLayout});
  Player fromPlayer;
  final bool isAnimating;
  CharacterLayout characterLayout;
  final bool isFlame;

  int locationFieldId = 0;
}
