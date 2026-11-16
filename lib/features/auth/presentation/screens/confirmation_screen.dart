import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';

import 'package:vetnow_user/core/utils/doctor_utils.dart';
import './dashboard_screen.dart';
import '../components/AppButton.dart';
import '../../../../core/theme/app_color.dart';

class ConfirmationScreen extends StatefulWidget {
  final AppointmentRequest? appointmentRequest;
  final String? selectedTime;
  final String? fee;

  const ConfirmationScreen({
    super.key,
    this.appointmentRequest,
    this.selectedTime,
    this.fee,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  void _navigateToHome() {
    context.read<DashboardBloc>().add(ResetBookingStateEvent());
    context.read<DashboardBloc>().add(OnDashboardCall());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainDashboard(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        String? doctorFullName = state.doctorProfile?.fullName;
        if (doctorFullName == null || doctorFullName.trim().isEmpty) {
          try {
            final appointmentId = state.lastBookedAppointment?.appointmentId;
            if (appointmentId != null && appointmentId.isNotEmpty) {
              final match = state.appointments.firstWhere(
                (a) => a.id == appointmentId,
              );
              doctorFullName = match.doctor?.fullName;
            }
          } catch (_) {}
        }
        final doctorName = DoctorUtils.formatDoctorName(doctorFullName);
        final doctorSpecialty = "Veterinarian Specialist";

        String formattedDate = "December 15, 2025";
        if (widget.appointmentRequest?.appointmentDate != null) {
          try {
            final date = DateTime.parse(widget.appointmentRequest!.appointmentDate);
            formattedDate = DateFormat('MMMM dd, yyyy').format(date);
          } catch (_) {}
        }

        final bookingId = (state.lastBookedAppointment?.appointmentId.isNotEmpty == true)
            ? state.lastBookedAppointment!.appointmentId
            : "APT-${DateTime.now().millisecondsSinceEpoch}";

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _navigateToHome();
          },
          child: Scaffold(
            backgroundColor: context.appBackground,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Appointment Confirmed",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: context.appText,
                      ),
                    ),
                    Text(
                      "Your appointment has been scheduled.",
                      style: TextStyle(color: context.appMutedText),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.appSurface,
                        border: Border.all(color: context.appBorder),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          _confirmRow(
                            context,
                            Icons.calendar_today,
                            "Date",
                            formattedDate,
                            context.isDarkMode
                                ? Colors.blue.withValues(alpha: 0.1)
                                : Colors.blue.shade50,
                            Colors.blue,
                          ),
                          Divider(height: 30, color: context.appBorder),
                          _confirmRow(
                            context,
                            Icons.access_time,
                            "Time",
                            widget.selectedTime ?? "10:00 AM",
                            context.isDarkMode
                                ? Colors.purple.withValues(alpha: 0.1)
                                : Colors.purple.shade50,
                            Colors.purple,
                          ),
                          Divider(height: 30, color: context.appBorder),
                          _confirmRow(
                            context,
                            Icons.person_outline,
                            "Doctor",
                            doctorName,
                            context.isDarkMode
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.green.shade50,
                            Colors.green,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: context.appSurfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Booking ID",
                                  style: TextStyle(
                                      fontSize: 12, color: context.appMutedText),
                                ),
                                Text(
                                  bookingId,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: context.appText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    AppButton(
                      text: "Go to Home",
                      textColor: Colors.white,
                      color: AppColors.primary,
                      onPressed: _navigateToHome,
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      text: "View All Appointments",
                      textColor: context.isDarkMode ? Colors.white : AppColors.primary,
                      color: context.appSurface,
                      onPressed: _navigateToHome,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

  }

  Widget _confirmRow(
    BuildContext context,
    IconData icon,
    String title,
    String val,
    Color bg,
    Color iconCol,
  ) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: bg,
          radius: 20,
          child: Icon(icon, color: iconCol, size: 18),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: context.appMutedText, fontSize: 12),
              ),
              Text(
                val,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.appText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
