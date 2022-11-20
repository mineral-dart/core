import 'package:mineral/core.dart';

class ImageFormater {
  final String? _label;
  final String? _endpoint;

  ImageFormater(this._label, this._endpoint);

  String? get label => _label;
  String? get url => '${Constants.cdnUrl}/$_endpoint/$_label.png';
}
