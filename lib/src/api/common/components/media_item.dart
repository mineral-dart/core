import 'dart:io';
import 'dart:typed_data';

final class MediaItem {
  Uint8List? bytes;
  final String url;
  bool? spoiler;
  final String? proxyUrl;
  final int? height;
  final int? width;
  final String? contentType;
  final String? description;

  MediaItem(this.url, {this.spoiler, this.proxyUrl, this.height, this.width, this.contentType, this.description});

  factory MediaItem.file(File file, String name, {bool? spoiler, String? proxyUrl, int? height, int? width, String? contentType, String? description}) {
    if (!file.existsSync()) {
      throw ArgumentError('File ${file.path} does not exist');
    }

    if (name.isEmpty) {
      throw ArgumentError("Name can't be empty.");
    }

    final bytes = file.readAsBytesSync();

    return MediaItem(
      'attachment://$name',
      spoiler: spoiler,
      proxyUrl: proxyUrl,
      height: height,
      width: width,
      contentType: contentType,
      description: description,
    )..bytes = bytes;
  }

  Map<String, dynamic> toJson() {
    return {
      if (description != null) 'description': description,
      'url': url,
      if (bytes != null) 'bytes': bytes!,
      if (spoiler != null) 'spoiler': spoiler,
      'media': {
        'url': url,
        if (proxyUrl != null) 'proxy_url': proxyUrl,
        if (height != null) 'height': height,
        if (width != null) 'width': width,
        if (contentType != null) 'content_type': contentType,
      },
    };
  }
}
