import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/exceptions/too_many.dart';
import 'package:mineral_ioc/ioc.dart';

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
  keywordPreset(4),
  mentionSpam(5);

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
  List<String>? keywordFilter;
  List<ModerationPresetType>? presets;
  List<String>? allowList;
  int? mentionTotalLimit;

  ModerationTriggerMetadata(this.keywordFilter, this.presets, this.allowList, this.mentionTotalLimit);

  Object toJson () => {
    'keyword_filter': keywordFilter,
    'presets': presets?.map((preset) => preset.toString()).toList(),
    'allow_list': allowList,
    'mention_total_limit': mentionTotalLimit
  };

  factory ModerationTriggerMetadata.keywords ({ List<String>? keywordFilter, List<ModerationPresetType>? presets, List<String>? allowList }) {
    return ModerationTriggerMetadata(keywordFilter, presets, allowList, null);
  }

  factory ModerationTriggerMetadata.mentions ({ required int maxMentions }) {
    if (maxMentions <= 0 || maxMentions > 50) {
      throw InvalidParameterException(cause: 'The number of mentions must be between 1 and 50 per message ($maxMentions given).');
    }

    return ModerationTriggerMetadata(null, null, null, maxMentions);
  }
}

class ModerationActionMetadata {
  final Snowflake? channelId;
  final int? duration;

  ModerationActionMetadata(this.channelId, this.duration);

  Object toJson () {
    return {
      'channel_id': channelId,
      'duration_seconds': duration,
    };
  }
}

class ModerationAction {
  ModerationActionType type;
  ModerationActionMetadata? metadata;

  ModerationAction(this.type, this.metadata);

  Object toJson () {
    return {
      'type': type.value,
      'metadata': metadata?.toJson(),
    };
  }

  factory ModerationAction.blockMessage () {
    return ModerationAction(ModerationActionType.blockMessage, null);
  }

  factory ModerationAction.sendAlert (Snowflake channelId) {
    return ModerationAction(
      ModerationActionType.sendAlertMessage,
      ModerationActionMetadata(channelId, null)
    );
  }

  factory ModerationAction.timeout (Duration duration) {
    return ModerationAction(
      ModerationActionType.timeout,
      ModerationActionMetadata(null, duration.inMilliseconds)
    );
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
  List<GuildChannel> exemptChannels;

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

  /// ### Update the label of this
  ///
  /// Example :
  /// ```dart
  /// await rule.setLabel('My label');
  /// ```
  Future<void> setLabel(String label) async {
    Response response = await ioc.use<Http>().patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: { 'label': label });

    if (response.statusCode == 200) {
      this.label = label;
    }
  }

  /// ### Update the event of this
  ///
  /// Example :
  /// ```dart
  /// await rule.setEventType(ModerationEventType.messageSend);
  /// ```
  Future<void> setEventType(ModerationEventType event) async {
    Response response = await ioc.use<Http>().patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: { 'event_type': event.value });

    if (response.statusCode == 200) {
      eventType = event;
    }
  }

  /// ### Update the trigger metadata of this
  ///
  /// Example :
  /// ```dart
  /// final metadata = ModerationTriggerMetadata(
  ///   keywordFilter: ['foo'],
  ///   presets: [ModerationPresetType.profanity]
  /// );
  ///
  /// await rule.setTriggerMetadata(metadata);
  /// ```
  Future<void> setTriggerMetadata(ModerationTriggerMetadata triggerMetadata) async {
    Response response = await ioc.use<Http>().patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: { 'trigger_metadata': triggerMetadata.toJson() });

    if (response.statusCode == 200) {
      this.triggerMetadata = triggerMetadata;
    }
  }

  /// ### Update actions of this
  ///
  /// Example :
  /// ```dart
  /// final channel = guild.channels.cache.get('240561194958716924');
  ///
  /// final action = ModerationAction(
  ///   metadata: ModerationActionMetadata(duration: 3000, channel: channel),
  ///   type: ModerationActionType.sendAlertMessage
  /// );
  ///
  /// await rule.setActions([action]);
  /// ```
  Future<void> setActions(List<ModerationAction> actions) async {
    Response response = await ioc.use<Http>().patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: {
      'actions': actions.map((ModerationAction action) => action.toJson())
    });

    if (response.statusCode == 200) {
      this.actions = actions;
    }
  }

  /// ### Update enabled of this
  ///
  /// Example :
  /// ```dart
  /// await rule.setEnabled(true);
  /// ```
  Future<void> setEnabled(bool value) async {
    Response response = await ioc.use<Http>().patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: { 'value': value });

    if (response.statusCode == 200) {
      enabled = value;
    }
  }

  /// ### Defines which roles will not be affected by this
  ///
  /// Example :
  /// ```dart
  /// final role = guild.roles.cache.get('240561194958716924');
  ///
  /// if (role != null) {
  ///   await rule.setExemptRoles([role]);
  /// }
  /// ```
  Future<void> setExemptRoles(List<Role> roles) async {
    int maxItems = 50;
    if (roles.length > maxItems) {
      TooMany(cause: "The list of roles cannot exceed $maxItems items (currently ${roles.length} given)");
    }

    Response response = await ioc.use<Http>().patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: {
      'exempt_roles': roles.map((Role role) => role.id)
    });

    if (response.statusCode == 200) {
      exemptRoles = roles;
    }
  }

  /// ### Defines which roles will not be affected by this
  ///
  /// Example :
  /// ```dart
  /// final channel = guild.channels.cache.get('240561194958716924');
  ///
  /// if (channel != null) {
  ///   await rule.setExemptChannels([channel]);
  /// }
  /// ```
  Future<void> setExemptChannels(List<GuildChannel> channels) async {
    int maxItems = 50;
    if (channels.length > maxItems) {
      TooMany(cause: "The list of channels cannot exceed $maxItems items (currently ${channels.length} given)");
    }

    Response response = await ioc.use<Http>().patch(url: "/guilds/$guildId/auto-moderation/rules/$id", payload: {
      'exempt_roles': channels.map((GuildChannel channel) => channel.id)
    });

    if (response.statusCode == 200) {
      exemptChannels = channels;
    }
  }
  /// ### Delete this
  ///
  /// Example :
  /// ```dart
  ///   await rule.delete();
  /// ```
  Future<bool> delete() async {
    Response response = await ioc.use<Http>().destroy(url: "/guilds/$guildId/auto-moderation/rules/$id");

    return response.statusCode == 204;
  }

  factory ModerationRule.fromPayload (dynamic payload) {
    Guild guild = ioc.use<MineralClient>().guilds.cache.getOrFail(payload['guild_id']);

    List<ModerationAction> actions = [];
    if (payload['actions'] != null) {
      for (dynamic item in payload['actions']) {
        ModerationAction action = ModerationAction(
          ModerationActionType.values.firstWhere((element) => element.value == item['type']),
          item['metadata'].toString() != '{}'
            ? ModerationActionMetadata(
              item['metadata']['channel_id'],
              item['metadata']['duration_seconds']
            )
            : null
        );

        actions.add(action);
      }
    }

    List<String> keywordFilter = [];
    if (payload['trigger_metadata']?['keyword_filter'] != null) {
      for (dynamic keyword in payload['trigger_metadata']['keyword_filter']) {
        keywordFilter.add(keyword);
      }
    }

    List<Role> roles = [];
    if (payload['exempt_roles'] != null) {
      for (Snowflake id in payload['exempt_roles']) {
        Role? role = guild.roles.cache.get(id);
        if (role != null) {
          roles.add(role);
        }
      }
    }

    List<GuildChannel> channels = [];
    if (payload['exempt_channels'] != null) {
      for (Snowflake id in payload['exempt_channels']) {
        GuildChannel? channel = guild.channels.cache.get(id);
        if (channel != null) {
          channels.add(channel);
        }
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
        keywordFilter,
        payload['trigger_metadata'] != null && payload['trigger_metadata']['presets'] != null
          ? (payload['trigger_metadata']['presets'] as List<dynamic>).map((preset) {
              return ModerationPresetType.values.firstWhere((element) => element.value == preset);
            }).toList()
          : [],
        payload['allow_list'],
        payload['mention_total_limit']
      ),
      enabled: payload['enabled'] ?? false,
      exemptRoles: roles,
      exemptChannels: channels,
    );
  }
}
