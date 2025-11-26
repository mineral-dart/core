import 'package:mineral/src/api/common/commands/builder/command_group_builder.dart';
import 'package:mineral/src/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/src/api/common/commands/builder/translation.dart';
import 'package:mineral/src/api/common/commands/command_context_type.dart';
import 'package:mineral/src/api/common/commands/command_helper.dart';
import 'package:mineral/src/api/common/commands/command_option.dart';
import 'package:mineral/src/api/common/commands/command_type.dart';
import 'package:mineral/src/api/common/commands/sub_command_declaration.dart';
import 'package:mineral/src/domains/commands/command_builder.dart';
import 'package:mineral/src/infrastructure/io/exceptions/missing_method_exception.dart';
import 'package:mineral/src/infrastructure/io/exceptions/missing_property_exception.dart';

final class CommandDeclarationBuilder implements CommandBuilder {
  final CommandHelper _helper = CommandHelper();

  String? name;
  Map<String, String>? _nameLocalizations;
  String? _description;
  Map<String, String>? _descriptionLocalizations;
  CommandContextType context = CommandContextType.server;
  final List<CommandOption> options = [];
  final List<SubCommandBuilder> subCommands = [];
  final List<CommandGroupBuilder> groups = [];
  Function? _handle;

  CommandDeclarationBuilder setName(String name, {Translation? translation}) {
    _helper.verifyName(name);

    this.name = name.toLowerCase();

    if (translation != null) {
      _nameLocalizations = _helper.extractTranslations('name', translation);

      for (final nameTranslation in _nameLocalizations!.values) {
        _helper.verifyName(nameTranslation);
      }
    }

    return this;
  }

  CommandDeclarationBuilder setContext(CommandContextType context) {
    this.context = context;
    return this;
  }

  CommandDeclarationBuilder setDescription(String description,
      {Translation? translation}) {
    _description = description;
    if (translation != null) {
      _descriptionLocalizations =
          _helper.extractTranslations('description', translation);
    }
    return this;
  }

  CommandDeclarationBuilder addOption<T extends CommandOption>(T option) {
    options.add(option);
    return this;
  }

  CommandDeclarationBuilder setHandle(Function fn) {
    _handle = fn;
    return this;
  }

  CommandDeclarationBuilder addSubCommand(Function(SubCommandBuilder) command) {
    final builder = SubCommandBuilder();
    command(builder);

    subCommands.add(builder);
    return this;
  }

  CommandDeclarationBuilder registerSubCommand(Function subCommandFactory) {
    final instance = subCommandFactory();
    
    if (instance is! SubCommandDeclaration) {
      throw Exception('Factory must return a SubCommandDeclaration instance');
    }
    
    final builder = instance.build();
    subCommands.add(builder);
    return this;
  }

  CommandDeclarationBuilder createGroup(Function(CommandGroupBuilder) group) {
    final builder = CommandGroupBuilder();
    group(builder);

    groups.add(builder);
    return this;
  }

  Map<String, dynamic> toJson() {
    if (name == null) {
      throw MissingPropertyException('Command name is required');
    }

    if (_description == null) {
      throw MissingPropertyException('Command description is required');
    }

    final List<Map<String, dynamic>> options = [
      for (final option in this.options) option.toJson(),
      for (final subCommand in subCommands) subCommand.toJson(),
      for (final group in groups) group.toJson(),
    ];

    return {
      'name': name,
      'name_localizations': _nameLocalizations,
      'description': _description,
      'description_localizations': _descriptionLocalizations,
      if (subCommands.isEmpty && groups.isEmpty)
        'type': CommandType.subCommand.value,
      'options': options,
    };
  }

  List<(String, Function handler)> reduceHandlers(String commandName) {
    if (subCommands.isEmpty && groups.isEmpty) {
      return [('$name', _handle!)];
    }

    final List<(String, Function handler)> handlers = [];

    for (final subCommand in subCommands) {
      if (subCommand.handle case null) {
        throw MissingMethodException(
            'Command "$commandName.${subCommand.name}" has no handler');
      }

      handlers.add(('$name.${subCommand.name}', subCommand.handle!));
    }

    for (final group in groups) {
      for (final subCommand in group.commands) {
        handlers.add(
            ('$name.${group.name}.${subCommand.name}', subCommand.handle!));
      }
    }

    return handlers;
  }
}
