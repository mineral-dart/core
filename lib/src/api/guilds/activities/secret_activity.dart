import 'package:mineral/core/api.dart';

/// Represents a secret [Activity].
class SecretActivity {
  final String? _join;
  final String? _spectate;
  final String? _match;

  SecretActivity(this._join, this._spectate, this._match);

  /// The join secret of this.
  String? get join => _join;

  /// The spectate secret of this.
  String? get spectate => _spectate;

  /// The match secret of this.
  String? get match => _match;
}