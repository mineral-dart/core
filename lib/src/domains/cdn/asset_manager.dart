import 'dart:io';

import 'package:mineral/services.dart';
import 'package:mineral/src/domains/cdn/asset_type.dart';

abstract interface class AssetManagerContract {
  HttpClientContract get httpClient;

  Future<File> load(AssetType path);
  Future<void> push(String name, File file);

}

final class AssetManager implements AssetManagerContract {
  final HttpClientContract httpClient;

  AssetManager(this.httpClient);

  @override
  Future<File> load(AssetType path) async {
    throw UnimplementedError();
  }

  @override
  Future<void> push(String name, File file) async {
    throw UnimplementedError();
  }
}
