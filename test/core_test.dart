import 'functionals/container_test.dart' as container_test;
import 'functionals/http_client_test.dart' as http_client_test;
import 'functionals/environment_test.dart' as environment_test;
import 'functionals/intent_test.dart' as intent_test;

void main () {
  container_test.main();
  http_client_test.main();
  environment_test.main();
  intent_test.main();
}