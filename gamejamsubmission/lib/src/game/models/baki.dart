import 'package:gamejamsubmission/src/game/components/baki_layout.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';

class Baki {
  Baki(
      {required this.fromPlayer,
      this.isAnimating = false,
      required this.bakiLayout});
  Player fromPlayer;
  final bool isAnimating;
  final BakiLayout bakiLayout;

  int locationFieldId = 0;
}
