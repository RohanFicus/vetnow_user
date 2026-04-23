import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/offline_data_service.dart';
import 'connectivity_service.dart';
import '../../features/auth/data/models/dashboard_response_model.dart';

class OfflineDataManager {
  static final OfflineDataManager _instance = OfflineDataManager._internal();
  factory OfflineDataManager() => _instance;
  OfflineDataManager._internal();

  final OfflineDataService _offlineDataService = OfflineDataService();
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isInitialized = false;
  StreamSubscription<bool>? _connectivitySubscription;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize offline data service
      await _offlineDataService.initialize();

      // Initialize connectivity service
      _connectivityService.initialize();

      // Listen to connectivity changes
      _connectivitySubscription = _connectivityService.connectivityStream
          .listen((isConnected) {
            debugPrint(
              'Connectivity status: ${isConnected ? 'Online' : 'Offline'}',
            );
            if (isConnected) {
              _onConnected();
            } else {
              _onDisconnected();
            }
          });

      // Initialize dummy data if needed
      await _offlineDataService.initializeDummyData();

      _isInitialized = true;
      debugPrint('OfflineDataManager initialized successfully');
    } catch (e) {
      debugPrint('Error initializing OfflineDataManager: $e');
    }
  }

  // Dashboard Methods
  Future<DashBoardResponseModal?> getDashboardData() async {
    try {
      if (_connectivityService.isConnected) {
        // Try to get fresh data from API (you would implement this)
        // For now, return cached/dummy data
        return await _offlineDataService.getDashboardData();
      } else {
        // Offline mode - return cached/dummy data
        debugPrint('Using offline data for dashboard');
        return await _offlineDataService.getDashboardData();
      }
    } catch (e) {
      debugPrint('Error getting dashboard data: $e');
      return await _offlineDataService.getDashboardData();
    }
  }

  Future<void> cacheDashboardData(DashBoardResponseModal data) async {
    try {
      await _offlineDataService.cacheDashboardData(data);
    } catch (e) {
      debugPrint('Error caching dashboard data: $e');
    }
  }

  // Pets Methods
  Future<List<Pets>> getPetsData() async {
    try {
      if (_connectivityService.isConnected) {
        // Try to get fresh data from API (you would implement this)
        return await _offlineDataService.getPetsData();
      } else {
        debugPrint('Using offline data for pets');
        return await _offlineDataService.getPetsData();
      }
    } catch (e) {
      debugPrint('Error getting pets data: $e');
      return await _offlineDataService.getPetsData();
    }
  }

  Future<void> cachePetsData(List<Pets> pets) async {
    try {
      await _offlineDataService.cachePetsData(pets);
    } catch (e) {
      debugPrint('Error caching pets data: $e');
    }
  }

  // Appointments Methods
  Future<List<AppointmentResponse>> getAppointmentsData() async {
    try {
      if (_connectivityService.isConnected) {
        // Try to get fresh data from API (you would implement this)
        return await _offlineDataService.getAppointmentsData();
      } else {
        debugPrint('Using offline data for appointments');
        return await _offlineDataService.getAppointmentsData();
      }
    } catch (e) {
      debugPrint('Error getting appointments data: $e');
      return await _offlineDataService.getAppointmentsData();
    }
  }

  Future<void> cacheAppointmentsData(
    List<AppointmentResponse> appointments,
  ) async {
    try {
      await _offlineDataService.cacheAppointmentsData(appointments);
    } catch (e) {
      debugPrint('Error caching appointments data: $e');
    }
  }

  // Utility Methods
  bool get isConnected => _connectivityService.isConnected;
  Stream<bool> get connectivityStream =>
      _connectivityService.connectivityStream;
  bool hasOfflineData(String key) => _offlineDataService.hasOfflineData(key);
  DateTime? getLastUpdated(String key) =>
      _offlineDataService.getLastUpdated(key);

  Future<void> clearAllData() async {
    try {
      await _offlineDataService.clearAllData();
      debugPrint('All offline data cleared');
    } catch (e) {
      debugPrint('Error clearing offline data: $e');
    }
  }

  void _onConnected() {
    debugPrint('Device is now online - you can sync data here');
    // Implement data synchronization logic here
  }

  void _onDisconnected() {
    debugPrint('Device is now offline - using cached data');
    // Implement offline mode logic here
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityService.dispose();
  }
}
