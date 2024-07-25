import 'package:mineral/api/common/commands/builder/translation.dart';
import 'package:mineral/api/common/commands/command_helper.dart';
import 'package:mineral/api/common/commands/command_option.dart';
import 'package:mineral/api/common/commands/command_type.dart';

final class SubCommandBuilder {
  final CommandHelper _helper = CommandHelper();

  String? name;
  Map<String, String>? _nameLocalizations;
  String? _description;
  Map<String, String>? _descriptionLocalizations;
  final List<CommandOption> options = [];
  Function? handle;

  SubCommandBuilder();

  SubCommandBuilder setName(String name, {Translation? translation}) {
    this.name = name;
    if (translation != null) {
      _nameLocalizations = _helper.extractTranslations('name', translation);
    }

    return this;
  }

  SubCommandBuilder setDescription(String description, {Translation? translation}) {
    _description = description;
    if (translation != null) {
      _descriptionLocalizations = _helper.extractTranslations('description', translation);
    }
    return this;
  }

  SubCommandBuilder addOption<T extends CommandOption>(T option) {
    options.add(option);
    return this;
  }

  SubCommandBuilder setHandle(Function fn) {
    handle = fn;
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'name_localizations': _nameLocalizations,
      'description': _description,
      'description_localizations': _descriptionLocalizations,
      'type': CommandType.subCommand.value,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}
