import 'package:mineral/api/common/types/enhanced_enum.dart';

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

final class ImageAsset {
  String get _baseUrl => 'https://cdn.discordapp.com';

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
}
