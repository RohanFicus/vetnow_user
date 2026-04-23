import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/datasources/dashboard_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/repositories/dashboard_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/usecases/dashboard_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/sign_in_screen.dart';

import '../components/app_bar.dart';
import '../components/AppButton.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_theme_colors.dart';

class MyDoctorScreen extends StatelessWidget {
  const MyDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(OwnerProfileCallLocally()),
      child: BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (previous, current) =>
            previous.user != current.user ||
            previous.pets != current.pets ||
            previous.isLoading != current.isLoading ||
            previous.error != current.error,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            var selectedIndex = 0;
            return Scaffold(
              backgroundColor: context.appBackground,
              appBar: buildSimpleAppBar(context, "${state.doctorProfile?.fullName}"),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Doctor Profile Header
                          Container(
                            padding: const EdgeInsets.all(16),
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
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                    "${state.doctorProfile?.profileImage}",
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${state.doctorProfile?.fullName}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: context.appText,
                                        ),
                                      ),
                                      Text(
                                        "${state.doctorProfile?.email}",
                                        style: TextStyle(
                                          color: context.appMutedText,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        "${state.doctorProfile?.mobile}",
                                        style: TextStyle(
                                          color: context.appMutedText,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Info Cards (Dashed/Bordered look)
                          _buildHighlightRow(
                            context,
                            Icons.currency_rupee,
                            "Consultation Fee",
                            "₹${state.doctorProfile?.consultationFee}",
                            Colors.green,
                          ),
                          const SizedBox(height: 12),
                          state.doctorProfile?.doctorAvailabilityResponse?.workingDays != null ? _buildHighlightRow(
                            context,
                            Icons.access_time,
                            "Working Hours",
                            "${state.doctorProfile?.doctorAvailabilityResponse?.workingDays}",
                            Colors.purple,
                          ) : SizedBox(),
                          const SizedBox(height: 12),
                          Text(
                            "Slots Available",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: context.appText,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildHighlightRow(
                            context,
                            state.doctorProfile?.doctorAvailabilityResponse?.morningActive == true ? Icons.check : Icons.cancel,
                            "Morning",
                            "${state.doctorProfile?.doctorAvailabilityResponse?.morningStart} - ${state.doctorProfile?.doctorAvailabilityResponse?.morningEnd}",
                            Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          _buildHighlightRow(
                            context,
                            state.doctorProfile?.doctorAvailabilityResponse?.afternoonActive == true ? Icons.check : Icons.cancel,
                            "Afternoon",
                            "${state.doctorProfile?.doctorAvailabilityResponse?.afternoonStart} - ${state.doctorProfile?.doctorAvailabilityResponse?.afternoonEnd}",
                            Colors.blue,
                          ),

                          const SizedBox(height: 12),
                          _buildHighlightRow(
                            context,
                            state.doctorProfile?.doctorAvailabilityResponse?.eveningActive == true ? Icons.check : Icons.cancel,
                            "Evening",
                            "${state.doctorProfile?.doctorAvailabilityResponse?.eveningStart} - ${state.doctorProfile?.doctorAvailabilityResponse?.eveningEnd}",
                            Colors.blue,
                          ),

                          const SizedBox(height: 24),

                          // Specializations
                          Text(
                            "Specializations",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: context.appText,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _buildChip(context, "General Medicine"),
                              _buildChip(context, "Surgery"),
                              _buildChip(context, "Preventive Care"),
                              _buildChip(context, "Emergency Care"),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // About
                          Text(
                            "About",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: context.appText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: context.appShadow,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              "Dr. ${state.doctorProfile?.fullName} is a compassionate veterinarian with over a decade of experience in treating small animals. She specializes in preventive care and emergency surgeries.",
                              style: TextStyle(
                                color: context.appMutedText,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Button
                  // Padding(
                  //   padding: const EdgeInsets.all(24.0),
                  //   child: AppButton(
                  //     text: "Book Appointment",
                  //     textColor: Colors.white,
                  //     color: AppColors.primary,
                  //     onPressed: () {},
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHighlightRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurface,
        border: Border.all(
          color: color.withOpacity(0.3),
          style: BorderStyle.solid,
        ), // Mimicking dashed with light solid for simplicity
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.appShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: context.appText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: context.appMutedText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.appSoftPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.primary, fontSize: 12),
      ),
    );
  }
}
