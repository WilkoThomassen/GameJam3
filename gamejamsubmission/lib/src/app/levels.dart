class Levels {
  static List<LevelDefinition> levels = [
    LevelDefinition(levelNr: 1, gridSize: 6, frosties: 4),
    LevelDefinition(levelNr: 2, gridSize: 7, frosties: 8),
    LevelDefinition(levelNr: 3, gridSize: 9, frosties: 12),
    LevelDefinition(levelNr: 4, gridSize: 10, frosties: 18),
    LevelDefinition(levelNr: 5, gridSize: 12, frosties: 22),
    LevelDefinition(levelNr: 6, gridSize: 13, frosties: 30),
    LevelDefinition(levelNr: 7, gridSize: 10, frosties: 40),
    LevelDefinition(levelNr: 8, gridSize: 9, frosties: 50),
    LevelDefinition(levelNr: 9, gridSize: 10, frosties: 80),
  ];
}

class LevelDefinition {
  final int levelNr;
  final int gridSize;
  final int frosties;

  LevelDefinition(
      {required this.levelNr, required this.gridSize, required this.frosties});
}
