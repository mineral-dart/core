import 'package:http/http.dart';
import 'package:mineral/services/http/contracts/http_response.dart';

class HttpError implements HttpResponse {
  final int statusCode;
  final Map<String, String> headers;
  final String? reasonPhrase;
  final String? message;
  final HttpResponse? payload;

  HttpError._({ required this.statusCode, required this.headers, this.reasonPhrase, this.message, this.payload });

  factory HttpError.fromHttpResponse(Response response) {
    return HttpError._(
      statusCode: response.statusCode,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
      message: response.body,
    );
  }
}