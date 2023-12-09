import 'dart:math';
import 'dart:ui';

class ColorTheme {
  // fields
  static Color debugTextColor = Color.fromARGB(255, 161, 42, 42);

  static Color freeze = Color.fromARGB(255, 75, 213, 247);
  static Color flame = const Color.fromARGB(255, 255, 117, 11);

  static Color frozen = const Color.fromARGB(255, 253, 252, 240);

  static Color fieldColorFinish = Color.fromARGB(255, 77, 255, 89);
  static Color fieldColorBoring = Color.fromARGB(255, 140, 208, 197);
  static Color fieldColorGround = Color.fromARGB(255, 232, 168, 80);
  static Color fieldColorObstacle = const Color.fromARGB(255, 254, 241, 224);

  static Color appBackground = Color.fromARGB(255, 218, 249, 255);
  static Color buttonForeground = Color.fromARGB(255, 9, 39, 63);

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
