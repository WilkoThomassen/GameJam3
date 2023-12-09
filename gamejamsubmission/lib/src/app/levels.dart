class Levels {
  static List<Level> levels = [
    Level(levelNr: 1, gridSize: 5, frosties: 3),
    Level(levelNr: 2, gridSize: 6, frosties: 5),
    Level(levelNr: 3, gridSize: 8, frosties: 8),
    Level(levelNr: 4, gridSize: 10, frosties: 12),
    Level(levelNr: 5, gridSize: 12, frosties: 18),
  ];
}

class Level {
  final int levelNr;
  final int gridSize;
  final int frosties;

  Level(
      {required this.levelNr, required this.gridSize, required this.frosties});
}
