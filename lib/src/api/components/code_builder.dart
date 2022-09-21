import 'dart:convert';

class CodeBuilder {
  final String _language;
  final dynamic _code;
  int? indent;


  CodeBuilder(this._language, this._code, { this.indent });

  @override
  String toString () {
    final encoder = JsonEncoder.withIndent(List.filled(indent ?? 2, ' ').join());
    return '```$_language\n' + encoder.convert(_code) + '```';
  }
}
