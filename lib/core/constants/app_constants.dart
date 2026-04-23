class AppConstants {
  // Storage keys
  static const String offlineDataBoxName = 'offline_data_box';
  static const String dashboardDataKey = 'dashboard_data';
  static const String petsDataKey = 'pets_data';
  static const String appointmentsDataKey = 'appointments_data';
  static const String doctorsDataKey = 'doctors_data';
  static const String breedsDataKey = 'breeds_data';
  static const String userDataKey = 'user_data';
  
  // API endpoints (for when online)
  static const String baseUrl = 'https://api.vetnow.com';
  static const String dashboardEndpoint = '/dashboard';
  static const String petsEndpoint = '/pets';
  static const String appointmentsEndpoint = '/appointments';
  static const String doctorsEndpoint = '/doctors';
  static const String breedsEndpoint = '/breeds';
  
  // Cache settings
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // App settings
  static const String appName = 'VetNow';
  static const String appVersion = '1.0.0';
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double borderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}
