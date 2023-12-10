import '../graphics/graphics_constants.dart';
import '../models/field.dart';

extension FieldConfigExtension on FieldConfig {
  /// obstacle priority should be higher than the characters to overlap them in drawing
  /// drawing rule: character should overlap field-deck, obstacle should overlap character
  int getFieldDrawPriority() {
    return hasObstacle
        ? fieldId + GraphicsConstants.drawLayerPriorityTreshold
        : fieldId;
  }
}
