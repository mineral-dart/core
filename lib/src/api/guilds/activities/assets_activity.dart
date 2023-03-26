import 'package:mineral/core/api.dart';

class AssetsActivity {
  final ImageFormater? _smallImage;
  final String? _smallText;
  final ImageFormater? _largeImage;
  final String? _largeText;

  AssetsActivity(this._smallImage, this._smallText, this._largeImage, this._largeText);

  ImageFormater? get smallImage => _smallImage;
  String? get smallText => _smallText;
  ImageFormater? get largeImage => _largeImage;
  String? get largeText => _largeText;
}