import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/data/datasources/dashboard_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/repositories/dashboard_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/usecases/dashboard_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';

// Screens
import '../../../../core/theme/app_color.dart';
import './home_screen.dart';
import './bookings_screen.dart';
import './add_activity_screen.dart';
import './add_pet_wizard_screen.dart';

class MainDashboard extends StatefulWidget {
  final int initialIndex;
  const MainDashboard({super.key, this.initialIndex = 0});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  late int _selectedIndex;
  DateTime? currentBackPressTime;
  bool canPopNow = false;
  late DashboardBloc _dashboardBloc;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _dashboardBloc = sl<DashboardBloc>();
    _dashboardBloc.add(OnDashboardCall());
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);

    // Trigger dashboard API call when home tab (index 0) is selected
    if (index == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _dashboardBloc.add(OnDashboardCall());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _dashboardBloc,
      child: Scaffold(
        backgroundColor: context.appBackground,
        // Modern soft background
        extendBody: true,

        // Allows content to flow behind the notched bar
        body: PopScope(
          canPop: canPopNow,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _handleBackPress();
          },
          child: IndexedStack(index: _selectedIndex, children: _screens),
        ),

        // --- CUSTOM FAB ---
        floatingActionButton: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _showModernAddMenu,
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // --- MODERN BOTTOM BAR ---
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          elevation: 20,
          color: context.appSurface,
          surfaceTintColor: context.appSurface,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Expanded(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     // Centered on the right side
              //     children: [_buildNavItem(0, Icons.home, "Home")],
              //   ),
              // ),
              _buildNavItem(0, Icons.home, "Home"),
              const SizedBox(width: 24),
              _buildNavItem(1, Icons.calendar_month, "Bookings"),
              //const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 2),
             child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primary
                    : const Color(0xFF94A3B8),
                size: 24,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? AppColors.primary
                    : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 2),
            // Dot Indicator
            AnimatedOpacity(
              opacity: isSelected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                height: 2,
                width: 2,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackPress() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Press again to exit VetNow",
            style: GoogleFonts.plusJakartaSans(fontSize: 12),
          ),
          behavior: SnackBarBehavior.floating,
          width: 200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      setState(() => canPopNow = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => canPopNow = false);
      });
    }
  }

  // --- REDESIGNED ACTION MENU ---
  void _showModernAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: _dashboardBloc,
          child: Container(
            decoration: BoxDecoration(
              color: sheetContext.appSurface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle Bar
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  "Quick Actions",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: sheetContext.appText,
                  ),
                ),
                const SizedBox(height: 24),

                _buildActionTile(
                  sheetContext,
                  title: "Register New Pet",
                  sub: "Add a digital passport for your pet",
                  icon: Icons.pets,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: _dashboardBloc,
                          child: AddPetWizardScreen(
                            existing: false,
                            speciesModel: null,
                            onComplete: () {},
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                /*const SizedBox(height: 16),
                _buildActionTile(
                  sheetContext,
                  title: "Daily Activity",
                  sub: "Log vaccines, meals, or walkies",
                  icon: Icons.calendar_month,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: _dashboardBloc,
                          child: const AddActivityScreen(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildActionTile(
                  sheetContext,
                  title: "Medical Records",
                  sub: "Upload a health report or prescription",
                  icon: Icons.file_copy,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    setState(() => _selectedIndex = 1);
                  },
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String sub,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appSurfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.appBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: context.appText,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: context.appMutedText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_circle_right_rounded,
              size: 16,
              color: context.appMutedText,
            ),
          ],
        ),
      ),
    );
  }
}
