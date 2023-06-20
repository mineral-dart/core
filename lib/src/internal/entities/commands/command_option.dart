import 'package:mineral/core/api.dart';
import 'package:mineral/src/internal/entities/commands/display.dart';

import '../../../../framework.dart';

enum OptionType {
  string(3),
  integer(4),
  boolean(5),
  user(6),
  channel(7),
  role(8),
  mentionable(9),
  number(10),
  attachment(11);

  final int value;
  const OptionType(this.value);
}

class CommandOption {
  final Display label;
  final Display description;
  final OptionType type;
  final bool? required;
  final List<ChannelType>? channels;
  final int? min;
  final int? max;
  final List<OptionChoice>? choices;

  CommandOption ({
    required this.label,
    required this.description,
    required this.type,
    this.required,
    this.channels,
    this.min,
    this.max,
    this.choices
  });

  Map<String, dynamic> get serialize => {
    'name': label.uid,
    'description': description.uid,
    'name_localizations': label.serialize,
    'description_localizations': description.serialize,
    'type': type.value,
    'required': required ?? false,
    'channel_types': channels?.map((channel) => channel.value).toList(),
    'choices': choices?.map((choice) => choice.serialize).toList(),
    'min_value': min,
    'max_value': max,
  };

  factory CommandOption.string(Display label, Display description, { bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.string,
      required: required
    );
  }

  factory CommandOption.double(Display label, Display description, { bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.number,
      required: required
    );
  }

  factory CommandOption.integer(Display label, Display description, { bool? required = false }) {
    return CommandOption(
        label: label,
        description: description,
        type: OptionType.integer,
        required: required
    );
  }

  factory CommandOption.user(Display label, Display description, { bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.user,
      required: required
    );
  }

  factory CommandOption.channel(Display label, Display description, { List<ChannelType>? channels, bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.channel,
      channels: channels,
      required: required
    );
  }

  factory CommandOption.bool(Display label, Display description, { bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.boolean,
      required: required
    );
  }

  factory CommandOption.mentionable(Display label, Display description, { bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.mentionable,
      required: required
    );
  }

  factory CommandOption.role(Display label, Display description, { bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.role,
      required: required
    );
  }

  factory CommandOption.choice(Display label, Display description, List<OptionChoice> choices, { bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.string,
      choices: choices,
      required: required
    );
  }

  factory CommandOption.attachement(Display label, Display description, { bool? required = false }) {
    return CommandOption(
      label: label,
      description: description,
      type: OptionType.attachment,
      required: required
    );
  }
}