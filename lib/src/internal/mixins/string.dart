import 'package:recase/recase.dart';

extension StringFormat on String {
  String get camelCase => ReCase(this).camelCase;
  String get constantCase => ReCase(this).constantCase;
  String get sentenceCase => ReCase(this).sentenceCase;
  String get snakeCase => ReCase(this).snakeCase;
  String get pascalCase => ReCase(this).pascalCase;

  bool equals (dynamic value) => this == value;

}
