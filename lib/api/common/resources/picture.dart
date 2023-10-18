import 'package:mineral/api/constant.dart';

final class Picture {
  final String? label;
  final String endpoint;

  Picture({ required this.label, this.endpoint = '' });

  String? get format => label!.startsWith('a_') ? 'gif' : 'png';
  String? get url => '${Constant.cdnUrl}/$endpoint$label.$format';
}