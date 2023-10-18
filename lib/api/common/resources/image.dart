import 'package:mineral/api/constant.dart';

final class Image {
  final String? label;
  final String endpoint;

  Image({ required this.label, this.endpoint = '' });

  String? get format => label!.startsWith('a_') ? 'gif' : 'png';
  String? get url => '${Constant.cdnUrl}/$endpoint$label.$format';
}