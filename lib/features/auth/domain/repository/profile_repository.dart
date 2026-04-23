import 'package:file_picker/file_picker.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/complete_profile_response.dart';
import 'package:vetnow_user/features/auth/data/models/edit_profile_request_model.dart';
import 'package:vetnow_user/features/auth/data/models/pet_profile_1_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_1_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_2_entity.dart';

abstract class ProfileRepository {
  Future<List<SpeciesModel>> getSpecies();

  Future<List<BreedsModel>> getBreeds({required String speciesId});

  Future<List<VaccineModel>> getVaccineList({required String speciesId});

  Future<PetProfileStep1> createPetStep1({
    required PetProfileStep1Entity petProfileStep1Entity,
  });

  Future<PetProfileStep1> updatePetStep1({
    required PetProfileStep1Entity? petProfileStep1Entity,
    required String petId,
  });

  Future<PetProfileStep1> createPetStep2({
    required PetProfileStep2Entity? petProfileStep2Entity,
    required String petId,
  });

  Future<PetProfileStep1> updatePetStep2({
    required PetProfileStep2Entity petProfileStep2Entity,
    required String petId,
  });

  Future<CompleteProfileResponse> completePetProfile({
    required String documentType,
    required String petVaccinations,
    required PlatformFile? files,
    required String petId,
  });

  Future<CompleteProfileResponse> updatePetProfile({
    required String documentType,
    required String petVaccinations,
    required PlatformFile? files,
    required String petId,
  });

  Future<CompleteProfileResponse> skipPetProfile({required String petId});

  Future<CompleteProfileResponse> editProfile({
    required String? petId,
    required EditProfileRequest editRequest,
  });
}
