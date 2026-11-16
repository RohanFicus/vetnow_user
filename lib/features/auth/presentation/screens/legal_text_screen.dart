import 'package:flutter/material.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';

import '../components/app_bar.dart';

class LegalTextScreen extends StatelessWidget {
  final String title;
  const LegalTextScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: buildSimpleAppBar(context, title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.appBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildSections(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    final lowerTitle = title.toLowerCase();

    if (lowerTitle.contains("medical") || lowerTitle.contains("telehealth") || lowerTitle.contains("consent")) {
      return [
        _buildSection(
          context,
          "1. Telehealth Services & Scope",
          "VetNow provides a platform connecting pet owners with licensed veterinarians for remote triage, consultations, and health advice. Telehealth is conducted via video/chat and relies on information and visual media provided by the pet owner.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "2. Emergency Care Limitation",
          "VetNow telehealth is NOT for life-threatening medical emergencies. If your pet suffers from severe hemorrhage, acute respiratory distress, severe trauma, poisoning, or collapse, seek in-person emergency veterinary care immediately.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "3. Veterinarian-Client-Patient Relationship (VCPR)",
          "A virtual consultation may establish a digital VCPR where permitted by law. In certain jurisdictions, physical examination may be required for specific diagnoses or prescription issuance.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "4. Medical Records & Health Data",
          "By using VetNow, you consent to store your pet's medical history, symptoms, diagnostic images, and consultation notes securely on our platform, and share them with consulting veterinarians for clinical evaluation.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "5. Prescriptions and Treatment Plans",
          "Prescription medications and clinical advice are issued at the sole professional judgment of the consulting veterinarian in strict compliance with applicable regulatory frameworks.",
        ),
      ];
    } else if (lowerTitle.contains("privacy")) {
      return [
        _buildSection(
          context,
          "1. Information We Collect",
          "We collect personal information (name, contact information, address) and pet health details (species, breed, medical history, vaccination records, images) to provide and improve our veterinary services.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "2. How We Use Your Data",
          "Your data is used to schedule appointments, facilitate secure video consultations with veterinarians, maintain health records, process payments, and provide timely reminders.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "3. Data Sharing & Security",
          "We do not sell your personal or medical data. Data is only shared with authorized veterinary professionals involved in your pet's care and secured using industry-standard encryption protocols.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "4. Your Rights & Account Deletion",
          "You have the right to access, update, or permanently delete your account and associated pet medical records at any time through the app settings.",
        ),
      ];
    } else {
      // Default: Terms of Service
      return [
        _buildSection(
          context,
          "1. Acceptance of Terms",
          "By accessing and using the VetNow mobile application, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use our services.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "2. Use of Services",
          "VetNow provides a platform to:\n• Book veterinary appointments\n• Manage pet profiles and medical health records\n• Track pet activities and wellness milestones\n• Access veterinary consultation and triage support\n\nYou agree to use our services only for lawful purposes and in accordance with these terms.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "3. User Accounts",
          "When you create an account with us, you must provide accurate, complete, and current information. You are responsible for safeguarding your account credentials and for all activities that occur under your account.",
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          "4. Medical Disclaimer",
          "VetNow provides a technology platform facilitating virtual communication between pet parents and veterinary professionals. Telehealth guidance does not replace regular hands-on clinical examinations.",
        ),
      ];
    }
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: context.appText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: context.appMutedText,
            height: 1.5,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
