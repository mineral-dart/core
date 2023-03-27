class ClientStatusBucket {
  final String? _desktop;
  final String? _web;
  final String? _mobile;

  ClientStatusBucket(this._desktop, this._web, this._mobile);

  String? get desktop => _desktop;
  String? get web => _web;
  String? get mobile => _mobile;
}