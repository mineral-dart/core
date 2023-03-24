import 'package:mineral/src/api/builders/modal/text_input_style.dart';

class InputBuilder {
  final String _customId;
  TextInputStyle _style;
  String _label = '';
  bool _required = false;
  int? _minLength;
  int? _maxLength;
  String? _placeholder;
  String? value;

  InputBuilder(this._customId, this._style);

  String get customId => _customId;
  TextInputStyle get style => _style;
  String get label => _label;
  bool get required => _required;
  int? get minLength => _minLength;
  int? get maxLength => _maxLength;
  String? get placeholder => _placeholder;

  void setLabel(String value) => _label = value;
  void setRequired(bool value) => _required = value;
  void setMinLength(int value) => _minLength = value;
  void setMaxLength(int value) => _maxLength = value;
  void setPlaceholder(String value) => _placeholder = value;
}