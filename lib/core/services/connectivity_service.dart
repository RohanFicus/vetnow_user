import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  bool _isConnected = true;
  Timer? _connectivityTimer;

  Stream<bool> get connectivityStream => _connectivityController.stream;
  bool get isConnected => _isConnected;

  void initialize() {
    // Start periodic connectivity checks
    _startConnectivityMonitoring();
  }

  void _startConnectivityMonitoring() {
    // Check connectivity every 5 seconds
    _connectivityTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      // Try to connect to a reliable host
      final result = await InternetAddress.lookup('google.com');
      final newStatus = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      
      if (_isConnected != newStatus) {
        _isConnected = newStatus;
        _connectivityController.add(_isConnected);
        debugPrint('Internet connectivity changed: ${_isConnected ? 'Online' : 'Offline'}');
      }
    } catch (e) {
      if (_isConnected) {
        _isConnected = false;
        _connectivityController.add(_isConnected);
        debugPrint('Internet connectivity changed: Offline');
      }
    }
  }

  Future<bool> checkConnectivity() async {
    await _checkConnectivity();
    return _isConnected;
  }

  void dispose() {
    _connectivityTimer?.cancel();
    _connectivityController.close();
  }
}
