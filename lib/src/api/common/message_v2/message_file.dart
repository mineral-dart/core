import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mineral/api.dart';

final class Attachment implements MessageComponent {
  ComponentType get type => ComponentType.file;

  static final Map<String, Uint8List> _cachedAttachments = {};

  Uint8List? bytes;
  final String _path;
  final bool? _spoiler;

  Attachment(this._path, {bool? spoiler}) : _spoiler = spoiler;

  factory Attachment.path(String path, {bool? spoiler, bool cache = false}) {
    if (cache && _cachedAttachments.containsKey(path)) {
      return Attachment(path, spoiler: spoiler)
        ..bytes = _cachedAttachments[path]!;
    }

    final file = File(path);
    final bytes = file.readAsBytesSync();

    return Attachment(path, spoiler: spoiler)..bytes = bytes;
  }

  static Future<Attachment> network(String url,
      {bool? spoiler, bool cache = false}) async {
    if (cache && _cachedAttachments.containsKey(url)) {
      return Attachment(url, spoiler: spoiler)
        ..bytes = _cachedAttachments[url]!;
    }

    final uri = Uri.parse(url);
    final response = await http.get(uri);

    _cachedAttachments[url] = response.bodyBytes;

    return Attachment(uri.path, spoiler: spoiler)..bytes = response.bodyBytes;
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
