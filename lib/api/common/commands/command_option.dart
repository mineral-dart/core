import 'package:mineral/api/common/commands/command_option_type.dart';

abstract interface class CommandOption {
  String get name;

  String get description;

  CommandOptionType get type;

  bool get isRequired;

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

  const Option._(this.name, this.description, this.type, this.isRequired);

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.value,
      'required': isRequired,
    };
  }

  factory Option.string(
          {required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.string, required);

  factory Option.integer(
          {required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.integer, required);

  factory Option.double(
          {required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.double, required);

  factory Option.boolean(
          {required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.boolean, required);

  factory Option.user({required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.user, required);

  factory Option.channel(
          {required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.channel, required);

  factory Option.role({required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.role, required);

  factory Option.mentionable(
          {required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.mentionable, required);

  factory Option.attachment(
          {required String name, required String description, bool required = false}) =>
      Option._(name, description, CommandOptionType.attachment, required);
}
