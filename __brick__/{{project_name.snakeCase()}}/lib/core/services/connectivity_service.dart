import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get onConnectivityChanged => _controller.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final isConnected = result.any(
      (element) =>
          element == ConnectivityResult.mobile ||
          element == ConnectivityResult.wifi ||
          element == ConnectivityResult.ethernet,
    );
    _controller.add(isConnected);
  }

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.any(
      (element) =>
          element == ConnectivityResult.mobile ||
          element == ConnectivityResult.wifi ||
          element == ConnectivityResult.ethernet,
    );
  }

  void dispose() {
    _controller.close();
  }
}
