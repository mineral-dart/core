import 'package:mineral/infrastructure/services/http/type/response_code.dart';

abstract interface class HttpClientStatus {
  bool isError(int statusCode);
  bool isSuccess(int statusCode);
}

final class HttpClientStatusImpl implements HttpClientStatus {
  @override
  bool isError(int statusCode) {
    return ResponseCode.errorsCodes.any((code) => code.code == statusCode);
  }

  @override
  bool isSuccess(int statusCode) {
    return ResponseCode.successCodes.any((code) => code.code == statusCode);
  }
}
