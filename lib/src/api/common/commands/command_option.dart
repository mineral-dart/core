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

  factory Option.string(
          {required String name,
          required String description,
          bool isRequired = false}) =>
      Option._(name, description, CommandOptionType.string, null, isRequired);

  factory Option.integer(
          {required String name,
          required String description,
          bool isRequired = false}) =>
      Option._(name, description, CommandOptionType.integer, null, isRequired);

  factory Option.double(
          {required String name,
          required String description,
          bool isRequired = false}) =>
      Option._(name, description, CommandOptionType.double, null, isRequired);

  factory Option.boolean(
          {required String name,
          required String description,
          bool isRequired = false}) =>
      Option._(name, description, CommandOptionType.boolean, null, isRequired);

  factory Option.user(
          {required String name,
          required String description,
          bool isRequired = false}) =>
      Option._(name, description, CommandOptionType.user, null, isRequired);

  factory Option.channel(
          {required String name,
          required String description,
          List<ChannelType> channels = const [],
          bool isRequired = false}) =>
      Option._(
          name, description, CommandOptionType.channel, channels, isRequired);

  factory Option.role(
          {required String name,
          required String description,
          bool isRequired = false}) =>
      Option._(name, description, CommandOptionType.role, null, isRequired);

  factory Option.mentionable(
          {required String name,
          required String description,
          bool isRequired = false}) =>
      Option._(
          name, description, CommandOptionType.mentionable, null, isRequired);

  factory Option.attachment(
          {required String name,
          required String description,
          bool isRequired = false}) =>
      Option._(name, description, CommandOptionType.attachment, null, isRequired);
}
