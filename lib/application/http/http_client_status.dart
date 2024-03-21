abstract interface class HttpClientStatus {
  bool isError(int statusCode);
  bool isSuccess(int statusCode);
}

final class HttpClientStatusImpl implements HttpClientStatus {
  @override
  bool isError(int statusCode) {
    return [400, 401, 403, 404, 405, 500, 502].contains(statusCode);
  }

  @override
  bool isSuccess(int statusCode) {
    return [200, 201, 204, 202, 203, 205, 206].contains(statusCode);
  }
}
