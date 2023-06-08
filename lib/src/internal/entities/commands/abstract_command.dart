import 'package:mineral/src/api/interactions/command_interaction.dart';
import 'package:mineral/src/exceptions/missing_method_exception.dart';
import 'package:mineral/src/internal/entities/commands/command_scope.dart';

class AbstractCommand<T extends CommandInteraction> {
  final String _label;
  final String _description;
  late CommandScope _scope;

  AbstractCommand(this._label, this._description, CommandScope? scope) {
    _scope = scope ?? CommandScope.guild;
  }

  String get label => _label;
  String get description => _description;
  CommandScope? get scope => _scope;

  Future<void> handle(T interaction) async {
    throw MissingMethodException('The handle method does not exist on your command ${interaction.identifier}');
  }

  Map<String, dynamic> get serialize => {
    'name': _label.toLowerCase(),
    'description': _description,
  };
}