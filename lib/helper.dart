library helper;

import 'dart:convert';
import 'dart:typed_data';

class Helper {
  static String toBase64 (Uint8List bytes) {
    return base64.encode(bytes);
  }

 static String toImageData (Uint8List bytes, { String ext = 'png' }) {
    String encoded = toBase64(bytes);
   return "data:image/png;base64,$encoded";
 }
}
