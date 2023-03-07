import 'package:mineral/core.dart';

abstract class UserFlagContract {
  final String _label;
  final int _value;
  final String _icon;

  const UserFlagContract(this._label, this._value, this._icon);

  String get label => _label;
  int get value => _value;
  String get icon => _icon;
  String get url => '${Constants.assets}/$_icon';
}