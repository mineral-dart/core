import 'package:mineral/src/infrastructure/services/http/http_interceptor.dart';
import 'package:test/test.dart';

void main() {
  group('HttpInterceptorImpl', () {
    test('request interceptors list is empty by default', () {
      final interceptor = HttpInterceptorImpl();
      expect(interceptor.request, isEmpty);
    });

    test('response interceptors list is empty by default', () {
      final interceptor = HttpInterceptorImpl();
      expect(interceptor.response, isEmpty);
    });

    test('can add request interceptor', () {
      final interceptor = HttpInterceptorImpl();
      interceptor.request.add((request) => request);
      expect(interceptor.request, hasLength(1));
    });

    test('can add response interceptor', () {
      final interceptor = HttpInterceptorImpl();
      interceptor.response.add((response) => response);
      expect(interceptor.response, hasLength(1));
    });

    test('can add multiple request interceptors', () {
      final interceptor = HttpInterceptorImpl();
      interceptor.request.add((request) => request);
      interceptor.request.add((request) => request);
      interceptor.request.add((request) => request);
      expect(interceptor.request, hasLength(3));
    });

    test('can add multiple response interceptors', () {
      final interceptor = HttpInterceptorImpl();
      interceptor.response.add((response) => response);
      interceptor.response.add((response) => response);
      expect(interceptor.response, hasLength(2));
    });
  });
}
