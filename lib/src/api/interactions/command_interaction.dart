import 'dart:core';

import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_ioc/ioc.dart';

class CommandInteraction extends Interaction  {
  String _identifier;
  Snowflake? _channelId;

  Map<String, dynamic> _data = {};
  Map<String, dynamic> _params = {};

  CommandInteraction(
    super._id,
    super._label,
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

  /// Get identifier of this
  String get identifier => _identifier;
  /// Get channel [PartialChannel] of this
  PartialChannel? get channel => guild != null
    ? guild!.channels.cache.get(_channelId)
    : ioc.use<MineralClient>().dmChannels.cache.get(_channelId);

  /// Get data of this
  Map<String, dynamic> get data => _data;
  /// Get params of this
  Map<String, dynamic> get params => _params;

  /// Returns an instance of [T] or null if the command has the designed option
  ///
  /// ```dart
  /// final int value = getValue<int>('key', defaultValue: 0);
  /// final double value = getValue<double>('key', defaultValue: 0.0);
  /// final String value = getValue<String?>('key', defaultValue: 'Hello World');
  /// ```
  T getValue<T>(String key, { T? defaultValue }) => params[key] ?? defaultValue;

  /// Returns an instance of [PartialTextChannel] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// Channel? channel = interaction.getChannel('option_name');
  /// ```
  T? getChannel<T extends PartialTextChannel> (String optionName) {
    return guild?.channels.cache.get(params[optionName]);
  }

  /// Returns an instance of [GuildMember] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// GuildMember? member = interaction.getMember('option_name');
  /// ```
  GuildMember? getMember (String optionName) {
    return guild?.members.cache.get(params[optionName]);
  }

  /// Returns an instance of [User] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// User? user = interaction.getUser('option_name');
  /// ```
  User? getUser (String optionName) {
    final MineralClient client = ioc.use<MineralClient>();
    return client.users.cache.get(params[optionName]);
  }

  /// Returns an instance of [Role] or null if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// Role? role = interaction.getRole('option_name');
  /// ```
  Role? getRole (String optionName) {
    return guild?.roles.cache.get(params[optionName]);
  }

  /// Returns an [T] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// String? str = interaction.getChoice<String>('option_name');
  /// int? value = interaction.getChoice<int>('option_name');
  /// ```
  T? getChoice<T> (String optionName) {
    return params[optionName];
  }

  /// Returns an value if the command has the designed option
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
      payload['data']['name'],
      payload['application_id'],
      payload['version'],
      payload['type'],
      payload['token'],
      payload['member']?['user']?['id'] ?? payload['user']?['id'],
      payload['guild_id'],
      payload['data']['name'],
      payload['channel_id'],
      payload['data'],
      params
    );
  }
}
