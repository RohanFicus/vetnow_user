import 'package:flutter/material.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/models/pet_profile_1_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/owner_profile_entity.dart';

enum AppStartDestination { login, home, userProfile, petProfile }

class SplashViewModel extends ChangeNotifier {
  final SecureStorageService _storageService;
  AppStartDestination? _destination;

  AppStartDestination? get destination => _destination;

  SplashViewModel(this._storageService);

  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));

    final token = await _storageService.getToken();
    final profileJson = await _storageService.getCustomerProfileJson();
    final petProfileJson = await _storageService.getPetProfileJson();

    final isLoggedIn = token != null && token.isNotEmpty;

    OwnerProfileEntity? profile;
    PetProfileStep1? petProfile;

    if (profileJson != null) {
      profile = OwnerProfileEntity.fromJson(profileJson);
    }

    if (petProfileJson != null) {
      petProfile = PetProfileStep1.fromJson(petProfileJson);
    }

    print("isLoggedIn $isLoggedIn ${profile?.email}");

    if (isLoggedIn && profile?.email?.isNotEmpty == true) {
      _destination = AppStartDestination.home;
    } else if (isLoggedIn &&
        profile?.email == null &&
        petProfile?.name == null) {
      _destination = AppStartDestination.petProfile;
    } else if (isLoggedIn && profile?.email == null) {
      _destination = AppStartDestination.userProfile;
    } else {
      _destination = AppStartDestination.login;
    }

    notifyListeners();
  }
}
