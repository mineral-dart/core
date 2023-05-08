import 'package:mineral/core.dart';

abstract class UserFlagContract {
  final String _label;
  final int _value;
  final String _icon;

  const UserFlagContract(this._label, this._value, this._icon);

  /// The label of the flag as [String].
  String get label => _label;

  /// The value of the flag as [int].
  int get value => _value;

  /// The icon of the flag as [String].
  String get icon => _icon;

  /// The url of the flag as [String].
  String get url => '${Constants.assets}/$_icon';
}