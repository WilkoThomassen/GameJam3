import 'package:gamejamsubmission/src/game/components/baki_layout.dart';
import 'package:gamejamsubmission/src/game/extensions/game_extension.dart';
import 'package:gamejamsubmission/src/game/extensions/situation_field_extension.dart';
import 'package:gamejamsubmission/src/game/generators/generators.dart';
import 'package:gamejamsubmission/src/game/models/models.dart';
import 'package:gamejamsubmission/src/game_processor/game_event_processor.dart';

import '../../../main.dart';
import '../state/game_provider.dart';
import 'field_processor.dart';

class SituationProcessor {
  // TODO: get game from provider
  static Situation placeBakiOnField(Baki baki, int fieldId) {
    final game = globalScope.read(gameProvider)!;
    final situationFields = game.situation.fields;
    final situationField = game.getSituationFieldById(fieldId);

    situationField.bakis.add(baki);

    // update situationfield
    _replaceSituationField(situationFields, situationField);

    // return updated situation field and new turn in game
    return game.situation.instanceWith(
      fields: situationFields,
    );
  }

  // static Situation explode(int fieldId) {
  //   bool hasChainReaction = false;
  //   final game = globalScope.read(gameProvider.notifier).gameState;
  //   final situationFields = game.situation.fields;

  //   // get all baki's on field, removed them from field and place them on the available fields
  //   final situationField = game.getSituationFieldById(fieldId);
  //   final bakisToExplode = List.from(situationField.bakis);
  //   situationField.bakis.clear();
  //   // update situationfield
  //   _replaceSituationField(situationFields, situationField);

  //   // get surrounding fields and place bakis on them
  //   final surroudingFields =
  //       FieldProcessor.getAvailableSurroundingFieldIds(fieldId);
  //   for (var neighborFieldId in surroudingFields) {
  //     final neighborSituationField =
  //         game.getSituationFieldById(neighborFieldId);
  //     // game rule, if neighbor field has bakis from other player, transform
  //     // into bakis of current player
  //     for (var baki in neighborSituationField.bakis) {
  //       baki.fromPlayer = game.situation.turnPlayer;
  //       // change the color of the baki
  //       baki.bakiLayout.turnToPlayer(game.situation.turnPlayer);
  //     }

  //     neighborSituationField.bakis
  //         .add(bakisToExplode[surroudingFields.indexOf(neighborFieldId)]);

  //     // chain reaction check, neighbor field has one more baki added
  //     if (neighborSituationField.shouldExplodeOnPlaceBaki()) {
  //       hasChainReaction = true;
  //       // part of mechanism to detect when exploding ends and turn is over
  //       globalScope.read(explodingFieldsProvider.notifier).state = globalScope
  //           .read(explodingFieldsProvider.notifier)
  //           .state
  //         ..add(neighborFieldId);
  //       Future.delayed(
  //           Duration(milliseconds: 600),
  //           () => gameEventProcessor.explodeOnChainReaction(
  //               neighborSituationField.field,
  //               neighborSituationField.bakis
  //                   .map((b) => b.bakiLayout)
  //                   .toList()));
  //       // part of mechanism to detect when exploding ends and turn is over
  //       globalScope.read(explodingFieldsProvider.notifier).state = globalScope
  //           .read(explodingFieldsProvider.notifier)
  //           .state
  //         ..remove(neighborFieldId);
  //     }

  //     // update situationfield
  //     _replaceSituationField(situationFields, neighborSituationField);
  //   }

  //   // when explosion was over and there was no chainreaction, check if there are still any explosions left then end turn
  //   if (!hasChainReaction) {
  //     if (!globalScope.read(isExploding)) {
  //       gameEventProcessor.endTurn();
  //     }
  //   }

  //   // return updated situation
  //   return game.situation.instanceWith(fields: situationFields);
  // }

  static void _replaceSituationField(
      List<SituationField> situationFields, SituationField newSituationField) {
    // replace situationField
    final indexOfField = situationFields
        .indexWhere((f) => f.field.fieldId == newSituationField.field.fieldId);
    situationFields[indexOfField] = newSituationField;
  }
}
