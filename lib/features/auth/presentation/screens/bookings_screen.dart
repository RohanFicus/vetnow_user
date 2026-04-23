import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/theme/app_color.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';

import '../components/AppButton.dart';
import '../components/app_bar.dart';
import '../components/appointment_card.dart';
import './book_appointment_screen.dart';
import './booking_details_screen.dart';

class BookingsScreen extends StatefulWidget {
  final int initialTab;
  final bool standalone;

  const BookingsScreen({
    super.key,
    this.initialTab = 0,
    this.standalone = false,
  });

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late int _selectedTab; // 0 = Upcoming, 1 = Past

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final now = DateTime.now();
        
        // Filter appointments into upcoming and past based on date
        final upcomingAppointments = state.appointments.where((a) {
          if (a.appointmentDate == null) return false;
          try {
            final date = DateTime.parse(a.appointmentDate!);
            // Simple check: if the date is today or later, it's upcoming
            return date.isAfter(now.subtract(const Duration(days: 1)));
          } catch (e) {
            return false;
          }
        }).toList();

        final pastAppointments = state.appointments.where((a) {
          if (a.appointmentDate == null) return true;
          try {
            final date = DateTime.parse(a.appointmentDate!);
            return date.isBefore(now.subtract(const Duration(days: 1)));
          } catch (e) {
            return true;
          }
        }).toList();

        final currentList = _selectedTab == 0 ? upcomingAppointments : pastAppointments;

        return Scaffold(
          backgroundColor: context.appBackground,
          appBar: widget.standalone
              ? buildSimpleAppBar(
                  context,
                  _selectedTab == 1 ? "Booking History" : "Appointments",
                )
              : null,
          body: SafeArea(
            bottom: false,
            top: !widget.standalone,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    widget.standalone ? 8 : 16,
                    24,
                    16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedTab == 1 ? "Booking History" : "Appointments",
                            style: TextStyle(
                              color: context.appText,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedTab == 1
                                ? "All your past appointments"
                                : "Review your pet's vet visit",
                            style: TextStyle(color: context.appMutedText),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: context.appSurface,
                            child: Icon(Icons.tune, color: context.appMutedText),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
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
                            child: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.appSurfaceVariant,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildTabButton("Upcoming", 0)),
                      Expanded(child: _buildTabButton("Past Appointments", 1)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: currentList.isEmpty 
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        itemCount: currentList.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final appointment = currentList[index];
                          return AppointmentCard(
                            appointment: appointment,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingDetailsScreen(appointment: appointment),
                                ),
                              );
                            },
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? context.appSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.appShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? context.appText : context.appMutedText,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_month, size: 64, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            Text(
              "No appointments found",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: context.appText,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedTab == 0
                  ? "You don't have any upcoming appointments. Schedule a visit with a vet to get started."
                  : "You haven't had any appointments yet. Your past medical visits will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.appMutedText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (_selectedTab == 0) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: AppButton(
                  text: "Book Appointment",
                  onPressed: () {
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
