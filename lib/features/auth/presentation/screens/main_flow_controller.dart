import 'package:flutter/material.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';

import './add_pet_wizard_screen.dart';
import './dashboard_screen.dart';
import './empty_pets_screen.dart';
import './pet_profile_success_screen.dart';

class MainFlowController extends StatefulWidget {
  const MainFlowController({super.key});

  @override
  State<MainFlowController> createState() => _MainFlowControllerState();
}

class _MainFlowControllerState extends State<MainFlowController> {
  int _currentFlowIndex = 0;
  late SpeciesModel? _selectedSpeciesId;
  // 0 = Empty State
  // 1 = Add Pet Wizard (Form Steps)
  // 2 = Success Screen

  void startAddingPet(SpeciesModel? speciesModel) => setState(() {
    _selectedSpeciesId = speciesModel;
    _currentFlowIndex = 1;
  });

  void finishAddingPet() => setState(() => _currentFlowIndex = 2);
  void reset() => setState(() => _currentFlowIndex = 0);
  void goToDashBoard() => {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MainDashboard())),
  };

  @override
  Widget build(BuildContext context) {
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
          onAddAnother: reset,
          onDashboard: goToDashBoard,
        );
      default:
        return const SizedBox();
    }
  }
}
