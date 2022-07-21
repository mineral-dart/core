import 'dart:core';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/interactions/interaction.dart';

class CommandInteraction extends Interaction {
  String identifier;
  TextBasedChannel? channel;
  Map<String, dynamic> data = {};

  CommandInteraction({
    required this.identifier,
    required InteractionType type,
    required Snowflake applicationId,
    required Snowflake id,
    required int version,
    required String token,
    required User user,
  }) : super(id: id, version: version, token: token, type: type, user: user, applicationId: applicationId);

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

  factory CommandInteraction.from({ required User user, required dynamic payload }) {
    return CommandInteraction(
      id: payload['id'],
      applicationId: payload['application_id'],
      type: InteractionType.applicationCommand,
      identifier: payload['data']['name'],
      version: payload['version'],
      token: payload['token'],
      user: user,
    );
  }
}
