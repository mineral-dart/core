library helper;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:mineral/api.dart';
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

  static toPascalCase (String value) {
    List<String> words = value.split('_');
    return words.map((word) => "${word[0].toUpperCase()}${word.substring(1)}").join('');
  }

  static toCapitalCase (String value) {
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static String toSnakeCase (String value) {
    return value.split(RegExp(r"(?=[A-Z])")).join('_').toLowerCase();
  }
}
