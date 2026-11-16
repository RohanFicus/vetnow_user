import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/sign_in_screen.dart';

import 'package:vetnow_user/core/utils/doctor_utils.dart';
import '../../../../core/localization/app_language_notifier.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../components/AppButton.dart';
import './edit_profile_screen.dart';
import './my_doctor_screen.dart';
import './my_petslist_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerProfileBloc>()
        ..add(OwnerProfileCallLocally())
        ..add(OwnerDashBoardCallLocally()),
      child: BlocListener<OwnerProfileBloc, OwnerProfileState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.ownerProfileEntity != current.ownerProfileEntity ||
            previous.error != current.error,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
          builder: (context, state) {
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
                  context.strings.settings,
                  style: TextStyle(
                    color: context.appText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Profile Card (Gradient)
                    Container(
                      padding: const EdgeInsets.all(10),
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

                    const SizedBox(height: 20),

                    // 2. General Section
                    Text(
                      context.strings.generalSection,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSettingsTile(
                      context,
                      icon: Icons.pets,
                      color: Colors.purple.shade50,
                      iconColor: Colors.purple,
                      title: context.strings.myPets,
                      subtitle: context.strings.myPetsSubtitle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const MyPetsListScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.medical_services_outlined,
                      color: Colors.blue.shade50,
                      iconColor: Colors.blue,
                      title: DoctorUtils.formatDoctorName(
                        state.doctorProfile?.fullName,
                      ),
                      subtitle: context.strings.meetYourVeterinarian,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const MyDoctorScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // 3. Preferences Section
                    Text(
                      context.strings.preferencesSection,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSettingsTile(
                      context,
                      trailing: Switch(
                        value: context.isDarkMode,
                        activeThumbColor: AppColors.primary,
                        onChanged: (value) {
                          context.read<ThemeNotifier>().setMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                      icon: context.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Colors.indigo.shade50,
                      iconColor: Colors.indigo,
                      title: context.strings.darkMode,
                      subtitle: context.strings.darkModeSubtitle,
                      onTap: () {
                        context.read<ThemeNotifier>().setMode(
                          context.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                        );
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.translate,
                      color: Colors.teal.shade50,
                      iconColor: Colors.teal,
                      title: context.strings.language,
                      subtitle: context.watch<LanguageNotifier>().currentLanguageName,
                      trailing: _buildLanguageToggleButton(context),
                      onTap: () => _showLanguageDialog(context),
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.person_remove_outlined,
                      color: Colors.red.shade50,
                      iconColor: Colors.red,
                      title: context.strings.deleteAccount,
                      subtitle: context.strings.deleteAccountSubtitle,
                      onTap: () => _showDeleteDialog(context),
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.logout,
                      color: Colors.grey.shade100,
                      iconColor: Colors.grey.shade700,
                      title: context.strings.logout,
                      subtitle: context.strings.logoutSubtitle,
                      onTap: () => _showLogoutDialog(context),
                    ),
                    const SizedBox(height: 60), // Bottom padding
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
      margin: const EdgeInsets.only(bottom: 12),
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
        trailing:
            trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: context.appMutedText,
            ),
      ),
    );
  }

  Widget _buildLanguageToggleButton(BuildContext context) {
    final languageNotifier = context.watch<LanguageNotifier>();
    final isHindi = languageNotifier.isHindi;

    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? context.appSurfaceVariant
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.appBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption(
            context: context,
            title: "English",
            isSelected: !isHindi,
            onTap: () => context.read<LanguageNotifier>().setLanguage('en'),
          ),
          _buildLanguageOption(
            context: context,
            title: "हिन्दी",
            isSelected: isHindi,
            onTap: () => context.read<LanguageNotifier>().setLanguage('hi'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : context.appMutedText,
            ),
          ),
        ),
      ),
    );
  }

  // --- DIALOGS ---

  void _showLanguageDialog(BuildContext context) {
    final languageNotifier = context.read<LanguageNotifier>();
    showModalBottomSheet(
      context: context,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.strings.selectLanguage,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.appText,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: context.appMutedText),
                      onPressed: () => Navigator.pop(bottomSheetContext),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...LanguageNotifier.supportedLanguages.map((lang) {
                  final isSelected =
                      languageNotifier.currentLanguageCode == lang.code;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.appSoftPrimary
                          : context.appSurfaceVariant,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : context.appBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      onTap: () {
                        languageNotifier.setLanguage(lang.code);
                        Navigator.pop(bottomSheetContext);
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.translate,
                          color: isSelected
                              ? AppColors.primary
                              : context.appMutedText,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        lang.nativeName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.primary
                              : context.appText,
                        ),
                      ),
                      subtitle: Text(
                        lang.englishName,
                        style: TextStyle(
                          color: context.appMutedText,
                          fontSize: 12,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final ownerProfileBloc = context.read<OwnerProfileBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: ownerProfileBloc,
        child: Dialog(
          backgroundColor: dialogContext.appSurface,
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
                  context.strings.deleteAccountQuestion,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: dialogContext.appText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.strings.deleteAccountWarning,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dialogContext.appMutedText, height: 1.5),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: dialogContext.appBorder),
                        ),
                        child: Text(
                          context.strings.cancel,
                          style: TextStyle(color: dialogContext.appText),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ownerProfileBloc.add(DeleteAccount());
                          Navigator.pop(dialogContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          context.strings.deleteAccount,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
          backgroundColor: dialogContext.appSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                    Text(
                      context.strings.logoutQuestion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.strings.logoutConfirmQuestion,
                      style: const TextStyle(color: Colors.white70),
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
                            context.strings.signedOutOfVetNow,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: context.appText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildBulletPoint(
                            context,
                            context.strings.logoutBullet1,
                          ),
                          _buildBulletPoint(
                            context,
                            context.strings.logoutBullet2,
                          ),
                          _buildBulletPoint(
                            context,
                            context.strings.logoutBullet3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: context.appBorder),
                            ),
                            child: Text(
                              context.strings.cancel,
                              style: TextStyle(color: context.appText),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ownerProfileBloc.add(ClearSharedPref());
                              Navigator.pop(dialogContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              context.strings.logout,
                              style: const TextStyle(color: Colors.white),
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
