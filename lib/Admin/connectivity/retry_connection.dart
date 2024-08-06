import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';


class ConnectivityRetryRequest {
  final Dio dio;
  final Connectivity connectivity;

  ConnectivityRetryRequest({
    required this.dio,
    required this.connectivity,
  });

  Future<Response> scheduleSignalRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription? streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = connectivity.onConnectivityChanged.listen(
          (connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription!.cancel();
          // Complete the completer instead of returning
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
            ),
          );
        }
      },
    );

    return responseCompleter.future ;
  }
}