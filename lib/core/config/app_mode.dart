class AppMode {
  // Force local mock responses with:
  // flutter run --dart-define=USE_MOCK_DATA=true
  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: false,
  );
}
