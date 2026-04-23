import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:vetnow_user/features/auth/presentation/screens/create_profile_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/dashboard_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/main_flow_controller.dart';

import '../../auth/presentation/screens/sign_in_screen.dart';
import 'splash_view_model.dart';

class AppLauncher extends StatefulWidget {
  const AppLauncher({super.key});

  @override
  State<AppLauncher> createState() => _AppLauncherState();
}

class _AppLauncherState extends State<AppLauncher> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final viewModel = context.read<SplashViewModel>();
      await viewModel.initializeApp();

      // ✅ Remove splash ONCE after logic completes
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewModel>(
      builder: (context, viewModel, _) {
        final destination = viewModel.destination;

        if (destination == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        print(destination);
        switch (destination) {
          case AppStartDestination.login:
            return SignInScreen();
          case AppStartDestination.userProfile:
            return MainFlowController();
          case AppStartDestination.home:
            return MainDashboard();
          // case AppStartDestination.petProfile:
          //   return MainDashboard();
          default:
            return CreateProfileScreen();
        }
      },
    );
  }
}
