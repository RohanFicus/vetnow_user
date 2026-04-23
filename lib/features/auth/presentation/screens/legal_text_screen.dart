import 'package:flutter/material.dart';

import '../components/app_bar.dart';

class LegalTextScreen extends StatelessWidget {
  final String title;
  const LegalTextScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: buildSimpleAppBar(context, title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                "1. Acceptance of Terms",
                "By accessing and using the VetNow mobile application, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use our services.",
              ),
              const SizedBox(height: 20),
              _buildSection(
                "2. Use of Services",
                "VetNow provides a platform to:\n\u2022 Book veterinary appointments\n\u2022 Manage pet pet_profile and health records\n\u2022 Track pet activities and milestones\n\u2022 Access veterinary information and resources\n\nYou agree to use our services only for lawful purposes and in accordance with these terms.",
              ),
              const SizedBox(height: 20),
              _buildSection(
                "3. User Accounts",
                "When you create an account with us, you must provide accurate, complete, and current information. Failure to do so constitutes a breach of the Terms. You are responsible for safeguarding your account and for all activities that occur under your account.",
              ),
              const SizedBox(height: 20),
              _buildSection(
                "4. Medical Disclaimer",
                "VetNow is a platform that facilitates connection. We do not provide medical advice directly through the app without consultation.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: Colors.grey.shade600,
            height: 1.5,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
