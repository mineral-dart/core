import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/exceptions/too_many.dart';

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

  Future<void> setLabel(String label) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: { 'label': label });

    if (response.statusCode == 200) {
      this.label = label;
    }
  }

  Future<void> setEventType(ModerationEventType event) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: { 'event_type': event.value });

    if (response.statusCode == 200) {
      eventType = event;
    }
  }

  Future<void> setTriggerMetadata(ModerationTriggerMetadata triggerMetadata) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: { 'trigger_metadata': triggerMetadata.toJson() });

    if (response.statusCode == 200) {
      this.triggerMetadata = triggerMetadata;
    }
  }

  Future<void> setActions(List<ModerationAction> actions) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: {
      'actions': actions.map((ModerationAction action) => action.toJson())
    });

    if (response.statusCode == 200) {
      this.actions = actions;
    }
  }

  Future<void> setEnabled(bool value) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: { 'value': value });

    if (response.statusCode == 200) {
      enabled = value;
    }
  }

  Future<void> setExemptRoles(List<Role> roles) async {
    int maxItems = 50;
    if (roles.length > maxItems) {
      TooMany(cause: "The list of roles cannot exceed $maxItems items (currently ${roles.length} given)");
    }

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: {
      'exempt_roles': roles.map((Role role) => role.id)
    });

    if (response.statusCode == 200) {
      exemptRoles = roles;
    }
  }

  Future<void> setExemptChannels(List<Channel> channels) async {
    int maxItems = 50;
    if (channels.length > maxItems) {
      TooMany(cause: "The list of channels cannot exceed $maxItems items (currently ${channels.length} given)");
    }

    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: {
      'exempt_roles': channels.map((Channel channel) => channel.id)
    });

    if (response.statusCode == 200) {
      exemptChannels = channels;
    }
  }

  Future<bool> delete() async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.destroy(url: "/guilds/$guildId/auto-moderation/rules/$id");

    return response.statusCode == 204;
  }

  factory ModerationRule.from ({ required Guild guild, required dynamic payload }) {
    List<ModerationAction> actions = [];

    print(jsonEncode(payload));

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
}
