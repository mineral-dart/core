import 'dart:io';
import 'dart:mirrors';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/exceptions/invalid_class_entity.dart';
import 'package:mineral/src/internal/entities/file_entity.dart';
import 'package:path/path.dart';

class Workspace {
  Directory root;
  List<FileSystemEntity> files = [];
  Workspace({ required this.root });

  Future<void> loadFromDisk () async {
    Stream<FileSystemEntity> files = Directory(join(root.path, 'src')).list(recursive: true, followLinks: false);
    this.files = await files.where(_filter).toList();
  }

  bool _filter (FileSystemEntity file) {
    return file.path.endsWith('.dart')
      && !file.path.endsWith(join(root.path, 'src', 'main.dart'));
  }

  Future<List<FileEntity>> getEntities<T> () async {
    List<FileEntity> fileEntities = [];

    for (FileSystemEntity file in files) {
      LibraryMirror libraryMirror = await currentMirrorSystem().isolate.loadUri(file.uri);
      InstanceMirror? instanceMirror = _getClassMirror(file, libraryMirror);

      if (instanceMirror != null && instanceMirror.type.metadata.first.reflectee is T) {
        fileEntities.add(FileEntity(file: file, instanceMirror: instanceMirror));
      }
    }

    return fileEntities;
  }

  InstanceMirror? _getClassMirror (FileSystemEntity file, LibraryMirror libraryMirror) {
    String classEntry = Helper.toPascalCase(file.uri.pathSegments.last.split('.').first);
    bool containClass = libraryMirror.declarations.keys.contains(Symbol(classEntry));

    if (!containClass) {
      throw InvalidClassEntity(
        prefix: 'Invalid event',
        cause: "The MineralEvent entity does not have a class named ${ColorList.white(classEntry)} in file:\\\\${file.path}"
      );
    }

    ClassMirror classMirror = libraryMirror.declarations[Symbol(classEntry)] as ClassMirror;

    return classMirror.metadata.first.reflectee is Ignore ? null : classMirror.newInstance(Symbol(''), []);
  }
}

// Extend Map pour ajouter les methodes de la collection
