import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetnow_user/core/theme/app_color.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/core/utils/pet_utils.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/presentation/screens/add_pet_wizard_screen.dart';
import '../components/AppButton.dart';

class PetProfileDetailScreen extends StatelessWidget {
  final Pets pet;

  const PetProfileDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final speciesImg = PetUtils.getSpeciesImage(pet.profile?.speciesName);

    return Scaffold(
      backgroundColor: context.appBackground,
      body: Stack(
        children: [
          // 1. HERO BACKGROUND
          _buildHeroBackground(context, speciesImg),

          // 2. SCROLLABLE CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 180, 24, 100),
              child: Column(
                children: [
                  _buildMainProfileCard(context),
                  const SizedBox(height: 20),
                  if (pet.latestAssessment != null) ...[
                    _buildLatestAssessmentCard(context),
                    const SizedBox(height: 20),
                  ],
                  _buildMedicalPassport(context),
                ],
              ),
            ),
          ),

          // 3. BACK BUTTON (positioned inside SafeArea)
          Positioned(
            top: 50,
            left: 20,
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

          // 4. FLOATING EDIT BUTTON
          _buildBottomAction(context),
        ],
      ),
    );
  }

  Widget _buildHeroBackground(BuildContext context, String imageUrl) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  context.appBackground,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: context.appShadow,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            pet.profile?.name ?? 'Unknown',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: context.appText,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(
                pet.profile?.speciesName ?? "Species",
                const Color(0xFF0061CE),
              ),
              const SizedBox(width: 8),
              _buildBadge(
                pet.profile?.breedName ?? "Unknown Breed",
                Colors.blueGrey,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // GRID STATS
          Row(
            children: [
              _buildStatBox(
                context,
                Icons.pets,
                "Age",
                "${pet.profile?.ageMonths} Months",
              ),
              const SizedBox(width: 16),
              _buildStatBox(
                context,
                Icons.search,
                "Gender",
                pet.profile?.sex ?? "N/A",
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatBox(
                context,
                Icons.monitor_weight,
                "Weight",
                "${pet.profile?.weightKg} kg",
              ),
              const SizedBox(width: 16),
              _buildStatBox(
                context,
                Icons.palette,
                "Color",
                pet.profile?.color ?? "N/A",
              ),
            ],
          ),

          const SizedBox(height: 24),
          Divider(height: 1, color: context.appBorder),
          const SizedBox(height: 24),

          // UNIQUE ID SECTION
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.appSoftPrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.qr_code, color: Color(0xFF0061CE)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UNIQUE PET ID",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: context.appMutedText,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      pet.profile?.petUniqueId ?? 'Not Assigned',
                      style: GoogleFonts.firaCode(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.appText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLatestAssessmentCard(BuildContext context) {
    final assessment = pet.latestAssessment!;
    final risk = assessment.overallRisk;

    Color riskColor;
    switch (risk?.level?.toUpperCase()) {
      case 'LOW':
        riskColor = Colors.green;
        break;
      case 'MEDIUM':
        riskColor = Colors.orange;
        break;
      case 'HIGH':
        riskColor = Colors.red;
        break;
      default:
        riskColor = Colors.grey;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: context.appBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics, color: Color(0xFF0061CE), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Latest Health Status",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.appText,
                    ),
                  ),
                ],
              ),
              if (risk?.level != null)
                _buildBadge(risk!.level!, riskColor),
            ],
          ),
          const SizedBox(height: 16),
          if (risk?.descriptionEn != null)
            Text(
              risk!.descriptionEn!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: context.appText,
                height: 1.5,
              ),
            ),
          const SizedBox(height: 12),
          if (assessment.warningMessage?.textEn != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: riskColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      assessment.warningMessage!.textEn!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: riskColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Score: ${assessment.totalScore ?? 0}",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.appText,
                ),
              ),
              if (assessment.assessedAt != null)
                Text(
                  "Assessed on: ${assessment.assessedAt!.split('T').first}",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: context.appMutedText,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalPassport(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: context.appBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                "Medical Details",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.appText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (pet.vaccinations == null || pet.vaccinations!.isEmpty)
            Text(
              "No vaccination records found.",
              style: TextStyle(color: context.appMutedText),
            )
          else
            ...pet.vaccinations!.map((v) => _buildVaccineTile(context, v)),
        ],
      ),
    );
  }

  Widget _buildVaccineTile(BuildContext context, dynamic vaccine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: Colors.green, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              vaccine.vaccineName ?? 'General Vaccine',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: context.appText,
              ),
            ),
          ),
          Icon(Icons.chevron_right, size: 14, color: context.appMutedText),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appSurfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.appBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF0061CE)),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: context.appMutedText,
              ),
            ),
            Text(
              value != "null" ? value : '--',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: context.appText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: AppButton(
        text: "Edit Pet Profile",
        icon: Icons.edit,
        color: context.isDarkMode ? AppColors.primary : const Color(0xFF1E293B),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPetWizardScreen(
                existing: true,
                speciesModel: SpeciesModel(
                  id: pet.profile?.speciesId,
                  code: '',
                  nameEn: pet.profile?.speciesName,
                  nameHi: '',
                  isActive: false,
                  iconUrl: '',
                ),
                pet: pet,
                onComplete: () => Navigator.pop(context),
                onBack: () => Navigator.pop(context),
              ),
            ),
          );
        },
      ),
    );
  }
}
