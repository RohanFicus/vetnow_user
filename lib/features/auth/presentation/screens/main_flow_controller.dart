import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';

import './add_pet_wizard_screen.dart';
import './dashboard_screen.dart';
import './empty_pets_screen.dart';
import './pet_profile_success_screen.dart';

class MainFlowController extends StatefulWidget {
  final int initialFlowIndex;

  const MainFlowController({
    super.key,
    this.initialFlowIndex = 0,
  });

  @override
  State<MainFlowController> createState() => _MainFlowControllerState();
}

class _MainFlowControllerState extends State<MainFlowController> {
  late int _currentFlowIndex;
  SpeciesModel? _selectedSpeciesId;
  final SecureStorageService _storageService = SecureStorageService();
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _currentFlowIndex = widget.initialFlowIndex;
    if (_currentFlowIndex == 0) {
      _storageService.saveOnboardingStage('ADD_PET');
    } else if (_currentFlowIndex == 2) {
      _storageService.saveOnboardingStage('PET_SUCCESS');
    }
  }

  void startAddingPet(SpeciesModel? speciesModel) => setState(() {
    _selectedSpeciesId = speciesModel;
    _currentFlowIndex = 1;
  });

  void finishAddingPet() {
    _storageService.saveOnboardingStage('PET_SUCCESS');
    setState(() => _currentFlowIndex = 2);
  }

  void onAddAnotherPet() {
    _storageService.saveOnboardingStage('ADD_PET');
    setState(() {
      _selectedSpeciesId = null;
      _currentFlowIndex = 0;
    });
  }

  void reset() => setState(() {
    _selectedSpeciesId = null;
    _currentFlowIndex = 0;
  });

  Future<void> goToDashBoard() async {
    await _storageService.saveOnboardingStage('COMPLETED');
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainDashboard()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentFlowIndex == 2) {
          final now = DateTime.now();
          if (_lastBackPressTime == null ||
              now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
            _lastBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Press back again to exit"),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            SystemNavigator.pop();
          }
        } else if (_currentFlowIndex == 0) {
          SystemNavigator.pop();
        }
      },
      child: _buildCurrentFlow(),
    );
  }

  Widget _buildCurrentFlow() {
    switch (_currentFlowIndex) {
      case 0:
        return EmptyPetsScreen(onAddPet: startAddingPet);
      case 1:
        return AddPetWizardScreen(
          existing: false,
          onComplete: finishAddingPet,
          onBack: reset,
          speciesModel: _selectedSpeciesId,
        );
      case 2:
        return PetProfileSuccessScreen(
          onAddAnother: onAddAnotherPet,
          onDashboard: goToDashBoard,
        );
      default:
        return const SizedBox();
    }
  }
}
