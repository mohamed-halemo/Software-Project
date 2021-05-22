import 'package:http/http.dart' as http;
import './Classes/globals.dart' as globals;

void testApi() {
  var urlUri = Uri.parse(globals.HttpSingleton().getBaseUrl() + '/gallery');

  http.get(
    urlUri,
    headers: {"Content-Type": "application/json"},
  ).then((value) => print(value.body));
}
