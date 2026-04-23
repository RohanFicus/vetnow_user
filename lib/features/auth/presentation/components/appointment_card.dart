import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/core/utils/pet_utils.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentResponse appointment;
  final VoidCallback onTap;

  const AppointmentCard({super.key, required this.appointment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusBg;
    Color statusText;

    final status = appointment.status?.toUpperCase() ?? "PENDING";

    switch (status) {
      case 'CONFIRMED':
        statusBg = const Color(0xFFE8F5E9); // Light Green
        statusText = const Color(0xFF2E7D32); // Dark Green
        break;
      case 'COMPLETED':
        statusBg = const Color(0xFFE3F2FD); // Light Blue
        statusText = const Color(0xFF1565C0); // Dark Blue
        break;
      case 'CANCELLED':
        statusBg = const Color(0xFFFFEBEE); // Light Red
        statusText = const Color(0xFFC62828); // Dark Red
        break;
      case 'PENDING_PAYMENT':
        statusBg = Colors.orange.shade50;
        statusText = Colors.orange.shade800;
        break;
      default:
        statusBg = Colors.grey[200]!;
        statusText = Colors.grey[800]!;
    }

    DateTime? appointmentDate;
    if (appointment.appointmentDate != null) {
      try {
        appointmentDate = DateTime.parse(appointment.appointmentDate!);
      } catch (e) {
        // Handle error
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(16),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header Row
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: appointment.pet?.profileImage != null && appointment.pet!.profileImage!.isNotEmpty
                            ? NetworkImage(appointment.pet!.profileImage!)
                            : NetworkImage(PetUtils.getSpeciesImage(appointment.pet?.speciesName)),
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.pet?.name ?? "Unnamed Pet",
                              style: TextStyle(
                                color: context.appText,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              appointment.id ?? "N/A",
                              style: TextStyle(
                                fontSize: 12,
                                color: context.appMutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.replaceAll('_', ' '),
                          style: TextStyle(
                            color: statusText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Details Row 1
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: context.appMutedText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${appointmentDate != null ? DateFormat('MMMM dd, yyyy').format(appointmentDate) : appointment.appointmentDate ?? 'N/A'} at ${appointment.appointmentTime ?? 'N/A'}",
                        style: TextStyle(
                          color: context.appMutedText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Details Row 2
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: context.appMutedText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appointment.doctor?.fullName ?? "N/A",
                        style: TextStyle(
                          color: context.appMutedText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer Fee
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.appSurfaceVariant,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Consultation Fee",
                    style: TextStyle(color: context.appMutedText, fontSize: 13),
                  ),
                  Text(
                    "₹${appointment.doctor?.consultationFee ?? '0'}",
                    style: TextStyle(
                      color: context.appText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
