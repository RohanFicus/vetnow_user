import 'package:flutter/material.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'app_strings.dart';

/// Model representing a supported language item in the app.
class AppLanguageItem {
  final String code;
  final String englishName;
  final String nativeName;

  const AppLanguageItem({
    required this.code,
    required this.englishName,
    required this.nativeName,
  });
}

/// Manages language/locale state and persists user selection.
class LanguageNotifier extends ChangeNotifier {
  final SecureStorageService _storageService;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  static const List<AppLanguageItem> supportedLanguages = [
    AppLanguageItem(
      code: 'en',
      englishName: 'English',
      nativeName: 'English',
    ),
    AppLanguageItem(
      code: 'hi',
      englishName: 'Hindi',
      nativeName: 'हिन्दी',
    ),
  ];

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  String get currentLanguageCode => _locale.languageCode;
  bool get isHindi => _locale.languageCode == 'hi';
  bool get isEnglish => _locale.languageCode == 'en';

  String get currentLanguageName {
    final match = supportedLanguages.firstWhere(
      (lang) => lang.code == _locale.languageCode,
      orElse: () => supportedLanguages.first,
    );
    return match.nativeName;
  }

  LanguageNotifier({SecureStorageService? storageService})
      : _storageService = storageService ?? SecureStorageService() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final savedCode = await _storageService.getLanguageCode();
      if (savedCode != null && (savedCode == 'en' || savedCode == 'hi')) {
        _locale = Locale(savedCode);
        AppStrings.currentLanguage = savedCode;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> setLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    _locale = Locale(languageCode);
    AppStrings.currentLanguage = languageCode;
    await _storageService.saveLanguageCode(languageCode);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    final newCode = _locale.languageCode == 'en' ? 'hi' : 'en';
    await setLanguage(newCode);
  }
}
