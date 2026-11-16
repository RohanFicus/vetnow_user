import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _requestId = 'request_id';
  static const _customer_profile = 'customer_profile';
  static const _dashboard_data = 'dashboard_data';
  static const _pet_profile = 'pet_profile';
  static const _onboardingStage = 'onboarding_stage';
  static const _languageKey = 'app_language';

  final _storage = const FlutterSecureStorage();

  Future<void> saveOnboardingStage(String stage) async {
    await _storage.write(key: _onboardingStage, value: stage);
  }

  Future<String?> getOnboardingStage() async {
    return await _storage.read(key: _onboardingStage);
  }

  Future<void> clearOnboardingStage() async {
    await _storage.delete(key: _onboardingStage);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<void> saveRequestId(String token) async {
    await _storage.write(key: _requestId, value: token);
  }

  Future<String?> getRequestId() async {
    return await _storage.read(key: _requestId);
  }

  Future<void> saveCustomerProfileJson(Map<String, dynamic> json) async {
    final jsonString = jsonEncode(json);
    await _storage.write(key: _customer_profile, value: jsonString);
  }

  Future<Map<String, dynamic>?> getCustomerProfileJson() async {
    final jsonString = await _storage.read(key: _customer_profile);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> saveDashboardDataJson(Map<String, dynamic> json) async {
    final jsonString = jsonEncode(json);
    await _storage.write(key: _dashboard_data, value: jsonString);
  }

  Future<Map<String, dynamic>?> getDashboardDataJson() async {
    final jsonString = await _storage.read(key: _dashboard_data);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> savePetProfileJson(Map<String, dynamic> json) async {
    final jsonString = jsonEncode(json);
    await _storage.write(key: _pet_profile, value: jsonString);
  }

  Future<Map<String, dynamic>?> getPetProfileJson() async {
    final jsonString = await _storage.read(key: _pet_profile);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> clearCustomerProfileJson() async {
    await _storage.delete(key: _customer_profile);
  }

  Future<void> saveLanguageCode(String languageCode) async {
    await _storage.write(key: _languageKey, value: languageCode);
  }

  Future<String?> getLanguageCode() async {
    return await _storage.read(key: _languageKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
