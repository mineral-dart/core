import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/command_interaction.dart';
import 'package:mineral/src/exceptions/missing_method_exception.dart';

class AbstractCommand<T extends CommandInteraction> {
  final String _label;
  final String _description;

  final Translate? _labelTranslation;
  final Translate? _descriptionTranslation;
  late CommandScope _scope;

  AbstractCommand(this._label, this._description, this._labelTranslation, this._descriptionTranslation, CommandScope? scope) {
    _scope = scope ?? CommandScope.guild;
  }

  String get label => _label;
  String get description => _description;
  Translate? get labelTranslation => _labelTranslation;
  Translate? get descriptionTranslation => _descriptionTranslation;
  CommandScope? get scope => _scope;

  Future<void> handle(T interaction) async {
    throw MissingMethodException('The handle method does not exist on your command ${interaction.identifier}');
  }

  Map<String, dynamic> get serialize => {
    'name': _label.toLowerCase(),
    'description': _description,
    'name_localizations': _labelTranslation != null ? _labelTranslation!.serialize : null,
    'description_localizations': _descriptionTranslation != null ? _descriptionTranslation!.serialize : null,
  };
}