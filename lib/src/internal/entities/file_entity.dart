import 'dart:io';
import 'dart:mirrors';

class Ignore {
  const Ignore();
}

class FileEntity {
  FileSystemEntity file;
  InstanceMirror instanceMirror;

  FileEntity({ required this.file, required this.instanceMirror });
}
