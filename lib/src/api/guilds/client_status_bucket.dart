/// Represents the client status bucket of a [User]
class ClientStatusBucket {
  final String? _desktop;
  final String? _web;
  final String? _mobile;

  ClientStatusBucket(this._desktop, this._web, this._mobile);

  /// Returns the desktop status of the [User]
  String? get desktop => _desktop;

  /// Returns the web status of the [User]
  String? get web => _web;

  /// Returns the mobile status of the [User]
  String? get mobile => _mobile;
}