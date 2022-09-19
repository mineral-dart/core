import 'dart:core';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class CommandInteraction extends Interaction {
  String _identifier;
  Snowflake? _channelId;

  Map<String, dynamic> data = {};

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
  );

  String get identifier => _identifier;
  TextBasedChannel? get channel => guild?.channels.cache.get<TextBasedChannel>(_channelId);

  /// ### Returns an instance of [PartialTextChannel] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// Channel? channel = interaction.getChannel('option_name');
  /// ```
  T? getChannel<T extends PartialTextChannel> (String optionName) {
    return guild?.channels.cache.get(data[optionName]?['value']);
  }

  /// ### Returns an [int] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// int? value = interaction.getInteger('option_name');
  /// ```
  int? getInteger (String optionName) {
    return data[optionName]?['value'];
  }

  /// ### Returns an [String] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// String? str = interaction.getString('option_name');
  /// ```
  String? getString (String optionName) {
    return data[optionName]?['value'];
  }

  /// ### Returns an instance of [GuildMember] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// GuildMember? member = interaction.getMember('option_name');
  /// ```
  GuildMember? getMember (String optionName) {
    return guild?.members.cache.get(data[optionName]?['value']);
  }

  /// ### Returns an instance of [User] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// User? user = interaction.getUser('option_name');
  /// ```
  User? getUser (String optionName) {
    final MineralClient client = ioc.singleton(Service.client);
    return client.users.cache.get(data[optionName]?['value']);
  }

  /// ### Returns an [bool] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// book? boolean = interaction.getBoolean('option_name');
  /// ```
  bool? getBoolean (String optionName) {
    return data[optionName]?['value'];
  }

  /// ### Returns an instance of [Role] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// Role? role = interaction.getRole('option_name');
  /// ```
  Role? getRole (String optionName) {
    return guild?.roles.cache.get(data[optionName]?['value']);
  }

  /// ### Returns an [T] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// String? str = interaction.getChoice<String>('option_name');
  /// int? value = interaction.getChoice<int>('option_name');
  /// ```
  T? getChoice<T> (String optionName) {
    return data[optionName]?['value'];
  }

  /// ### Returns an value if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// dynamic mentionable = interaction.getMentionable('option_name');
  /// ```
  dynamic getMentionable (String optionName) {
    return data[optionName]?['value'];
  }

  factory CommandInteraction.from({ required dynamic payload }) {
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
    );
  }
}
