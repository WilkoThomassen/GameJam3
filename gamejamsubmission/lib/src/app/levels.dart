class Levels {
  static List<LevelDefinition> levels = [
    LevelDefinition(levelNr: 1, gridSize: 6, frosties: 2),
    LevelDefinition(levelNr: 2, gridSize: 7, frosties: 5, spawnDelay: 900),
    LevelDefinition(levelNr: 3, gridSize: 9, frosties: 10, spawnDelay: 800),
    LevelDefinition(levelNr: 4, gridSize: 10, frosties: 12, spawnDelay: 700),
    LevelDefinition(levelNr: 5, gridSize: 12, frosties: 18, spawnDelay: 700),
    LevelDefinition(levelNr: 6, gridSize: 13, frosties: 20, spawnDelay: 600),
    LevelDefinition(levelNr: 7, gridSize: 10, frosties: 30, spawnDelay: 600),
    LevelDefinition(levelNr: 8, gridSize: 9, frosties: 40, spawnDelay: 600),
    LevelDefinition(levelNr: 9, gridSize: 10, frosties: 50, spawnDelay: 600),
    LevelDefinition(levelNr: 10, gridSize: 8, frosties: 90, spawnDelay: 400),
    LevelDefinition(levelNr: 11, gridSize: 7, frosties: 90, spawnDelay: 200),
  ];
}

class LevelDefinition {
  final int levelNr;
  final int gridSize;
  final int frosties;
  final int spawnDelay;

  LevelDefinition(
      {required this.levelNr,
      required this.gridSize,
      required this.frosties,
      this.spawnDelay = 1000});
}
