import 'package:mineral/api/server/auto_mod/auto_moderation_trigger.dart';
import 'package:mineral/api/server/auto_mod/enums/preset_type.dart';
import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';

final class KeywordPresetTrigger implements AutoModerationTrigger {
  @override
  final TriggerType type = TriggerType.keywordPreset;

  final List<PresetType> presets;
  final List<String> allowList;

  KeywordPresetTrigger({
    this.presets = const [],
    this.allowList = const [],
  });
}
