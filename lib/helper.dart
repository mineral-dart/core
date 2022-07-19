/// Helper class to simplify actions
library helper;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:mineral/api.dart';
import 'package:path/path.dart' as path;

import 'dart:math';

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

  static int toRgbColor (Color color) {
    return int.parse(color.toString().replaceAll('#', ''), radix: 16);
  }

  static int reduceRolePermissions (List<Permission> permissions) {
    int _permissions = 0;

    for (Permission permission in permissions) {
      _permissions += permission.value;
    }

    return _permissions;
  }

  static List<Permission> bitfieldToPermissions (int bitfield) {
    List<Permission> permissions = [];
    for (Permission element in Permission.values) {
      if((bitfield & element.value) == element.value) permissions.add(element);
    }
    return permissions;
  }

}
