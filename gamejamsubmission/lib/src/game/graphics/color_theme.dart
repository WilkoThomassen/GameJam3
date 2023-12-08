import 'dart:math';
import 'dart:ui';

class ColorTheme {
  // fields
  static Color debugTextColor = Color.fromARGB(255, 161, 42, 42);

  static Color fieldColorIce = const Color.fromARGB(255, 125, 229, 255);
  static Color fieldColorGrass = const Color.fromARGB(255, 169, 255, 77);
  static Color fieldColorBoring = Color.fromARGB(255, 180, 183, 177);
  static Color fieldColorSelected = Color.fromARGB(255, 103, 16, 103);
  static Color fieldColorHovered = Color.fromARGB(255, 248, 55, 248);
  static Color fieldColorGround = const Color.fromARGB(255, 219, 148, 49);
  static Color fieldColorObstacle = const Color.fromARGB(255, 254, 241, 224);

  static Color get bakiPlayerOne => const Color.fromARGB(255, 55, 164, 248);
  static Color get bakiPlayerTwo => const Color.fromARGB(255, 248, 181, 55);
  static Color get bakiPlayerThree => const Color.fromARGB(255, 248, 55, 71);
  static Color get bakiPlayerFour => const Color.fromARGB(255, 69, 179, 33);

  static Color getRandomPlayerColor() {
    int colorNr = Random().nextInt(4);
    var colors = [
      ColorTheme.bakiPlayerOne,
      ColorTheme.bakiPlayerTwo,
      ColorTheme.bakiPlayerThree,
      ColorTheme.bakiPlayerFour,
    ];

    return colors[colorNr];
  }
}
