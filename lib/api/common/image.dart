import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

final class Image {
  final String filename;
  final String? ext;
  final String encode;

  Image._({ required this.encode, required this.filename, this.ext });

  static Future<Image> network(Uri url) async {
    final filename = DateTime.now().millisecondsSinceEpoch.toString();
    final ext = url.path.contains('.') ? url.path.split('.').last : 'png';

    final String base64 = await get(url)
      .then((response) => response.bodyBytes)
      .then(base64Encode);

    return Image._(
      filename: filename,
      ext: ext,
      encode: 'data:image/$ext;base64,$base64'
    );
  }

  factory Image.file(File file) {
    final ext = file.path.split('.').last;
    final String base64 = base64Encode(file.readAsBytesSync());

    return Image._(
      filename: file.path.split('/').last,
      ext: ext,
      encode: 'data:image/$ext;base64,$base64',
    );
  }
}