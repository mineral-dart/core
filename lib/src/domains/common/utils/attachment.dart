import 'package:http/http.dart' as http;
import 'package:mineral/api.dart';

typedef AttachmentResult = (
  List<Map<String, dynamic>>,
  List<http.MultipartFile>
);

AttachmentResult makeAttachmentFromBuilder(MessageBuilder builder) {
  final components = builder.build();
  final files = <http.MultipartFile>[];

  for (int i = 0; i < components.length; i++) {
    final comp = components[i];

    if (comp['type'] == ComponentType.file.value) {
      final filePath = comp['file']['url'];
      final filename = filePath.split('/').last;

      final multipartFile = http.MultipartFile.fromBytes(
        'files[${files.length}]',
        comp['file']['bytes'],
        filename: filename,
      );

      files.add(multipartFile);
      comp['file']['url'] = 'attachment://$filename';
      comp['file']['bytes'] = null;
      continue;
    }

    if (comp['type'] == ComponentType.mediaGallery.value) {
      final items = comp['items'] as List<dynamic>?;
      if (items != null) {
        for (final item in items) {
          final media = item['media'] as Map<String, dynamic>?;
          final url = media?['url'] as String?;
          if (url != null && url.startsWith('attachment://')) {
            final filename = url.replaceFirst('attachment://', '');
            final bytes = MessageGallery.delete(filename);
            if (bytes != null) {
              final multipartFile = http.MultipartFile.fromBytes(
                'files[${files.length}]',
                bytes,
                filename: filename,
              );
              files.add(multipartFile);
            }
          }
        }
      }
    }
  }

  return (components, files);
}
