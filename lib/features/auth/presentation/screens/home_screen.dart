import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vetnow_user/core/theme/app_color.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/book_appointment_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/dashboard_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/my_doctor_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/my_petslist_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/pet_profiledetail_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/notification_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/settings_screen.dart';

import 'package:vetnow_user/features/auth/presentation/screens/assessment_flow.dart';
import 'package:vetnow_user/core/utils/pet_utils.dart';
import '../components/AppButton.dart';
import 'add_pet_wizard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Trigger API call when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _triggerDashboardCall();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Trigger API call when app becomes active/visible
    if (state == AppLifecycleState.resumed && mounted) {
      _triggerDashboardCall();
    }
  }

  void _triggerDashboardCall() {
    if (mounted) {
      context.read<DashboardBloc>().add(OnDashboardCall());
    }
  }

  // Public method that can be called from outside
  void refreshDashboard() {
    _triggerDashboardCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return _buildShimmerLoading(context);
          }

          if (state.error != null) {
            return _buildErrorState(context, state.error!);
          }

          return Stack(
            children: [
              _buildModernHeaderBackground(context),
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopProfileRow(context, state),
                      const SizedBox(height: 20),
                      _buildPetSection(context, state),
                      const SizedBox(height: 30),
                      _buildQuickActionsSection(context),
                      const SizedBox(height: 30),
                      _buildUpcomingAppointments(context, state),
                      const SizedBox(height: 30),
                      _buildMedicalRecordsSection(context, state),
                      const SizedBox(height: 30),
                      _buildTimelineSection(context, state),
                      _buildFooterBranding(context),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- 1. MODERN HEADER BACKGROUND ---
Widget _buildModernHeaderBackground(BuildContext context) {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    height: 280,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
            context.appBackground,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    ),
  );
}

// --- 2. TOP PROFILE ROW ---
Widget _buildTopProfileRow(BuildContext context, DashboardState state) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${state.user?.firstName ?? 'Friend'}",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              "How are your pets today?",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildNotificationIcon(context, state.isLoading),
            const SizedBox(width: 10),
            _buildProfileIcon(context, state),
          ],
        ),
      ],
    ),
  );
}

// --- 3. PET CARDS SECTION ---
Widget _buildPetSection(BuildContext context, DashboardState state) {
  if (state.pets.isEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.appBorder),
          boxShadow: [
            BoxShadow(
              color: context.appShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pets, color: Colors.orange, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              "No Pets Registered Yet",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: context.appText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Add your first pet to start tracking their health and booking appointments.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: context.appMutedText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 160,
              height: 44,
              child: AppButton(
                text: "Add Pet",
                onPressed: () {
                  final bloc = context.read<DashboardBloc>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: bloc,
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
            ),
          ],
        ),
      ),
    );
  }

  return Column(
    children: [
      SizedBox(
        height: 250,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.88),
          itemCount: state.pets.length,
          onPageChanged: (i) =>
              context.read<DashboardBloc>().add(CurrentStepChanged(i)),
          itemBuilder: (context, index) {
            final pet = state.pets[index];
            return _buildPassportCard(context, pet);
          },
        ),
      ),
      const SizedBox(height: 16),
      _buildPageIndicator(state.pets.length, state.currentStep),
    ],
  );
}

Widget _buildPassportCard(BuildContext context, Pets pet) {
  final bool isIncomplete =
      pet.profile?.weightKg == null ||
      pet.profile?.color == null ||
      pet.vaccinations?.isEmpty == true ||
      pet.profile?.profileCompleted == false;

  return Container(
    margin: const EdgeInsets.only(right: 16, bottom: 5),
    padding: const EdgeInsets.all(20), // Standardized padding
    decoration: BoxDecoration(
      color: context.appSurface,
      border: Border.all(color: context.appBorder),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: context.appShadow,
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      // Allow column to be as small as possible
      children: [
        // Top Row: Avatar and Name
        Row(
          children: [
            _buildPetAvatar(pet, isIncomplete),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.profile?.name ?? "Unnamed",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: context.appText,
                    ),
                  ),
                  Text(
                    "${pet.profile?.ageMonths}m • ${pet.profile?.sex}",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: context.appMutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _buildAssessmentAction(context, pet),
          ],
        ),

        // Dynamic spacing based on whether the banner exists
        const SizedBox(height: 12),

        if (isIncomplete) ...[
          GestureDetector(
            onTap: () => _navigateToEditPet(context, pet),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? Colors.orange.withValues(alpha: 0.1)
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.isDarkMode
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.orange.shade100,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.crisis_alert_rounded,
                    size: 14,
                    color: context.isDarkMode
                        ? Colors.orange.shade400
                        : Colors.orange.shade800,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Profile incomplete. Tap to finish.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode
                            ? Colors.orange.shade300
                            : Colors.orange.shade900,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_circle_right,
                    size: 12,
                    color: context.isDarkMode
                        ? Colors.orange.shade400
                        : Colors.orange.shade800,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12), // Gap after banner
        ] else
          const Spacer(), // If no banner, use spacer to push stats to bottom
        // Bottom Stats Container
        Container(
          padding: const EdgeInsets.all(12), // Slightly reduced padding
          decoration: BoxDecoration(
            color: context.appSurfaceVariant,
            border: Border.all(color: context.appBorder),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                Icons.monitor_weight,
                "${pet.profile?.weightKg ?? 0}kg",
                "Weight",
              ),
              _buildStatItem(
                context,
                Icons.opacity,
                pet.profile?.color ?? "-",
                "Color",
              ),
              _buildStatItem(
                context,
                Icons.verified,
                "${pet.vaccinations?.length ?? 0}",
                "Vaccines",
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Helper method for navigation to avoid code duplication
void _navigateToEditPet(BuildContext context, dynamic pet) {
  final bloc = context.read<DashboardBloc>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: PetProfileDetailScreen(pet: pet),
      ),
    ),
  );
}

// --- 4. QUICK ACTIONS ---
Widget _buildQuickActionsSection(BuildContext context) {
  final isDarkMode = context.isDarkMode;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: context.appText,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionTile(
              context,
              "Consult",
              Icons.video_call,
              context.appSoftPrimary,
              AppColors.primary,
              () {
                final bloc = context.read<DashboardBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: bloc,
                      child: const BookAppointmentScreen(),
                    ),
                  ),
                );
              },
            ),
            _buildActionTile(
              context,
              "Pets",
              Icons.history,
              isDarkMode ? const Color(0xFF102A20) : const Color(0xFFF0FDF4),
              Colors.green,
              () {
                final bloc = context.read<DashboardBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: bloc,
                      child: const MyPetsListScreen(),
                    ),
                  ),
                );
              },
            ),
            _buildActionTile(
              context,
              "My Doctor",
              Icons.location_on,
              isDarkMode ? const Color(0xFF2A1010) : const Color(0xFFFEF2F2),
              Colors.redAccent,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyDoctorScreen(),
                ),
              ),
            ),

            _buildActionTile(
              context,
              "Records",
              Icons.folder,
              isDarkMode ? const Color(0xFF1F102A) : const Color(0xFFFAF5FF),
              Colors.purple,
              () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainDashboard(initialIndex: 1),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}

// --- 5. UPCOMING APPOINTMENTS ---
Widget _buildUpcomingAppointments(BuildContext context, DashboardState state) {
  if (state.appointments.isEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upcoming Appointments",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: context.appText,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.appBorder),
              boxShadow: [
                BoxShadow(
                  color: context.appShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.event_busy, color: AppColors.primary, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  "No upcoming appointments",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.appText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Schedule a visit with a vet to get started.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: context.appMutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Appointments",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: context.appText,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainDashboard(initialIndex: 1),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                "View All",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.appointments.length > 2 ? 2 : state.appointments.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final appointment = state.appointments[index];
            return _buildAppointmentCard(context, appointment);
          },
        ),
      ],
    ),
  );
}

Widget _buildAppointmentCard(BuildContext context, AppointmentResponse appointment) {
  DateTime? appointmentDate;
  if (appointment.appointmentDate != null) {
    try {
      appointmentDate = DateTime.parse(appointment.appointmentDate!);
    } catch (e) {
      // Handle potential parsing errors
    }
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: context.appBorder),
      boxShadow: [
        BoxShadow(
          color: context.appShadow,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        // Date Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                appointmentDate != null 
                    ? DateFormat('dd').format(appointmentDate)
                    : (appointment.appointmentDate?.split('-').last ?? "00"),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Text(
                appointmentDate != null 
                    ? DateFormat('MMM').format(appointmentDate)
                    : "---",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Doctor & Pet Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.doctor?.fullName ?? "Doctor",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: context.appText,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.pets, size: 12, color: context.appMutedText),
                  const SizedBox(width: 4),
                  Text(
                    appointment.pet?.name ?? "Pet",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: context.appMutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.access_time, size: 12, color: context.appMutedText),
                  const SizedBox(width: 4),
                  Text(
                    appointment.appointmentTime ?? "00:00",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: context.appMutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(appointment.status ?? "").withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            appointment.status?.replaceAll('_', ' ') ?? "PENDING",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(appointment.status ?? ""),
            ),
          ),
        ),
      ],
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'PENDING_PAYMENT':
      return Colors.orange;
    case 'CONFIRMED':
      return Colors.green;
    case 'CANCELLED':
      return Colors.red;
    default:
      return Colors.blue;
  }
}

// --- 6. MEDICAL RECORDS SECTION ---
Widget _buildMedicalRecordsSection(BuildContext context, DashboardState state) {
  // Get all documents from all pets
  final allDocs = state.pets.expand((pet) => pet.documents ?? <DocumentsDetail>[]).toList();
  
  if (allDocs.isEmpty) return const SizedBox.shrink();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Medical Records",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: context.appText,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainDashboard(initialIndex: 1),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                "View All",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allDocs.length > 5 ? 5 : allDocs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final doc = allDocs[index];
              return Container(
                width: 160,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.appBorder),
                  boxShadow: [
                    BoxShadow(
                      color: context.appShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.description, color: Colors.green, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            doc.fileName ?? "Document",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: context.appText,
                            ),
                          ),
                          Text(
                            doc.documentType ?? "Report",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: context.appMutedText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

// --- 7. TIMELINE SECTION ---
Widget _buildTimelineSection(BuildContext context, DashboardState state) {
  // We can derive "Today's Activities" from vaccinations or upcoming appointments for today
  final now = DateTime.now();
  final todayAppointments = state.appointments.where((app) {
    if (app.appointmentDate == null) return false;
    try {
      final date = DateTime.parse(app.appointmentDate!);
      return date.year == now.year && date.month == now.month && date.day == now.day;
    } catch (_) {
      return false;
    }
  }).toList();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Activities",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: context.appText,
              ),
            ),
            Text(
              "View All",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (todayAppointments.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.appBorder),
              boxShadow: [
                BoxShadow(
                  color: context.appShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.schedule, size: 40, color: Colors.blueGrey.shade200),
                const SizedBox(height: 16),
                Text(
                  "No tasks for today",
                  style: GoogleFonts.plusJakartaSans(
                    color: context.appMutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todayAppointments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final app = todayAppointments[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.appBorder),
                  boxShadow: [
                    BoxShadow(
                      color: context.appShadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Appointment with ${app.doctor?.fullName ?? 'Vet'}",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: context.appText,
                            ),
                          ),
                          Text(
                            "Today at ${app.appointmentTime ?? '---'}",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: context.appMutedText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    ),
  );
}

// --- HELPER SUB-WIDGETS ---

Widget _buildStatItem(
  BuildContext context,
  IconData icon,
  String value,
  String label,
) {
  return Column(
    children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(height: 4),
      Text(
        value,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          fontSize: 14,
          color: context.appText,
        ),
      ),
      Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          color: context.appMutedText,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildActionTile(
  BuildContext context,
  String label,
  IconData icon,
  Color bg,
  Color iconColor,
  VoidCallback onClick,
) {
    return GestureDetector(
    onTap: onClick,
    child: Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: context.isDarkMode
                    ? Colors.black.withValues(alpha: 0.18)
                    : bg.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: context.appText,
          ),
        ),
      ],
    ),
  );
}

Widget _buildPetAvatar(Pets pet, bool isIncomplete) {
  final String? imageUrl = pet.profile?.qrCodeFileName;

  ImageProvider getImageProvider(String? url) {
    if (url == null || url.isEmpty) {
      return NetworkImage(PetUtils.getSpeciesImage(pet.profile?.speciesName));
    }
    // Check if it's a valid remote URL
    if (url.startsWith('http') || url.startsWith('https')) {
      return NetworkImage(url);
    }
    // If it's just a filename or a weird path like the error showed, fallback
    return NetworkImage(PetUtils.getSpeciesImage(pet.profile?.speciesName));
  }

  return Stack(
    children: [
      Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Image(
            image: getImageProvider(imageUrl),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                PetUtils.getSpeciesImage(pet.profile?.speciesName),
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
      if (isIncomplete)
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.priority_high,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
    ],
  );
}

Widget _buildNotificationIcon(BuildContext context, bool loading) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: IconButton(
      icon: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.notifications, color: Colors.white, size: 22),
      onPressed: () {
        final bloc = context.read<DashboardBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: const NotificationScreen(),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildProfileIcon(BuildContext context, DashboardState state) {
  final imageUrl = state.user?.profileImage;

  return GestureDetector(
    onTap: () {
      final bloc = context.read<DashboardBloc>();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const SettingsScreen(),
          ),
        ),
      );
    },
    child: Container(
      height: 48,
      width: 48,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: imageUrl != null && imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : null,
        child: imageUrl == null || imageUrl.isEmpty
            ? Text(
                (state.user?.firstName?.isNotEmpty == true
                        ? state.user!.firstName![0]
                        : "U")
                    .toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              )
            : null,
      ),
    ),
  );
}

Widget _buildAssessmentAction(BuildContext context, Pets pet) {
  return GestureDetector(
    onTap: () {
      final speciesId = pet.profile?.speciesId;
      if (speciesId != null) {
        final bloc = context.read<DashboardBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: bloc,
              child: AssessmentFlow(
                assessments: bloc.state.assessmentList,
                petId: pet.profile?.id ?? "",
                petName: pet.profile?.name ?? "Pet",
              ),
            ),
          ),
        );
        bloc.add(OnAssessmentQuestionCall(speciesId));
      }
    },
    child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Assess",
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

Widget _buildPageIndicator(int count, int current) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(count, (index) {
      bool active = index == current;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        height: 6,
        width: active ? 24 : 6,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : const Color(0xFF94A3B8),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }),
  );
}

Widget _buildFooterBranding(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(40.0),
    child: Center(
      child: Column(
        children: [
          const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
          const SizedBox(height: 8),
          Text(
            "VetNow: Professional Pet Care",
            style: GoogleFonts.plusJakartaSans(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF6F7A8D)
                  : Colors.blueGrey.shade300,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildShimmerLoading(BuildContext context) {
  return Stack(
    children: [
      _buildModernHeaderBackground(context),
      SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileShimmer(context),
              const SizedBox(height: 20),
              _buildPetSectionShimmer(context),
              const SizedBox(height: 30),
              _buildQuickActionsShimmer(context),
              const SizedBox(height: 30),
              _buildTimelineShimmer(context),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildErrorState(BuildContext context, String error) {
  return Stack(
    children: [
      _buildModernHeaderBackground(context),
      SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  "Something went wrong",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.appText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: context.appMutedText,
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: "Try Again",
                  onPressed: () =>
                      context.read<DashboardBloc>().add(OnDashboardCall()),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildProfileShimmer(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: context.appSurface,
    highlightColor: context.appSurface,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(width: 150, height: 16, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPetSectionShimmer(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: context.appSurface,
    highlightColor: context.appSurface,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 120, height: 24, color: context.appSurface),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildQuickActionsShimmer(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: context.appSurface,
    highlightColor: context.appSurface,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 150, height: 24, color: context.appSurface),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildTimelineShimmer(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: context.appSurface,
    highlightColor: context.appSurface,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 100, height: 24, color: context.appSurface),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
