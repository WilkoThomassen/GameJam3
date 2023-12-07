import '../graphics/graphics_constants.dart';
import '../models/field.dart';

extension FieldConfigExtension on FieldConfig {
  /// obstacle priority should be higher than the baki's to overlap them in drawing
  /// drawing rule: baki should overlap field-deck, obstacle should overlap baki
  int getFieldDrawPriority() {
    return hasObstacle
        ? fieldId + GraphicsConstants.drawLayerPriorityTreshold
        : fieldId;
  }
}
