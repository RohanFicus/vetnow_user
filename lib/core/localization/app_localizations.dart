import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_strings.dart';

/// AppLocalizations provides localized strings to Flutter's localization framework.
class AppLocalizations {
  final Locale locale;
  late final AppStrings strings;

  AppLocalizations(this.locale) {
    strings = AppStrings(locale.languageCode);
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    AppStrings.currentLanguage = locale.languageCode;
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
