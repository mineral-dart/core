import 'package:http/http.dart';
import 'package:mineral/services/http/contracts/http_request_dispatcher_contract.dart';
import 'package:mineral/services/http/contracts/http_response.dart';
import 'package:mineral/services/http/entities/http_error.dart';
import 'package:mineral/services/http/entities/http_payload.dart';

final class HttpRequestDispatcher implements HttpRequestDispatcherContract {
  final Client _client;

  HttpRequestDispatcher(this._client);

  @override
  Future<HttpResponse> process (BaseRequest request) async {
    final streamedResponse = await _client.send(request);
    try {
      final result = await Response.fromStream(streamedResponse);

      return switch(result) {
        Response(statusCode: final code) when isInRange(100, 399, code) => HttpPayload.fromHttpResponse(result),
        Response(statusCode: final code) when isInRange(400, 599, code) => HttpError.fromHttpResponse(result),
        _ => HttpError.fromHttpResponse(result),
      };
    } catch (err) {
      rethrow;
    }
  }

  bool isInRange (int start, int end, int value) => value >= start && value <= end;
}