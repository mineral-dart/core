import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/entities/commands/display.dart';

class OptionChoice {
  final Display label;
  final String value;

  const OptionChoice({ required this.label, required this.value });

  Map<String, dynamic> get serialize => {
    'name': label.uid,
    'name_localizations': label.serialize,
    'value': value
  };
}
