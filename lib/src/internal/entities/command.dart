import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/store_manager.dart';

class MineralCommand {
  late MineralClient client;
  late StoreManager stores;
  late Environment environment;
}

class Command {
  final String type = 'command';
  final String name;
  final String description;
  final String scope;
  final bool? everyone;
  final bool? dmChannel;

  const Command ({ required this.name, required this.description, required this.scope, this.everyone, this.dmChannel });
}

class CommandGroup {
  final String name;
  final String description;
  final int type = 2;

  const CommandGroup ({ required this.name, required this.description });
}

class Subcommand {
  final String name;
  final String description;
  final int type = 1;
  final String? group;

  const Subcommand ({ required this.name, required this.description, this.group });
}


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

class Option {
  final String name;
  final String description;
  final OptionType type;
  final bool? required;
  final List<ChannelType>? channels;
  final int? min;
  final int? max;
  final List<OptionChoice>? choices;

  const Option ({
    required this.name,
    required this.description,
    required this.type,
    this.required,
    this.channels,
    this.min,
    this.max,
    this.choices,
  });

  Object toJson () {
    return {
      'name': name,
      'description': description,
      'type': type.value,
      'required': required ?? false,
      'channel_types': channels?.map((channel) => channel.value).toList(),
      'choices': choices?.map((choice) => choice.toJson()).toList(),
      'min_value': min,
      'max_value': max,
    };
  }
}

class SlashCommand {
  String name;
  String description;
  String scope;
  bool everyone;
  bool dmChannel;
  int type = 1;
  List<Option> options = [];
  List<SlashCommand> groups = [];
  List<SlashCommand> subcommands = [];

  SlashCommand({ required this.name, required this.description, required this.scope, required this.everyone, required this.dmChannel, required this.options });

  Object toJson () {
    return {
      'name': name,
      'description': description,
      'type': type,
      'default_member_permissions': !everyone ? '0' : null,
      'dm_permission': dmChannel,
      'options': groups.isNotEmpty
          ? [...groups.map((group) => group.toJson()).toList(), ...subcommands.map((subcommand) => subcommand.toJson()).toList()]
          : subcommands.isNotEmpty
          ? subcommands.map((subcommand) => subcommand.toJson()).toList()
          : options.map((option) => option.toJson()).toList(),
    };
  }
}
