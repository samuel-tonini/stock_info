import 'package:http/http.dart';

import '../../../infra/http/http.dart';
import '../../../infra/protocols/protocols.dart';

import '../../config/config.dart';

HttpClient makeHttpClient() {
  return HttpAdapter(
    baseUrl: Env.baseUrl,
    client: Client(),
    hostHeader: Env.hostHeader,
    keyHeader: Env.keyHeader,
  );
}
