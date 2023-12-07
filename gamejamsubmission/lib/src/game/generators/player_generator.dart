import 'package:gamejamsubmission/src/game/graphics/color_theme.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:flutter/material.dart';

class PlayerGenerator {
  static List<Player> generatePlayers(int playerCount) {
    List<Color> takenColors = [];
    List<Player> players = [];
    for (int i = 0; i < playerCount; i++) {
      var playerColor = getRandomNonTakenColor(takenColors);
      takenColors.add(playerColor);
      Player genPlayer =
          Player(id: i.toString(), name: 'Player $i', color: playerColor);
      players.add(genPlayer);
    }
    return players;
  }

  static Color getRandomNonTakenColor(List<Color> takenColors) {
    while (true) {
      var color = ColorTheme.getRandomPlayerColor();
      if (!takenColors.any((c) => c.value == color.value)) {
        return color;
      }
    }
  }
}
