import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/command_interaction.dart';
import 'package:mineral/src/exceptions/missing_method_exception.dart';
import 'package:mineral/src/internal/entities/commands/display.dart';

class AbstractCommand<T extends CommandInteraction> {
  final Display _label;
  final Display _description;

  late CommandScope _scope;

  AbstractCommand(this._label, this._description, CommandScope? scope) {
    _scope = scope ?? CommandScope.guild;
  }

  Display get label => _label;
  Display get description => _description;
  CommandScope? get scope => _scope;

  Future<void> handle(T interaction) async {
    throw MissingMethodException('The handle method does not exist on your command ${interaction.identifier}');
  }

  Map<String, dynamic> get serialize => {
    'name': _label.uid,
    'name_localizations': _label.serialize,
    'description': _label.uid,
    'description_localizations': _label.serialize,
  };
}