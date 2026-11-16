import 'package:flutter/material.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/domain/entities/owner_profile_entity.dart';

enum AppStartDestination { login, consent, createProfile, addPet, petSuccess, home }

class SplashViewModel extends ChangeNotifier {
  final SecureStorageService _storageService;
  AppStartDestination? _destination;

  AppStartDestination? get destination => _destination;

  SplashViewModel(this._storageService);

  Future<void> initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final token = await _storageService.getToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    if (!isLoggedIn) {
      _destination = AppStartDestination.login;
      notifyListeners();
      return;
    }

    final stage = await _storageService.getOnboardingStage();
    final profileJson = await _storageService.getCustomerProfileJson();
    final dashboardJson = await _storageService.getDashboardDataJson();

    OwnerProfileEntity? profile;
    if (profileJson != null) {
      try {
        profile = OwnerProfileEntity.fromJson(profileJson);
      } catch (e) {
        // ignore JSON parse errors
      }
    }

    final bool hasProfileName = profile?.firstName != null && profile!.firstName!.trim().isNotEmpty;
    final bool hasProfileEmail = profile?.email != null && profile!.email!.trim().isNotEmpty;
    final bool isProfileComplete = hasProfileName && hasProfileEmail;

    final List? pets = dashboardJson?['pets'] as List?;
    final bool hasPets = pets != null && pets.isNotEmpty;

    print("SplashViewModel Stage: $stage, isProfileComplete: $isProfileComplete, hasPets: $hasPets");

    if (stage == 'CONSENT') {
      _destination = AppStartDestination.consent;
    } else if (stage == 'CREATE_PROFILE') {
      _destination = AppStartDestination.createProfile;
    } else if (stage == 'ADD_PET') {
      _destination = AppStartDestination.addPet;
    } else if (stage == 'PET_SUCCESS') {
      _destination = AppStartDestination.petSuccess;
    } else if (stage == 'COMPLETED') {
      _destination = AppStartDestination.home;
    } else if (hasPets) {
      _destination = AppStartDestination.home;
    } else if (isProfileComplete) {
      _destination = AppStartDestination.addPet;
    } else {
      _destination = AppStartDestination.consent;
    }

    notifyListeners();
  }
}

