import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

enum ModerationEventType {
  messageSend(1);

  final int value;
  const ModerationEventType(this.value);

  @override
  String toString () => value.toString();
}

enum ModerationTriggerType {
  keywords(1),
  harmfulLink(2),
  spam(3),
  keywordPreset(4);

  final int value;
  const ModerationTriggerType(this.value);

  @override
  String toString () => value.toString();
}

enum ModerationPresetType {
  profanity(1),
  sexualContent(2),
  slurs(3);

  final int value;
  const ModerationPresetType(this.value);

  @override
  String toString () => value.toString();
}

enum ModerationActionType {
  blockMessage(1),
  sendAlertMessage(2),
  timeout(3);

  final int value;
  const ModerationActionType(this.value);

  @override
  String toString () => value.toString();
}

class ModerationTriggerMetadata {
  List<String> keywordFilter;
  List<ModerationPresetType> presets;

  ModerationTriggerMetadata({ required this.keywordFilter, required this.presets });

  Object toJson () {
    return {
      'keyword_filter': keywordFilter,
      'presets': presets.map((preset) => preset.toString()).toList(),
    };
  }
}

class ModerationActionMetadata {
  Channel channel;
  int? duration;

  ModerationActionMetadata({ required this.channel, required this.duration });

  Object toJson () {
    return {
      'channel_id': channel.id,
      'duration_seconds': duration,
    };
  }
}

class ModerationAction {
  ModerationActionType type;
  ModerationActionMetadata metadata;

  ModerationAction({ required this.type, required this.metadata });

  Object toJson () {
    return {
      'type': type.value,
      'metadata': metadata.toJson(),
    };
  }
}

class ModerationRule {
  Snowflake id;
  Snowflake guildId;
  Guild guild;
  String label;
  ModerationEventType eventType;
  List<ModerationAction> actions;
  ModerationTriggerType triggerType;
  ModerationTriggerMetadata triggerMetadata;
  bool enabled;
  List<Role> exemptRoles;
  List<Channel> exemptChannels;

  ModerationRule({
    required this.id,
    required this.guildId,
    required this.guild,
    required this.label,
    required this.eventType,
    required this.actions,
    required this.triggerType,
    required this.triggerMetadata,
    required this.enabled,
    required this.exemptRoles,
    required this.exemptChannels,
  });

  factory ModerationRule.from ({ required Guild guild, required dynamic payload }) {
    List<ModerationAction> actions = [];

    if (payload['actions'] != null) {
      for (dynamic item in payload['actions']) {
        ModerationAction action = ModerationAction(
          type: ModerationActionType.values.firstWhere((element) => element.value == item['type']),
          metadata: ModerationActionMetadata(
            channel: guild.channels.cache.get(item['metadata']['channel_id'])!,
            duration: item['metadata']['duration_seconds']
          )
        );

        actions.add(action);
      }
    }

    return ModerationRule(
      id: payload['id'],
      guildId: payload['guild_id'],
      guild: guild,
      label: payload['name'],
      eventType: ModerationEventType.values.firstWhere((element) => element.value == payload['event_type']),
      actions: actions,
      triggerType: ModerationTriggerType.values.firstWhere((element) => element.value == payload['trigger_type']),
      triggerMetadata: ModerationTriggerMetadata(
        presets: payload['trigger_metadata'] != null
          ? ['presets'].map((preset) {
            return ModerationPresetType.values.firstWhere((element) => element.value == preset);
          }).toList()
          : [],
        keywordFilter: payload['trigger_metadata']['keyword_filter']
      ),
      enabled: payload['enabled'] ?? false,
      exemptRoles: payload['exempt_roles']?.map((Snowflake id) => guild.roles.cache.get(id)).toList(),
      exemptChannels: payload['exempt_channels']?.map((Snowflake id) => guild.channels.cache.get(id)).toList()
    );
  }

  Future<bool> delete () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.destroy(url: "/guilds/$guildId/auto-moderation/rules/$id");

    return response.statusCode == 200;
  }
}
