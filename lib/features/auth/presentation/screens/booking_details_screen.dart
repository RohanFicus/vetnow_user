import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/core/utils/pet_utils.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final AppointmentResponse appointment;

  const BookingDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    DateTime? appointmentDate;
    if (appointment.appointmentDate != null) {
      try {
        appointmentDate = DateTime.parse(appointment.appointmentDate!);
      } catch (e) {
        // Handle error
      }
    }

    final status = appointment.status?.toUpperCase() ?? "PENDING";
    final isConfirmed = status == "CONFIRMED";
    final isCancelled = status == "CANCELLED";

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: context.appSurface,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: context.appText,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          "Booking Details",
          style: TextStyle(
            color: context.appText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isConfirmed 
                    ? const Color(0xFFCCFFD9) 
                    : isCancelled 
                        ? Colors.red.shade100 
                        : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isConfirmed ? Colors.green : isCancelled ? Colors.red : Colors.orange).withValues(alpha: 0.1)
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isConfirmed ? const Color(0xFF00C853) : isCancelled ? Colors.red : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Booking ${status.replaceAll('_', ' ')}",
                    style: TextStyle(
                      color: isConfirmed ? const Color(0xFF00692C) : isCancelled ? Colors.red.shade900 : Colors.orange.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pet Information
            Text(
              "Pet Information",
              style: TextStyle(color: context.appMutedText, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.appBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: context.appSurfaceVariant,
                    backgroundImage: appointment.pet?.profileImage != null && appointment.pet!.profileImage!.isNotEmpty
                        ? NetworkImage(appointment.pet!.profileImage!)
                        : NetworkImage(PetUtils.getSpeciesImage(appointment.pet?.speciesName)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.pet?.name ?? "Unnamed Pet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.appText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${appointment.pet?.breedName ?? 'N/A'} • ${appointment.pet?.speciesName ?? 'N/A'}",
                          style: TextStyle(color: context.appMutedText, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Appointment Details
            Text(
              "Appointment Details",
              style: TextStyle(color: context.appMutedText, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.appSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.appBorder),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_today,
                    iconColor: Colors.blue,
                    iconBg: const Color(0xFFE3F2FD),
                    label: "Date",
                    value: appointmentDate != null 
                        ? DateFormat('MMMM dd, yyyy').format(appointmentDate)
                        : appointment.appointmentDate ?? "N/A",
                  ),
                  Divider(height: 32, color: context.appBorder),
                  _buildDetailRow(
                    context,
                    icon: Icons.access_time,
                    iconColor: Colors.purple,
                    iconBg: const Color(0xFFF3E5F5),
                    label: "Time",
                    value: appointment.appointmentTime ?? "N/A",
                  ),
                  Divider(height: 32, color: context.appBorder),
                  _buildDetailRow(
                    context,
                    icon: Icons.person_outline,
                    iconColor: Colors.green,
                    iconBg: const Color(0xFFE8F5E9),
                    label: "Doctor",
                    value: appointment.doctor?.fullName ?? "N/A",
                    subValue: "Veterinarian Specialist",
                  ),
                  const SizedBox(height: 24),

                  // Booking ID Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.appSurfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Booking ID",
                          style: TextStyle(fontSize: 12, color: context.appMutedText),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.id ?? "N/A",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: context.appText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reported Symptoms
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              Text(
                "Reason for Visit",
                style: TextStyle(color: context.appMutedText, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                appointment.notes!,
                style: TextStyle(color: context.appText, fontSize: 14),
              ),
            ],

            // Bottom Spacing
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    String? subValue,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: context.appMutedText),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.appText),
            ),
            if (subValue != null)
              Text(
                subValue,
                style: TextStyle(fontSize: 12, color: context.appMutedText),
              ),
          ],
        ),
      ],
    );
  }
}
