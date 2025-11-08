import 'package:http/http.dart' as http;
import 'package:mineral/api.dart';

final class AttachedFile implements MessageComponent {
  ComponentType get type => ComponentType.file;

  MediaItem item;

  AttachedFile(this.item);

  static Future<AttachedFile> network(String url, {bool? spoiler}) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final name = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'file.txt';
    final media = MediaItem('attachment://$name')
    ..bytes = response.bodyBytes
    ..spoiler = spoiler;

    return AttachedFile(media);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.value, ...item.toJson()};
  }
}
