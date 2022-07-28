import 'dart:core';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class CommandInteraction extends Interaction {
  String _identifier;
  TextBasedChannel? _channel;

  Map<String, dynamic> data = {};

  CommandInteraction(
    super._id,
    super._applicationId,
    super._version,
    super._type,
    super._token,
    super._user,
    super._guild,
    super._member,
    this._identifier,
    this._channel,
  );

  String get identifier => _identifier;
  TextBasedChannel? get channel => _channel;

  /// ### Returns an instance of [Channel] if the command has the designed option
  ///
  /// Example :
  /// ```dart
  /// Channel? channel = interaction.getChannel('option_name');
  /// ```
  T? getChannel<T extends Channel> (String optionName) {
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
    final MineralClient client = ioc.singleton(ioc.services.client);
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

  factory CommandInteraction.from({ required User user, required Guild? guild, required dynamic payload }) {
    return CommandInteraction(
      payload['id'],
      payload['application_id'],
      payload['version'],
      InteractionType.applicationCommand,
      payload['token'],
      user,
      guild,
      guild?.members.cache.get(user.id),
      payload['data']['name'],
      guild?.channels.cache.get(payload['channel_id']),
    );
  }
}
