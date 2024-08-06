
import 'package:dio/dio.dart';

import '../retry_connection.dart';

class RequestInterceptors extends Interceptor {
  final ConnectivityRetryRequest requestRetrier;
  final String token;

  RequestInterceptors({required this.requestRetrier, required this.token});
}
