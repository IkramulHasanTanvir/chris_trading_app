import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectivityStream =>
      _connectivity.onConnectivityChanged.map(_isConnectedFromEvent);

  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _isConnectedFromEvent(result);
    } catch (_) {
      // Fail open for local/cached flows; request interceptor still handles real offline.
      return true;
    }
  }

  bool _isConnectedFromEvent(dynamic event) {
    if (event is List<ConnectivityResult>) {
      return _isConnected(event);
    }
    if (event is ConnectivityResult) {
      return event != ConnectivityResult.none;
    }
    return true;
  }

  bool _isConnected(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
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
    try {
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
    } catch (_) {
      // Connectivity plugin errors should not block requests.
    }

    handler.next(options);
  }
}
