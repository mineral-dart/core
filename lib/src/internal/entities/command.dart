import 'package:mineral/core/api.dart';
import 'package:mineral/src/helper.dart';

import '../../exceptions/missing_method_exception.dart';

class Scope {
  final String mode;

  static Scope get guild => Scope('GUILD');
  static Scope get global => Scope('GLOBAL');

  Scope(this.mode);
}

abstract class MineralCommand {
  late final CommandBuilder command;

  void register(CommandBuilder builder) {
    command = builder;
  }

  Future<void> handle (CommandInteraction interaction) async {
    throw MissingMethodException(cause: 'The handle method does not exist on your command ${command.label}');
  }
}

class AbstractCommand {
  final String _label;
  final String _description;
  final Scope? _scope;

  AbstractCommand(this._label, this._description, this._scope);

  String get label => _label;
  String get description => _description;
  Scope? get scope => _scope;

  Object get toJson => {};
}

enum CommandType {
  command(0),
  subcommand(1),
  group(2);

  final int type;
  const CommandType(this.type);
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

class CommandGroupBuilder extends AbstractCommand {
  final List<SubCommandBuilder> _subcommands = [];

  CommandGroupBuilder(String label, String description): super(label, description, null);

  List<SubCommandBuilder> get subcommands => _subcommands;

  void addSubcommand (SubCommandBuilder builder) {
    _subcommands.add(builder);
  }

  @override
  Object get toJson => {
    'name': _label.toLowerCase(),
    'description': _description,
    'type': CommandType.group.type,
    'options': _subcommands.map((option) => option.toJson).toList(),
  };
}

class SubCommandBuilder extends AbstractCommand {
  final Function _method;
  final List<Option> _options = [];
  final CommandType _type = CommandType.subcommand;

  SubCommandBuilder(String label, String description, this._method): super(label, description, null);

  Function get handle => _method;

  void addOption(Option option) {
    _options.add(option);
  }

  @override
  Object get toJson => {
    'name': _label.toLowerCase(),
    'description': _description,
    'type': _type.type,
    'options': _options.map((option) => option.toJson).toList(),
  };
}

class CommandBuilder extends AbstractCommand {
  int? _type = 1;
  final List<SubCommandBuilder> _subcommands = [];
  final List<CommandGroupBuilder> _group = [];
  final List<Option> _options = [];

  final List<Permission>? permissions;
  final bool everyone;

  CommandBuilder(String label, String description, { Scope? scope, this.permissions, this.everyone = false }): super(label, description, scope ?? Scope.guild);

  List<SubCommandBuilder> get subcommands => _subcommands;
  List<CommandGroupBuilder> get groups => _group;

  void addGroup (CommandGroupBuilder builder) {
    _type = null;
    _group.add(builder);
  }

  void addSubcommand (SubCommandBuilder command) {
    _type = null;
    _subcommands.add(command);
  }

  void addOption(Option option) {
    _options.add(option);
  }

  @override
  Object get toJson {
    final List<Permission> _permissions = permissions ?? [];
    return {
      'name': _label.toLowerCase(),
      'description': _description,
      'type': _type,
      'options': _subcommands.isNotEmpty || _group.isNotEmpty
        ? [
          ..._group.map((group) => group.toJson).toList(),
          ..._subcommands.map((command) => command.toJson).toList()
        ]
        : _options.isNotEmpty
          ? [..._options.map((option) => option.toJson)]
          : [],
      'default_member_permissions': !everyone
        ? _permissions.isNotEmpty
          ? Helper.toBitfield(_permissions.map((e) => e.value).toList()).toString()
          : null
        : 0,
    };
  }
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

  Option ({ required this.name, required this.description, required this.type, this.required, this.channels, this.min, this.max, this.choices });

  Object get toJson => {
    'name': name,
    'description': description,
    'type': type.value,
    'required': required ?? false,
    'channel_types': channels?.map((channel) => channel.value).toList(),
    'choices': choices?.map((choice) => choice.toJson()).toList(),
    'min_value': min,
    'max_value': max,
  };

  factory Option.string(String name, String description, { bool? required = false }) {
    return Option(name: name, description: description, type: OptionType.string, required: required);
  }

  factory Option.number(String name, String description, { bool? required = false }) {
    return Option(name: name, description: description, type: OptionType.number, required: required);
  }

  factory Option.user(String name, String description, { bool? required = false }) {
    return Option(name: name, description: description, type: OptionType.user, required: required);
  }

  factory Option.channel(String name, String description, { List<ChannelType>? channels, bool? required = false }) {
    return Option(name: name, description: description, type: OptionType.channel, channels: channels, required: required);
  }

  factory Option.bool(String name, String description, { bool? required = false }) {
    return Option(name: name, description: description, type: OptionType.boolean, required: required);
  }

  factory Option.mentionable(String name, String description, { bool? required = false }) {
    return Option(name: name, description: description, type: OptionType.mentionable, required: required);
  }

  factory Option.role(String name, String description, { bool? required = false }) {
    return Option(name: name, description: description, type: OptionType.role, required: required);
  }

  factory Option.choice(String name, String description, OptionType type, List<OptionChoice> choices, { bool? required = false }) {
    return Option(name: name, description: description, type: type, choices: choices, required: required);
  }
}

class OptionChoice {
  final String label;
  final String value;

  const OptionChoice({ required this.label, required this.value });

  Object toJson () => { 'name': label, 'value': value };
}
