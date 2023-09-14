import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/services/http/contracts/http_request_dispatcher_contract.dart';
import 'package:mineral/services/http/http_response.dart';

final class HttpRequestDispatcher implements HttpRequestDispatcherContract {
  final Client _client;

  HttpRequestDispatcher(this._client);

  @override
  Future<EitherContract> process (BaseRequest request) async {
    final streamedResponse = await _client.send(request);
    final result = await Response.fromStream(streamedResponse);

    final response = HttpResponse.fromHttpResponse(result);
    return switch(result) {
      Response(statusCode: final code) when isInRange(100, 399, code) => Either.success<HttpResponse>(response),
      Response(statusCode: final code) when isInRange(400, 599, code) => Either.failure(response.reasonPhrase, payload: response),
      _ => Either.failure(response.reasonPhrase, payload: response),
    };
  }

  bool isInRange (int start, int end, int value) => value >= start && value <= end;
}