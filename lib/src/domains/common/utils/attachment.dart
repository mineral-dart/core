import 'package:http/http.dart' as http;
import 'package:mineral/api.dart';

typedef AttachmentResult = (List<Map<String, dynamic>>, List<http.MultipartFile>);

AttachmentResult makeAttachmentFromBuilder(MessageBuilder builder) {
  final components = builder.build();
  final files = <http.MultipartFile>[];

  for (int i = 0; i < components.length; i++) {
    final comp = components[i];

    if (comp['type'] == ComponentType.file.value) {
      final file = _prepareFile(comp, files.length);

      files.add(file);
      comp['file']['url'] = 'attachment://${file.filename}';
      comp['file']['bytes'] = null;
      comp['id'] = files.length;

      continue;
    }

    if (comp['type'] == ComponentType.mediaGallery.value) {
      final items = comp['items'] as List<dynamic>?;
      if (items != null) {
        for (final item in items) {
          final file = _prepareAsset(item, files.length);

          if (file != null) {
            files.add(file);
          }
        }
      }
    }
  }

  return (components, files);
}

http.MultipartFile? _prepareAsset(dynamic payload, int filesLength) {
  final media = payload['media'] as Map<String, dynamic>?;
  final url = media?['url'] as String?;

  if (url != null && url.startsWith('attachment://') && payload['bytes'] != null) {
    final filename = url.replaceFirst('attachment://', '');

    final multipartFile = http.MultipartFile.fromBytes(
      'files[$filesLength]',
      payload['bytes'],
      filename: filename,
    );

    payload['url'] = 'attachment://$filename';
    payload['bytes'] = null;

    return multipartFile;
  }

  return null;
}

http.MultipartFile _prepareFile(dynamic payload, int filesLength) {
  final filePath = payload['file']['url'];
  final filename = filePath.split('/').last;

  final multipartFile = http.MultipartFile.fromBytes(
    'files[$filesLength]',
    payload['file']['bytes'],
    filename: filename,
  );

  return multipartFile;
}
