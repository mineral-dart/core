import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

class AttachmentBuilder {
  List<int> content;
  String? filename;
  String? description;

  AttachmentBuilder(this.content, {
    this.filename,
    this.description
  });

  Object toJson ({int? id}) {
    return {
      'id': id,
      'filename': filename,
      'description': description
    };
  }

  MultipartFile toFile(int id) {
    return MultipartFile.fromBytes("files[$id]", content, filename: filename);
  }

  factory AttachmentBuilder.file(String path, {String? description, String? overrideFilename}) {
    File file = File(join(Directory.current.path, path));
    return AttachmentBuilder(file.readAsBytesSync(), filename: basename(file.path), description: description);
  }

  factory AttachmentBuilder.base64(String content, {required String filename, String? description}) {
    return AttachmentBuilder(base64Decode(content), filename: filename, description: description);
  }

}