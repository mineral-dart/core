import 'dart:core';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class CommandInteraction extends Interaction {
  String _identifier;
  Snowflake? _channelId;

  Map<String, dynamic> _data = {};
  Map<String, dynamic> _params = {};

  CommandInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._typeId,
    super._token,
    super._userId,
    super._guildId,
    this._identifier,
    this._channelId,
    this._data,
    this._params,
  );

  String get identifier => _identifier;
  TextBasedChannel? get channel => guild?.channels.cache.get<TextBasedChannel>(_channelId);
  Map<String, dynamic> get data => _data;
  Map<String, dynamic> get params => _params;

  /// ### Returns an instance of [PartialTextChannel] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// Channel? channel = interaction.getChannel('option_name');
  /// ```
  T? getChannel<T extends PartialTextChannel> (String optionName) {
    return guild?.channels.cache.get(params[optionName]);
  }

  /// ### Returns an instance of [PartialTextChannel] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// final Channel channel = interaction.getChannelOrFail('option_name');
  /// ```
  T getChannelOrFail<T extends PartialTextChannel> (String optionName) {
    return guild!.channels.cache.getOrFail(params[optionName]);
  }

  /// ### Returns an [int] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// int? value = interaction.getInteger('option_name');
  /// ```
  int? getInteger (String optionName) {
    return params[optionName];
  }

  /// ### Returns an [int] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// final int value = interaction.getIntegerOrFail('option_name');
  /// ```
  int getIntegerOrFail (String optionName) {
    return params[optionName];
  }

  /// ### Returns an [String] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// String? str = interaction.getString('option_name');
  /// ```
  String? getString (String optionName) {
    print(params);
    return params[optionName].toString();
  }

  /// ### Returns an [String] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// final String str = interaction.getStringOrFail('option_name');
  /// ```
  String getStringOrFail (String optionName) {
    return params[optionName].toString();
  }

  /// ### Returns an instance of [GuildMember] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// GuildMember? member = interaction.getMember('option_name');
  /// ```
  GuildMember? getMember (String optionName) {
    return guild?.members.cache.get(params[optionName]);
  }

  /// ### Returns an instance of [GuildMember] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// final GuildMember member = interaction.getMemberOrFail('option_name');
  /// ```
  GuildMember getMemberOrFail (String optionName) {
    return guild!.members.cache.getOrFail(params[optionName]);
  }

  /// ### Returns an instance of [User] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// User? user = interaction.getUser('option_name');
  /// ```
  User? getUser (String optionName) {
    final MineralClient client = ioc.singleton(Service.client);
    return client.users.cache.get(params[optionName]);
  }

  /// ### Returns an instance of [User] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// final User user = interaction.getUserOrFail('option_name');
  /// ```
  User getUserOrFail (String optionName) {
    final MineralClient client = ioc.singleton(Service.client);
    return client.users.cache.getOrFail(params[optionName]);
  }

  /// ### Returns an [bool] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// bool? boolean = interaction.getBoolean('option_name');
  /// ```
  bool? getBoolean (String optionName) {
    return params[optionName];
  }

  /// ### Returns an [bool] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// final bool boolean = interaction.getBooleanOrFail('option_name');
  /// ```
  bool getBooleanOrFail (String optionName) {
    return params[optionName];
  }

  /// ### Returns an instance of [Role] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// Role? role = interaction.getRole('option_name');
  /// ```
  Role? getRole (String optionName) {
    return guild?.roles.cache.get(params[optionName]);
  }

  /// ### Returns an instance of [Role] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// Role? role = interaction.getRole('option_name');
  /// ```
  Role getRoleOrFail (String optionName) {
    return guild!.roles.cache.getOrFail(params[optionName]);
  }

  /// ### Returns an [T] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// String? str = interaction.getChoice<String>('option_name');
  /// int? value = interaction.getChoice<int>('option_name');
  /// ```
  T? getChoice<T> (String optionName) {
    return params[optionName];
  }

  /// ### Returns an value if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// dynamic mentionable = interaction.getMentionable('option_name');
  /// ```
  dynamic getMentionable (String optionName) {
    return params[optionName];
  }

  factory CommandInteraction.fromPayload(dynamic payload) {
    final Map<String, dynamic> params = {};
    void walk (List<dynamic> options) {
      for (final option in options) {
        if (option['options'] != null) {
          walk(option['options']);
        } else {
          params.putIfAbsent(option['name'], () => option['value']);
        }
      }
    }

    if (payload['data']?['options'] != null) {
      walk(payload['data']['options']);
    }

    return CommandInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'],
      payload['guild_id'],
      payload['data']['name'],
      payload['channel_id'],
      payload['data'],
      params
    );
  }
}
