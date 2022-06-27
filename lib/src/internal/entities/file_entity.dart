import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

class Ignore {
  const Ignore();
}

class FileEntity {
  FileSystemEntity file;
  InstanceMirror instanceMirror;

  FileEntity({ required this.file, required this.instanceMirror });

  @override
  String toString () {
    return jsonEncode({
      'file': file.toString(),
      'instanceMirror': instanceMirror.toString()
    });
  }
}
