library helper;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

class Helper {
  static String toBase64(Uint8List bytes) {
    return base64.encode(bytes);
  }

  static String toImageData(Uint8List bytes, {String ext = 'png'}) {
    String encoded = toBase64(bytes);
    return "data:image/png;base64,$encoded";
  }

  static Future<String> getPicture(String filename) async {
    String fileLocation = path.join(Directory.current.path, filename);
    File file = File(fileLocation);

    Uint8List imageBytes = await file.readAsBytes();
    return Helper.toImageData(imageBytes);
  }
}
