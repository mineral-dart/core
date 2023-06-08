import 'package:mineral/framework.dart';

class OptionChoice {
  final String label;
  final String value;
  final Translate? labelTranslation;

  const OptionChoice({ required this.label, required this.value, this.labelTranslation });

  Map<String, dynamic> get serialize => {
    'name': label,
    'name_localizations': labelTranslation != null ? labelTranslation!.serialize : null,
    'value': value
  };
}
