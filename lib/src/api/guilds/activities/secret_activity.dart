class SecretActivity {
  final String? _join;
  final String? _spectate;
  final String? _match;

  SecretActivity(this._join, this._spectate, this._match);

  String? get join => _join;
  String? get spectate => _spectate;
  String? get match => _match;
}