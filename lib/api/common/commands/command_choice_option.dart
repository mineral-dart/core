import 'package:mineral/api/common/commands/command_option.dart';
import 'package:mineral/api/common/commands/command_option_type.dart';

final class ChoiceOption implements CommandOption {
  @override
  final String name;

  @override
  final String description;

  @override
  final CommandOptionType type;

  @override
  final bool isRequired;

  final List<Choice> choices;

  const ChoiceOption._(this.name, this.description, this.type, this.isRequired, this.choices);

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.value,
      'required': isRequired,
      'choices': choices.map((e) => {'name': e.name, 'value': e.value}).toList(),
    };
  }

  factory ChoiceOption.string(
          {required String name,
          required String description,
          required List<Choice<String>> choices,
          bool required = false}) =>
      ChoiceOption._(name, description, CommandOptionType.string, required, choices);

  factory ChoiceOption.integer(
          {required String name,
          required String description,
          required List<Choice<int>> choices,
          bool required = false}) =>
      ChoiceOption._(name, description, CommandOptionType.integer, required, choices);

  factory ChoiceOption.double(
          {required String name,
          required String description,
          required List<Choice<double>> choices,
          bool required = false}) =>
      ChoiceOption._(name, description, CommandOptionType.double, required, choices);
}

final class Choice<T> {
  final String name;
  final T value;

  const Choice(this.name, this.value);
}
