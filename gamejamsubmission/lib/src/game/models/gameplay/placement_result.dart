import '../baki.dart';

class PlacementResult {
  final Baki? placedBaki;
  final PlacementStatus placementStatus;

  PlacementResult({this.placedBaki, required this.placementStatus});
}

enum PlacementStatus { notPlaced, placed, explode }
