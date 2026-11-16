import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';

import 'core/di/service_locator.dart';
import 'core/localization/app_language_notifier.dart';
import 'core/localization/app_localizations.dart';
import 'core/navigation/navigation_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'features/splash/presentation/app_launcher.dart';
import 'features/splash/presentation/splash_view_model.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //Hive.registerAdapter(UserLocalModelAdapter());

  await initDependencies();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        Provider<SecureStorageService>(create: (_) => SecureStorageService()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(
          create: (context) =>
              LanguageNotifier(storageService: context.read<SecureStorageService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SplashViewModel(context.read<SecureStorageService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier?>(context);
    final languageNotifier = Provider.of<LanguageNotifier?>(context);

    if (themeNotifier == null || languageNotifier == null) {
      return MultiProvider(
        providers: [
          Provider<SecureStorageService>(create: (_) => SecureStorageService()),
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider(
            create: (ctx) => LanguageNotifier(
              storageService: ctx.read<SecureStorageService>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) =>
                SplashViewModel(ctx.read<SecureStorageService>()),
          ),
        ],
        child: const _AppContent(),
      );
    }

    return const _AppContent();
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final languageNotifier = context.watch<LanguageNotifier>();

    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'VetNow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeNotifier.mode,
      locale: languageNotifier.locale,
      supportedLocales: LanguageNotifier.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AppLauncher(),
    );
  }
}
