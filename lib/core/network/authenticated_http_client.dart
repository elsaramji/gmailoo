import 'package:http/http.dart' as http;

abstract class AuthenticatedHttpClient {
  Future<http.Client> getClient();
}
