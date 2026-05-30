import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/assessment_flow.dart';

class AssesmentOnboardingScreen extends StatelessWidget {
  final String? speciesId;
  final String? petName;
  final String? petId;

  const AssesmentOnboardingScreen({
    super.key,
    required this.speciesId,
    required this.petName,
    required this.petId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()
            ..add(OnAssessmentQuestionCall(speciesId.toString()))
            ..add(OwnerProfileCallLocally()),
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => SignInScreen()),
            // );
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  // 1. Background Image (Taking up the top portion)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=1000',
                        ), // Replace with your asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // 2. The Information Card
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.68,
                      width: double.infinity,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hey, ${state.firstName} ${state.lastName}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "$petName’s Health\nAssessment",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Feature List
                          const _FeatureItem(
                            icon: Icons.medical_services_outlined,
                            iconBg: Color(0xFFE8F0FE),
                            iconColor: Color(0xFF3B76E1),
                            title: "Complete Health Overview",
                            subtitle:
                                "A head-to-tail check of your pet’s health, habits, and daily routine.",
                          ),
                          const _FeatureItem(
                            icon: Icons.error_outline,
                            iconBg: Color(0xFFFFF3E0),
                            iconColor: Color(0xFFFF9800),
                            title: "Early Risk Detection",
                            subtitle:
                                "Spot potential health concerns early and get guidance for ongoing care.",
                          ),
                          const _FeatureItem(
                            icon: Icons.pets_outlined,
                            iconBg: Color(0xFFE0F7FA),
                            iconColor: Color(0xFF00BCD4),
                            title: "Personalised Care Plan",
                            subtitle:
                                "Get a wellness plan tailored to your pet’s age, lifestyle, and health needs.",
                          ),

                          const Spacer(),

                          // Buttons
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                final json = const JsonEncoder.withIndent('  ')
                                    .convert(
                                      state.assessmentList
                                          .map((e) => e.toJson())
                                          .toList(),
                                    );

                                print("Assessment List:\n$json");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AssessmentFlow(
                                      assessments: state.assessmentList,
                                      petId: petId.toString(),
                                      petName: petName.toString(),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B76E1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Start Assessment",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const MainDashboard(),
                                //   ),
                                // );
                              },
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                  color: Color(0xFF3B76E1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
