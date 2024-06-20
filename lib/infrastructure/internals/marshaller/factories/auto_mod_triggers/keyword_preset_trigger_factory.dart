import 'dart:async';

import 'package:mineral/api/server/auto_mod/enums/preset_type.dart';
import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';
import 'package:mineral/api/server/auto_mod/triggers/keyword_preset_trigger.dart';
import 'package:mineral/infrastructure/commons/utils.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/trigger_factory.dart';

final class KeywordPresetTriggerFactory implements TriggerFactory<KeywordPresetTrigger> {
  @override
  TriggerType get type => TriggerType.keywordPreset;

  @override
  FutureOr<KeywordPresetTrigger> serialize(Map<String, dynamic> payload) {
    return KeywordPresetTrigger(
      allowList: List<String>.from(payload['allow_list']),
      presets: payload['presets'].map((preset) => findInEnum(PresetType.values, preset)),
    );
  }

  @override
  FutureOr<Map<String, dynamic>> deserialize(KeywordPresetTrigger trigger) {
    return {
      'type': trigger.type,
      'presets': trigger.presets.map((preset) => preset.value).toList(),
      'allowList': trigger.allowList,
    };
  }
}
