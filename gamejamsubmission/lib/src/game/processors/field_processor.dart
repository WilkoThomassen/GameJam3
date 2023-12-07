import '../../game_config/config.dart';
import '../../../main.dart';
import '../state/game_provider.dart';

/// FieldProcessor to retrieve data on model level
/// do not access component / game data in this class. Models-only
class FieldProcessor {
  static List<int> getSurroundingFieldIds(int fieldId) {
    List<int> result = [];
    //int totalFields = (gridSize * gridSize);
    int row = ((fieldId - 1) / gridSize).floor();
    int column = (fieldId - 1) - (row * gridSize);

    // add same field in row before
    if (row > 0) {
      result.add(fieldId - gridSize);
    }
    if (row < gridSize - 1) {
      result.add(fieldId + gridSize);
    }
    if (column > 0) {
      result.add(fieldId - 1);
    }
    if (column < gridSize - 1) {
      result.add(fieldId + 1);
    }

    return result;
  }

  static List<int> getAvailableSurroundingFieldIds(int fieldId,
      {List<int>? obstaclesData}) {
    List<int> obstacles =
        obstaclesData ?? globalScope.read(gameProvider)!.level.obstacles;
    List<int> surroundingFields = getSurroundingFieldIds(fieldId);
    return surroundingFields.where((f) => !obstacles.contains(f)).toList();
  }

  static List<int> _currentPlayGroundProcessedFields = [];

  /// get available surroundings until there are no more available
  static List<int> addConnectedAvailableFields(
      int fieldId, List<int> obstacles) {
    _currentPlayGroundProcessedFields.add(fieldId);
    // get available surroundings until there are no more
    var availableSurroundingFields =
        getAvailableSurroundingFieldIds(fieldId, obstaclesData: obstacles);

    if (availableSurroundingFields.isNotEmpty) {
      for (int surroundingFieldId in availableSurroundingFields
          .where((f) => !_currentPlayGroundProcessedFields.contains(f))) {
        // add available connected fields recursively
        addConnectedAvailableFields(surroundingFieldId, obstacles);
      }
    }
    return _currentPlayGroundProcessedFields;
  }

  static List<int> getBiggestPlayGround(List<int> obstacles) {
    List<int> biggestPlayField = [];

    List<List<int>> playGrounds = [];
    List<int> allProcessedFields = [];

    // iterate through all items
    for (int fieldId = 1; fieldId <= (gridSize * gridSize); fieldId++) {
      // skip if it is an obstacle or already processed
      if (obstacles.contains(fieldId) || allProcessedFields.contains(fieldId)) {
        continue;
      }

      _currentPlayGroundProcessedFields = [];
      List<int> currentPlayGround =
          addConnectedAvailableFields(fieldId, obstacles);
      // all fields from playground are processed
      allProcessedFields.addAll(currentPlayGround);
      playGrounds.add(currentPlayGround);
    }

    // check what is the biggest playfield, this is the main playfield, the others will be set as higher obstacles
    playGrounds.sort((a, b) => a.length.compareTo(b.length));
    biggestPlayField = playGrounds.last;
    return biggestPlayField;
  }

  static bool isConnectedToPlayField(
      int fieldId, List<int> playGround, int gridSize) {
    if (playGround.isEmpty) return false;

    for (int playGroundFieldId in playGround) {
      List<int> surroundingFields = getSurroundingFieldIds(playGroundFieldId);
      if (surroundingFields.contains(fieldId)) {
        return true;
      }
    }

    return false;
  }
}
