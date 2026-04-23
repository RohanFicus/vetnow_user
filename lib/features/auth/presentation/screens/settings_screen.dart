import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vetnow_user/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/usecases/owner_profile_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/sign_in_screen.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../components/AppButton.dart';
import './bookings_screen.dart';
import './edit_profile_screen.dart';
import './my_doctor_screen.dart';
import './my_petslist_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerProfileBloc(
        OwnerProfileUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(ApiClient()),
            AuthLocalDataSourceImpl(),
          ),
        ),
        SecureStorageService(),
      )
        ..add(OwnerProfileCallLocally())
        ..add(OwnerDashBoardCallLocally()),
      child: BlocListener<OwnerProfileBloc, OwnerProfileState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.ownerProfileEntity != current.ownerProfileEntity ||
            previous.error != current.error,
        listener: (context, state) {
          if (state.error != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          }
        },
        child: BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
          builder: (context, state) {
            final themeNotifier = context.watch<ThemeNotifier>();
            return Scaffold(
              backgroundColor: context.appBackground,
              appBar: AppBar(
                backgroundColor: context.appBackground,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: context.appText,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  "Settings",
                  style: TextStyle(
                    color: context.appText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Profile Card (Gradient)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6A11CB),
                            Color(0xFF2575FC),
                          ], // Purple -> Blue
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF2575FC,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Lottie.asset(
                                'assets/lottie/profile.json',
                                width: 140,
                                height: 140,
                                repeat: true,
                                animate: true,
                                reverse: false,
                                fit: BoxFit.fill,
                              ),
                              /* Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white24,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),*/
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${state.firstName} ${state.lastName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          color: Colors.white70,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          state.email,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.white70,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          state.mobile,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: AppButton(
                              text: "Edit Profile",
                              textColor: AppColors.primary,
                              color: Colors.white,
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileScreen(),
                                  ),
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 2. General Section
                    const Text(
                      "General",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      icon: Icons.pets,
                      color: Colors.purple.shade50,
                      iconColor: Colors.purple,
                      title: "My Pets",
                      subtitle: "Manage all your furry friends",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const MyPetsListScreen(),
                          ),
                        );
                      },
                    ),
                 /*   _buildSettingsTile(
                      context,
                      icon: Icons.history,
                      color: Colors.green.shade50,
                      iconColor: Colors.green,
                      title: "Booking History",
                      subtitle: "All your past appointments",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const BookingsScreen(
                              initialTab: 1,
                              standalone: true,
                            ),
                          ),
                        );
                      },
                    ),*/
                    _buildSettingsTile(
                      context,
                      icon: Icons.medical_services_outlined,
                      color: Colors.blue.shade50,
                      iconColor: Colors.blue,
                      title: state.doctorProfile?.fullName ?? '..',
                      subtitle: "Meet Your Veterinarian",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const MyDoctorScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // 3. Preferences Section
                    const Text(
                      "Preferences",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsTile(
                      context,
                      trailing: Switch(
                        value: themeNotifier.mode == ThemeMode.dark,
                        activeThumbColor: AppColors.primary,
                        onChanged: (value) {
                          themeNotifier.setMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                      icon: themeNotifier.mode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Colors.indigo.shade50,
                      iconColor: Colors.indigo,
                      title: "Dark Mode",
                      subtitle: "Switch app appearance",
                      onTap: themeNotifier.toggle,
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.notifications_none,
                      color: Colors.indigo.shade50,
                      iconColor: Colors.indigo,
                      title: "Notifications",
                      subtitle: "Manage notification preferences",
                      onTap: () {},
                    ),
                    // Added these to trigger the dialogs shown in your design
                    _buildSettingsTile(
                      context,
                      icon: Icons.delete_outline,
                      color: Colors.red.shade50,
                      iconColor: Colors.red,
                      title: "Delete Data",
                      subtitle: "Remove all app data",
                      onTap: () => _showDeleteDialog(context),
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.logout,
                      color: Colors.grey.shade100,
                      iconColor: Colors.grey.shade700,
                      title: "Logout",
                      subtitle: "Sign out of your account",
                      onTap: () => _showLogoutDialog(context),
                    ),
                    const SizedBox(height: 80), // Bottom padding
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.appShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: context.appText,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: context.appMutedText, fontSize: 12),
        ),
        trailing: trailing ??
            Icon(Icons.arrow_forward_ios,
                size: 14, color: context.appMutedText),
      ),
    );
  }

  // --- DIALOGS ---

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: context.appSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Delete All Data?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.appText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "This will permanently delete all your data including pet profile, appointments, and timeline activities. This action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: context.appMutedText, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: context.appBorder),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: context.appText),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Delete & Reset",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final ownerProfileBloc = context.read<OwnerProfileBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: ownerProfileBloc,
        child: Dialog(
          backgroundColor: context.appSurface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gradient Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Logout?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Are you sure you want to sign out?",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.appSurfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You'll be signed out of VetNow",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: context.appText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildBulletPoint(
                              context, "Your data will be saved securely"),
                          _buildBulletPoint(
                              context, "You can sign back in anytime"),
                          _buildBulletPoint(
                            context,
                            "Upcoming appointments remain scheduled",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: context.appBorder),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: context.appText),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ownerProfileBloc.add(
                                ClearSharedPref(),
                              );
                              Navigator.pop(dialogContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: TextStyle(color: context.appMutedText, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: context.appMutedText, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
