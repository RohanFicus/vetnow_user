import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetnow_user/core/localization/app_strings.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/core/theme/app_color.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/presentation/components/AppButton.dart';
import 'package:vetnow_user/features/auth/presentation/screens/create_profile_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/legal_text_screen.dart';

class MedicalConsentScreen extends StatefulWidget {
  const MedicalConsentScreen({super.key});

  @override
  State<MedicalConsentScreen> createState() => _MedicalConsentScreenState();
}

class _MedicalConsentScreenState extends State<MedicalConsentScreen> {
  bool _isConsentAccepted = false;
  final SecureStorageService _storageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    _storageService.saveOnboardingStage('CONSENT');
  }

  Future<void> _proceedToProfile() async {
    await _storageService.saveOnboardingStage('CREATE_PROFILE');
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CreateProfileScreen()),
    );
  }

  void _openLegalDocument(String title) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LegalTextScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
                onPressed: () => SystemNavigator.pop(),
              ),
            ),
          ),
          title: Text(
            context.strings.medicalConsent,
            style: TextStyle(
              color: context.appText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Header Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.appSoftPrimary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.health_and_safety_outlined,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.strings.telehealthNoticeTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context.appText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.strings.telehealthNoticeSubtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.appMutedText,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Section 1: Emergency Disclaimer
                    _buildConsentTile(
                      context,
                      icon: Icons.warning_amber_rounded,
                      iconColor: Colors.red.shade700,
                      iconBg: Colors.red.withValues(alpha: 0.1),
                      title: context.strings.emergencyDisclaimerTitle,
                      description: context.strings.emergencyDisclaimerText,
                    ),
                    const SizedBox(height: 12),

                    // Section 2: Virtual Consultation Scope
                    _buildConsentTile(
                      context,
                      icon: Icons.video_call_outlined,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primary.withValues(alpha: 0.1),
                      title: context.strings.virtualCareScopeTitle,
                      description: context.strings.virtualCareScopeText,
                    ),
                    const SizedBox(height: 12),

                    // Section 3: Health Records & Data Privacy
                    _buildConsentTile(
                      context,
                      icon: Icons.folder_shared_outlined,
                      iconColor: Colors.teal.shade700,
                      iconBg: Colors.teal.withValues(alpha: 0.1),
                      title: context.strings.recordsPrivacyTitle,
                      description: context.strings.recordsPrivacyText,
                    ),
                    const SizedBox(height: 12),

                    // Section 4: Prescriptions & Veterinary Judgment
                    _buildConsentTile(
                      context,
                      icon: Icons.medication_outlined,
                      iconColor: Colors.purple.shade700,
                      iconBg: Colors.purple.withValues(alpha: 0.1),
                      title: context.strings.prescriptionsTitle,
                      description: context.strings.prescriptionsText,
                    ),
                    const SizedBox(height: 16),

                    // Legal Links Strip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: context.appSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.appBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.strings.fullLegalDocuments,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: context.appMutedText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTextLink(context.strings.termsOfService, () {
                                _openLegalDocument(context.strings.termsOfService);
                              }),
                              _buildTextLink(context.strings.privacyPolicy, () {
                                _openLegalDocument(context.strings.privacyPolicy);
                              }),
                              _buildTextLink(context.strings.telehealthPolicyLink, () {
                                _openLegalDocument("Telehealth Consent");
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Bottom Action Area
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: context.appSurface,
                border: Border(top: BorderSide(color: context.appBorder)),
                boxShadow: [
                  BoxShadow(
                    color: context.appShadow,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Consent Checkbox Row
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isConsentAccepted = !_isConsentAccepted;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _isConsentAccepted,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _isConsentAccepted = val ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            context.strings.consentCheckboxText,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              color: context.appText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Accept Button
                  AppButton(
                    text: context.strings.iAgreeAndContinue,
                    color: _isConsentAccepted
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    textColor: _isConsentAccepted
                        ? Colors.white
                        : Colors.grey.shade600,
                    onPressed: _isConsentAccepted ? _proceedToProfile : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildConsentTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.appText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appMutedText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
