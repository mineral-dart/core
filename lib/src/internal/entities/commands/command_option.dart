import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

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

class OptionChoice {
  final String label;
  final String value;

  const OptionChoice({ required this.label, required this.value });

  Object toJson () => { 'name': label, 'value': value };
}

class CommandOption {
  final String name;
  final String description;
  final Translate? labelTranslation;
  final Translate? descriptionTranslation;
  final OptionType type;
  final bool? required;
  final List<ChannelType>? channels;
  final int? min;
  final int? max;
  final List<OptionChoice>? choices;

  CommandOption ({
    required this.name,
    required this.description,
    required this.type,
    this.labelTranslation,
    this.descriptionTranslation,
    this.required,
    this.channels,
    this.min,
    this.max,
    this.choices
  });

  Map<String, dynamic> get serialize => {
    'name': name,
    'description': description,
    'name_localizations': labelTranslation?.serialize,
    'description_localizations': descriptionTranslation?.serialize,
    'type': type.value,
    'required': required ?? false,
    'channel_types': channels?.map((channel) => channel.value).toList(),
    'choices': choices?.map((choice) => choice.toJson()).toList(),
    'min_value': min,
    'max_value': max,
  };

  factory CommandOption.string(String name, String description, { Translate? labelTranslation, Translate? descriptionTranslation, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: OptionType.string,
      required: required
    );
  }

  factory CommandOption.number(String name, String description, { Translate? labelTranslation, Translate? descriptionTranslation, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: OptionType.number,
      required: required
    );
  }

  factory CommandOption.user(String name, String description, { Translate? labelTranslation, Translate? descriptionTranslation, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: OptionType.user,
      required: required
    );
  }

  factory CommandOption.channel(String name, String description, { Translate? labelTranslation, Translate? descriptionTranslation, List<ChannelType>? channels, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: OptionType.channel,
      channels: channels,
      required: required
    );
  }

  factory CommandOption.bool(String name, String description, { Translate? labelTranslation, Translate? descriptionTranslation, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: OptionType.boolean,
      required: required
    );
  }

  factory CommandOption.mentionable(String name, String description, { Translate? labelTranslation, Translate? descriptionTranslation, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: OptionType.mentionable,
      required: required
    );
  }

  factory CommandOption.role(String name, String description, { Translate? labelTranslation, Translate? descriptionTranslation, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: OptionType.role,
      required: required
    );
  }

  factory CommandOption.choice(String name, String description, OptionType type, List<OptionChoice> choices, { Translate? labelTranslation, Translate? descriptionTranslation, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: type,
      choices: choices,
      required: required
    );
  }

  factory CommandOption.attachement(String name, String description, { Translate? labelTranslation, Translate? descriptionTranslation, bool? required = false }) {
    return CommandOption(
      name: name,
      description: description,
      labelTranslation: labelTranslation,
      descriptionTranslation: descriptionTranslation,
      type: OptionType.attachment,
      required: required
    );
  }
}