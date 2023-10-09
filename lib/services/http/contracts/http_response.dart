abstract interface class HttpResponse {
  abstract final int statusCode;
  abstract final Map<String, String> headers;
}