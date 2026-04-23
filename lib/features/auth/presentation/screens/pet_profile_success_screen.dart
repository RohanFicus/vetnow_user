import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/repositories/profile_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/usecases/profile_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/dashboard_screen.dart';

import '../../../../core/theme/app_color.dart';
import '../components/AppButton.dart';

class PetProfileSuccessScreen extends StatelessWidget {
  final VoidCallback onAddAnother;
  final VoidCallback onDashboard;

  const PetProfileSuccessScreen({
    super.key,
    required this.onAddAnother,
    required this.onDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(
        ProfileUseCase(
          ProfileRepositoryImpl(ProfileRemoteDataSourceImpl(ApiClient()), SecureStorageService()),
        ),
        SecureStorageService(),
      )..add(ProfileCallLocally()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) => previous.petName != current.petName,
        listener: (context, state) {
          print("Step Success ${state.petName}");
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              // appBar: AppBar(
              //   elevation: 0,
              //   backgroundColor: Colors.transparent,
              //   leading: const Icon(Icons.arrow_back, color: Colors.black),
              //   title: const Text(
              //     "Pet Profile Created",
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   centerTitle: true,
              // ),
              body: Stack(
                children: [
                  _buildSuccessHeader(),
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // 2. SUCCESS ICON
                          _buildAnimatedSuccessIcon(),

                          Text(
                            "Registration Successful!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Your pet's digital passport is ready.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),

                          const SizedBox(height: 12),


                          // 3. THE DIGITAL PASSPORT CARD
                          _buildPassportCard(state),

                          const SizedBox(height: 10),

                          // 4. ACTION BUTTONS
                          _buildActionButtons(state, context),

                          const SizedBox(height: 12),
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

  Widget _buildSuccessHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 300,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDCFCE7), Color(0xFFF8FAFC)],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSuccessIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(Icons.party_mode, color: Colors.green, size: 40),
    );
  }

  Widget _buildPassportCard(ProfileState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header: Profile Image & Name
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage('https://placedog.net/400/400?id=10'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.check_circle, color: Colors.blue, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  state.petName.toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  "OFFICIAL DIGITAL RECORD",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Stat Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildStatItem(Icons.history, "AGE", "${state.petAgeInYears} Yrs"),
                const SizedBox(width: 12),
                _buildStatItem(Icons.male, "GENDER", state.petSex),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildStatItem(Icons.monitor_weight_outlined, "WEIGHT", "${state.weight} KG"),
                const SizedBox(width: 12),
                _buildStatItem(Icons.palette, "COLOR", state.color),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // QR Code Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PET ID",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.petId.isNotEmpty ? state.petId : "#PENDING",
                          style: GoogleFonts.firaCode(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        state.qrCodeFileName ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.qr_code, color: Colors.blue, size: 30),
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
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F7FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF0061CE)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ProfileState state, BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: "Go to Dashboard",
          icon: Icons.dashboard,
          color: AppColors.primary,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainDashboard()),
                  (route) => false,
            );
          },
        ),
        const SizedBox(height: 16),
        AppButton(
          text: "Add Another Pet",
          icon: Icons.add,
          color: Colors.white,
          textColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1.5),
          onPressed: onAddAnother,
        ),
      ],
    );
  }

}
