import 'dart:math';
import 'package:gamejamsubmission/src/game/graphics/models/character_data.dart';
import 'package:flutter/material.dart';

class CharacterGenerator {
  final int _edgesCount = 6;
  final int _minGrowth = 6;
  late Offset _startPoint;

  CharacterData generate(double size,
      {required Color color, bool isShady = false, String? id}) {
    double minEyesPadding = size / 3.5;
    double maxEyesPadding = size / 2.5;
    EdgeInsets eyesPadding =
        EdgeInsets.all(Randomizer().getRandom(minEyesPadding, maxEyesPadding));

    double minLeftEyeSize = size / 11;
    double maxLeftEyeSize = size / 9;

    double minRightEyeSize = size / 8;
    double maxRightEyeSize = size / 6;

    List<Offset> animationStartingPoints = createPoints(size);
    Path path = createPath(animationStartingPoints);

    return CharacterData(
      id: id,
      size: size,
      color: color,
      isAnimating: true,
      startPoint: _startPoint,
      path: path,
      animationStartingPoints: animationStartingPoints,
      isShady: isShady,
      isFlipped: false,
      leftEyeSize: Randomizer().getRandom(minLeftEyeSize, maxLeftEyeSize),
      rightEyeSize: Randomizer().getRandom(minRightEyeSize, maxRightEyeSize),
      eyesPadding: eyesPadding,
    );
  }

  double _magicPoint(double value, double min, double max) {
    double radius = min + (value * (max - min));
    if (radius > max) {
      radius = radius - min;
    } else if (radius < min) {
      radius = radius + min;
    }
    return radius;
  }

  double _toRad(double deg) => deg * (pi / 180.0);

  List<double> _divide(int count) {
    double deg = 360 / count;
    return List.generate(count, (i) => i * deg).toList();
  }

  Offset _point(Offset origin, double radius, double degree) {
    double x = origin.dx + (radius * cos(_toRad(degree)));
    double y = origin.dy + (radius * sin(_toRad(degree)));
    return Offset(x.round().toDouble(), y.round().toDouble());
  }

  List<Offset> createPoints(double size) {
    double outerRad = size / 2;
    double innerRad = _minGrowth * (outerRad / 10);
    Offset center = Offset(size / 2, size / 2);

    List<double> slices = _divide(_edgesCount);
    int? randomInt;
    int maxRandomValue = ([99, 999, 9999, 99999, 999999]..shuffle()).first;
    randomInt = Random().nextInt(maxRandomValue);

    var randVal = _randomDoubleGenerator(randomInt);
    List<Offset> originPoints = [];
    List<Offset> destPoints = [];

    for (var degree in slices) {
      double O = _magicPoint(randVal(), innerRad, outerRad);
      Offset start = _point(center, innerRad, degree);
      Offset end = _point(center, O, degree);
      originPoints.add(start);
      destPoints.add(end);
    }
    return destPoints;
  }

  Path createPath(List<Offset> points) {
    List<List<double>> curves = [];

    Offset mid = (points[0] + points[1]) / 2;
    _startPoint = mid;

    for (var i = 0; i < points.length; i++) {
      var p1 = points[(i + 1) % points.length];
      var p2 = points[(i + 2) % points.length];
      mid = (p1 + p2) / 2;

      curves.add([p1.dx, p1.dy, mid.dx, mid.dy]);
    }

    var path = Path();
    path.moveTo(_startPoint.dx, _startPoint.dy);
    for (var curve in curves) {
      path.quadraticBezierTo(curve[0], curve[1], curve[2], curve[3]);
    }
    path.close();

    return path;
  }

  //  https://stackoverflow.com/a/29450606/3096740
  double Function() _randomDoubleGenerator(int seedValue) {
    var mask = 0xffffffff;
    int mw = (123456789 + seedValue) & mask;
    int mz = (987654321 - seedValue) & mask;

    return () {
      mz = (36969 * (mz & 65535) + ((mz & mask) >> 16)) & mask;
      mw = (18000 * (mw & 65535) + ((mw & mask) >> 16)) & mask;

      final result = ((((mz << 16) + (mw & 65535)) & mask) >> 0) / 4294967296;
      return result;
    };
  }
}

class CharacterPoints {
  List<Offset> destPoints;
  Offset? center;
  double? innerRad;
  String? id;
  CharacterPoints({
    required this.destPoints,
    this.center,
    this.id,
    this.innerRad,
  });
}

class Randomizer {
  double getRandom(double min, double max) {
    double randomValue = Random().nextInt((max + 1 - min).round()) + min;
    return randomValue;
  }

  double getRandomByFactor(double minValue, double diffFactor) {
    return getRandom(minValue, minValue * diffFactor);
  }

  bool getRandomBool() {
    return Random().nextBool();
  }
}

class ColorConstants {
  static Color get shadowColor => const Color.fromARGB(255, 68, 68, 68);
  static Color get characterEyeWhite =>
      const Color.fromARGB(255, 253, 252, 240);
  static Color get characterEyeStroke => const Color.fromARGB(255, 68, 68, 68);
  static Color get characterPlayerOne =>
      const Color.fromARGB(255, 55, 164, 248);
  static Color get characterPlayerTwo =>
      const Color.fromARGB(255, 248, 181, 55);
  static Color get characterPlayerThree =>
      const Color.fromARGB(255, 248, 55, 71);
  static Color get characterPlayerFour =>
      const Color.fromARGB(255, 69, 179, 33);
}
