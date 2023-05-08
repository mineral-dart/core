import 'package:mineral/core/api.dart';

/// Represents an [Activity] assets.
class AssetsActivity {
  final ImageFormater? _smallImage;
  final String? _smallText;
  final ImageFormater? _largeImage;
  final String? _largeText;

  AssetsActivity(this._smallImage, this._smallText, this._largeImage, this._largeText);

  /// Returns the small image.
  ImageFormater? get smallImage => _smallImage;

  /// Returns the small text.
  String? get smallText => _smallText;

  /// Returns the large image.
  ImageFormater? get largeImage => _largeImage;

  /// Returns the large text.
  String? get largeText => _largeText;
}