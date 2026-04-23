import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectivityStream =>
      _connectivity.onConnectivityChanged.map(_isConnected);

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any(
          (r) =>
      r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet,
    );
  }

}
class ConnectivityInterceptor extends Interceptor {
  final ConnectivityService connectivityService;

  ConnectivityInterceptor(this.connectivityService);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final isConnected = await connectivityService.checkConnectivity();

    if (!isConnected) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No Internet Connection',
        ),
      );
      return;
    }

    handler.next(options);
  }
}