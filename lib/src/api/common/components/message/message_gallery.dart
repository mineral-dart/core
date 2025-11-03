import 'dart:io';
import 'dart:typed_data';

import 'package:mineral/api.dart';

final class MessageGallery implements Component {
  ComponentType get type => ComponentType.mediaGallery;

  static final Map<String, Uint8List> _stagedFiles = {};

  static void set(String name, Uint8List bytes) {
    _stagedFiles[name] = bytes;
  }

  static Uint8List? delete(String name) {
    return _stagedFiles.remove(name);
  }

  final List<GalleryItem> _items;

  MessageGallery({required List<GalleryItem> items}) : _items = items;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'items': _items.map((e) => e.toJson()).toList(),
    };
  }
}

final class GalleryItem {
  final MessageMedia _media;
  final String? _description;
  final bool? _spoiler;

  GalleryItem(
    String url, {
    String? proxyUrl,
    int? height,
    int? width,
    String? contentType,
    String? description,
    bool? spoiler,
  })  : _media = MessageMedia(
          url,
          proxyUrl: proxyUrl,
          height: height,
          width: width,
          contentType: contentType,
        ),
        _description = description,
        _spoiler = spoiler;

  Map<String, dynamic> toJson() {
    return {
      'media': {
        'url': _media.url,
        if (_media.proxyUrl != null) 'proxy_url': _media.proxyUrl,
        if (_media.height != null) 'height': _media.height,
        if (_media.width != null) 'width': _media.width,
        if (_media.contentType != null) 'content_type': _media.contentType,
      },
      if (_description != null) 'description': _description,
      if (_spoiler != null) 'spoiler': _spoiler,
    };
  }


  /// ```dart
  ///   final file = File("assets/logo.png");
  //    final myImage = GalleryItem.fromFile(file, "test.png");
  /// ```
  ///
  /// Used to put a image file to discord's gallery instead of an url.
  factory GalleryItem.fromFile(File file, String name) {
      if (!file.existsSync()) {
        throw ArgumentError('File ${file.path} does not exist');
      }

      if (name.isEmpty) {
        throw ArgumentError("Name can't be empty.");
      }

      final bytes = file.readAsBytesSync();
      MessageGallery.set(name, bytes);

      final url = 'attachment://$name';
      return GalleryItem(url);
  }
}
