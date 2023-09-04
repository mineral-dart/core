import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

/// Attachment [File] builder
class AttachmentBuilder {
  /// Content property of this.
  List<int> content;

  /// Filename property of this.
  String? filename;

  /// Description property of this.
  String? description;

  AttachmentBuilder(this.content, {
    this.filename,
    this.description
  });

  /// Create a [MultipartFile] from the attachment
  MultipartFile toFile(int id) => MultipartFile.fromBytes("files[$id]", content, filename: filename);

  /// Serialize the attachment to JSON
  Object toJson ({int? id}) => {
    'id': id,
    'filename': filename,
    'description': description
  };


  /// Create an attachment from a path
  /// ```dart
  /// await interaction.reply(
  ///   content: 'Hello World!',
  ///   attachments: [AttachmentBuilder.file('assets/hello.png', description: 'Idk']
  /// );
  /// ```
  ///
  /// You can integrate image in embeds :
  /// ```dart
  /// await interaction.reply(
  ///   content: 'Hello World!',
  ///   attachments: [AttachmentBuilder.file('assets/hello.png', description: 'Idk'],
  ///   embeds: [EmbedBuilder(title: 'How are you?', thumbnail: Thumbnail(url: 'attachment://hello.png'))]
  /// );
  /// ```
  factory AttachmentBuilder.file(String path, {String? description, String? overrideFilename}) {
    File file = File(join(Directory.current.path, path));
    return AttachmentBuilder(file.readAsBytesSync(), filename: basename(file.path), description: description);
  }

  /// Create an attachment from a base64 string
  /// ```dart
  /// await interaction.reply(
  ///   content: 'Hello World!',
  ///   attachments: [AttachmentBuilder.base64('BASE 64 ENCODED STRING', filename: 'hello.png', description: 'Use a file? Nah!']
  /// );
  /// ```
  ///
  /// You can integrate image in embeds :
  /// ```dart
  /// await interaction.reply(
  ///   content: 'Hello World!',
  ///   attachments: [AttachmentBuilder.base64('BASE 64 ENCODED STRING', filename: 'hello.png', description: 'Use a file? Nah!'],
  ///   embeds: [EmbedBuilder(title: 'How are you?', thumbnail: Thumbnail(url: 'attachment://hello.png'))]
  /// );
  /// ```
  factory AttachmentBuilder.base64(String content, {required String filename, String? description}) {
    return AttachmentBuilder(base64Decode(content), filename: filename, description: description);
  }
}