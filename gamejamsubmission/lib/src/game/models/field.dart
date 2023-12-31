class FieldConfig {
  final bool hasGroundLeft;
  final bool hasGroundRight;
  final bool hasObstacle;
  final bool hasHighObstacle;
  final double darkness;
  final int locationX;
  final int locationY;
  final int fieldId;
  final bool isFinish;

  FieldConfig(
      {required this.locationX,
      required this.locationY,
      required this.fieldId,
      required this.darkness,
      this.isFinish = false,
      this.hasGroundLeft = false,
      this.hasGroundRight = false,
      this.hasObstacle = false,
      this.hasHighObstacle = false});
}
