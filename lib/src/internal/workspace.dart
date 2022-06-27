import 'dart:io';
import 'dart:mirrors';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/exceptions/invalid_class_entity.dart';
import 'package:mineral/src/internal/entities/command_manager.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/entities/file_entity.dart';
import 'package:mineral/src/internal/entities/store_manager.dart';
import 'package:mineral/src/internal/models/pubspec.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

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

  Future<void> mock (file, eventManager, commandManager, storeManager) async {
    LibraryMirror libraryMirror = await currentMirrorSystem().isolate.loadUri(file.uri);
    InstanceMirror? instanceMirror = _getClassMirror(file, libraryMirror);

    if (instanceMirror != null && instanceMirror.type.metadata.first.reflectee is Event) {
      eventManager.add(FileEntity(file: file, instanceMirror: instanceMirror));
    }

    if (instanceMirror != null && instanceMirror.type.metadata.first.reflectee is Command) {
      commandManager.add(FileEntity(file: file, instanceMirror: instanceMirror));
    }

    if (instanceMirror != null && instanceMirror.type.metadata.first.reflectee is Store) {
      storeManager.add(FileEntity(file: file, instanceMirror: instanceMirror));
    }
  }

  Future<List<FileEntity?>> getEntities<T> () async {
    print('entities');
    return Future.wait(files.map((file) async {
      LibraryMirror libraryMirror = await currentMirrorSystem().isolate.loadUri(file.uri);
      InstanceMirror? instanceMirror = _getClassMirror(file, libraryMirror);

      if (instanceMirror != null && instanceMirror.type.metadata.first.reflectee is T) {
        return FileEntity(file: file, instanceMirror: instanceMirror);
      }
      return null;
    }));
  }

  InstanceMirror? _getClassMirror (FileSystemEntity file, LibraryMirror libraryMirror) {
    String classEntry = Helper.toPascalCase(file.uri.pathSegments.last.split('.').first);
    bool containClass = libraryMirror.declarations.keys.contains(Symbol(classEntry));

    if (!containClass) {
      throw InvalidClassEntity(
        prefix: 'INVALID EVENT',
        cause: "The MineralEvent entity does not have a class named ${ColorList.white(classEntry)} in file:\\\\${file.path}"
      );
    }

    ClassMirror classMirror = libraryMirror.declarations[Symbol(classEntry)] as ClassMirror;

    return classMirror.metadata.first.reflectee is Ignore ? null : classMirror.newInstance(Symbol(''), []);
  }

  Future<Pubspec> loadPubspec () async {
    File file = File(join(root.path, 'pubspec.yaml'));
    return Pubspec.from(payload: loadYaml(await file.readAsString()));
  }
}

// Extend Map pour ajouter les methodes de la collection
