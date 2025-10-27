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
    if (components[i]['type'] == ComponentType.file.value) {
      final filePath = components[i]['file']['url'];
      final filename = filePath.split('/').last;

      final multipartFile = http.MultipartFile.fromBytes(
        'files[$i]',
        components[i]['file']['bytes'],
        filename: filename,
      );

      files.add(multipartFile);
      components[i]['file']['url'] = 'attachment://$filename';
      components[i]['file']['bytes'] = null;
    }
  }

  return (components, files);
}
