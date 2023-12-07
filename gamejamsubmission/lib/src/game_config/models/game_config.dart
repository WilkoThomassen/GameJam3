class GameConfig {
  GameConfig(
      {this.id = 1,
      this.showDebugInfo = false,
      this.gridSize = 8,
      this.perspective = 0.5,
      this.fieldGroundDepth = 0.2,
      this.obstacleFactor = 0.2,
      this.players = 2});
  bool showDebugInfo;
  int gridSize;
  double perspective;
  double fieldGroundDepth;
  double obstacleFactor;
  int players;
  int id;

  GameConfig instanceWith(
      {int? id,
      bool? showDebugInfo,
      int? gridSize,
      double? perspective,
      double? fieldGroundDepth,
      double? obstacleFactor,
      int? players}) {
    return GameConfig(
        id: id ?? this.id,
        showDebugInfo: showDebugInfo ?? this.showDebugInfo,
        gridSize: gridSize ?? this.gridSize,
        perspective: perspective ?? this.perspective,
        fieldGroundDepth: fieldGroundDepth ?? this.fieldGroundDepth,
        obstacleFactor: obstacleFactor ?? this.obstacleFactor,
        players: players ?? this.players);
  }
}
