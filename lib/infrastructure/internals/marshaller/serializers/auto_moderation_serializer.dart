import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/auto_mod/auto_moderation.dart';
import 'package:mineral/api/server/auto_mod/enums/event_type.dart';
import 'package:mineral/infrastructure/commons/utils.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/auto_mod_triggers/keyword_preset_trigger_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/auto_mod_triggers/keyword_trigger_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/auto_mod_triggers/member_profile_trigger_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/auto_mod_triggers/member_spam_trigger_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/factories/auto_mod_triggers/message_spam_trigger_factory.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/trigger_factory.dart';

final class AutoModerationSerializer implements SerializerContract<AutoModeration> {
  final MarshallerContract _marshaller;
  final List<TriggerFactory> factories = [
    KeywordPresetTriggerFactory(),
    KeywordTriggerFactory(),
    MemberSpamTriggerFactory(),
    MemberProfileTriggerFactory(),
    MessageSpamTriggerFactory(),
  ];

  AutoModerationSerializer(this._marshaller);

  @override
  Future<AutoModeration> serialize(Map<String, dynamic> json) async {
    final server = await _marshaller.dataStore.server.getServer(Snowflake(json['guild_id']));
    final triggerFactory = factories.firstWhere((factory) => factory.type.value == json['trigger_type']);

    return AutoModeration(
      id: Snowflake(json['id']),
      name: json['name'],
      creatorId: Snowflake(json['creator_id']),
      serverId: Snowflake(json['server_id']),
      eventType: findInEnum(EventType.values, json['event_type']),
      trigger: await triggerFactory.serialize(json),
      isEnabled: json['enabled'],
      exemptRoles: json['exempt_roles'] != null
          ? List<Snowflake>.from(json['exempt_roles'].map(server.roles.getOrFail))
          : [],
      exemptChannels: json['exempt_channels'] != null
          ? List<Snowflake>.from(json['exempt_channels'].map(server.channels.getOrFail))
          : [],
    );
  }

  @override
  Map<String, dynamic> deserialize(AutoModeration moderation) {
    return {
      'name': moderation.name,
      'event_type': moderation.eventType.value,
      'trigger_type': moderation.trigger.type.value,
      'trigger_metadata': moderation.trigger.toJson(),
      'enabled': moderation.isEnabled,
      'actions': moderation.actions.map((action) => action.toJson()).toList(),
      'exempt_roles': moderation.exemptRoles.isNotEmpty
          ? moderation.exemptRoles.map((role) => role.value).toList()
          : null,
      'exempt_channels': moderation.exemptChannels.isNotEmpty
          ? moderation.exemptChannels.map((channel) => channel.value).toList()
          : null,
    };
  }
}
