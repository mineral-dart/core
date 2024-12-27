import 'dart:io';
import 'dart:convert' as convert;

import 'package:mineral/src/api/common/types/enhanced_enum.dart';

enum ImageExtension implements EnhancedEnum<String> {
  png('.png'),
  jpeg('.jpeg'),
  webp('.webp'),
  gif('.gif'),
  lottie('.json');

  @override
  final String value;

  const ImageExtension(this.value);
}

final class Image {
  final String base64;

  Image._(this.base64);

  factory Image.file(File file) {
    if (!file.existsSync()) {
      throw ArgumentError('File does not exist');
    }

    final String extension = file.path.split('.').last;
    final bytes = file.readAsBytesSync();
    final encoded = convert.base64.encode(bytes);

    return Image._('data:image/$extension;base64,$encoded');
  }
}

final class ImageAsset {
  static String get _baseUrl => 'https://cdn.discordapp.com';

  final List<String> _fragments;
  final String hash;

  ImageAsset(this._fragments, this.hash);

  String get url => '$_baseUrl/${_fragments.join('/')}/$hash.png';

  String makeUrl({ImageExtension extension = ImageExtension.png, int? size}) {
    if (size case int() when size < 16 || size > 4096) {
      throw ArgumentError('Size must be between 16 and 4096');
    }

    final fragments = [..._fragments, hash, extension.value];
    if (size != null) {
      fragments.add('size=$size');
    }

    return '$url/${fragments.join('/')}';
  }

  factory ImageAsset.makeAsset(File file, {String? name}) {
    if (!file.existsSync()) {
      throw ArgumentError('File does not exist');
    }

    final hash = file.hashCode.toRadixString(16);
    final fragments = ['attachments', 'files', hash];

    return ImageAsset(fragments, hash);
  }
}
