import 'dart:io';

import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/commands/command_option_type.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';

abstract interface class CommandOption {
  String get name;

  String get description;

  CommandOptionType get type;

  bool get isRequired;

  List<ChannelType>? get channelTypes;

  Map<String, dynamic> toJson();
}

final class Option<T> implements CommandOption {
  @override
  final String name;

  @override
  final String description;

  @override
  final bool isRequired;

  @override
  final CommandOptionType type;

  @override
  final List<ChannelType>? channelTypes;

  const Option._(this.name, this.description, this.type, this.channelTypes,
      this.isRequired);

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.value,
      'required': isRequired,
      'channel_types': channelTypes?.map((e) => e.value).toList(),
    };
  }

  /// Create a new option with the given [name] and [description]. The option is a [String] type.
  ///
  /// If [required] is set to true, the option is required.
  factory Option.string(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.string, null, required);

  /// Create a new option with the given [name] and [description]. The option is a [int] type.
  ///
  /// If [required] is set to true, the option is required.
  factory Option.integer(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.integer, null, required);

  /// Create a new option with the given [name] and [description]. The option is a [double] type.
  ///
  /// If [required] is set to true, the option is required.
  factory Option.double(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.double, null, required);

  /// Create a new option with the given [name] and [description]. The option is a [bool] type.
  ///
  /// If [required] is set to true, the option is required.
  factory Option.boolean(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.boolean, null, required);

  /// Create a new option with the given [name] and [description]. The option is a [User] type.
  ///
  /// If [required] is set to true, the option is required.
  factory Option.user(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.user, null, required);

  /// Create a new option with the given [name] and [description]. The option is a [Channel] type
  ///
  /// If [required] is set to true, the option is required.
  factory Option.channel(
          {required String name,
          required String description,
          List<ChannelType> channels = const [],
          bool required = false}) =>
      Option._(
          name, description, CommandOptionType.channel, channels, required);

  /// Create a new option with the given [name] and [description]. The option is a [Role] type
  ///
  /// If [required] is set to true, the option is required.
  factory Option.role(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.role, null, required);

  /// Create a new option with the given [name] and [description]. The option is a [Channel], [User] or [Role] type
  ///
  /// If [required] is set to true, the option is required.
  factory Option.mentionable(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(
          name, description, CommandOptionType.mentionable, null, required);

  /// Create a new option with the given [name] and [description]. The option is a [File] type
  ///
  /// If [required] is set to true, the option is required.
  factory Option.attachment(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.attachment, null, required);
}
