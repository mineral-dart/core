import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mineral/api.dart';

final class MessageFile implements Component {
  ComponentType get type => ComponentType.file;

  Uint8List? bytes;
  final String _path;
  final bool? _spoiler;

  MessageFile._(this._path, {bool? spoiler}) : _spoiler = spoiler;

  factory MessageFile.path(String path, {bool? spoiler}) {
    final file = File(path);
    final bytes = file.readAsBytesSync();

    return MessageFile._(path, spoiler: spoiler)..bytes = bytes;
  }

  static Future<MessageFile> network(String url, {bool? spoiler}) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    return MessageFile._(uri.path, spoiler: spoiler)..bytes = response.bodyBytes;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'file': {
        'url': _path,
        'bytes': bytes,
      },
      if (_spoiler != null) 'spoiler': _spoiler,
    };
  }
}
