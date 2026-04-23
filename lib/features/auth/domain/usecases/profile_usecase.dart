import 'package:file_picker/file_picker.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/complete_profile_response.dart';
import 'package:vetnow_user/features/auth/data/models/edit_profile_request_model.dart';
import 'package:vetnow_user/features/auth/data/models/pet_profile_1_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_1_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_2_entity.dart';
import 'package:vetnow_user/features/auth/domain/repository/profile_repository.dart';

class ProfileUseCase {
  final ProfileRepository repository;

  ProfileUseCase(this.repository);

  Future<List<SpeciesModel>> callSpecies() {
    return repository.getSpecies();
  }

  Future<List<BreedsModel>> callBreed({required String speciesId}) {
    return repository.getBreeds(speciesId: speciesId);
  }

  Future<List<VaccineModel>> getVaccineList({required String speciesId}) {
    return repository.getVaccineList(speciesId: speciesId);
  }

  Future<PetProfileStep1> createPetStep1({
    required PetProfileStep1Entity petProfileStep1Entity,
  }) {
    return repository.createPetStep1(
      petProfileStep1Entity: petProfileStep1Entity,
    );
  }

  Future<PetProfileStep1> createPetStep2({
    required String petId,
    required PetProfileStep2Entity? petProfileStep2Entity,
  }) {
    return repository.createPetStep2(
      petId: petId,
      petProfileStep2Entity: petProfileStep2Entity,
    );
  }

  Future<PetProfileStep1> updatePetStep1({
    required PetProfileStep1Entity? petProfileStep1Entity,
    required String petId,
  }) {
    return repository.updatePetStep1(
      petProfileStep1Entity: petProfileStep1Entity,
      petId: petId,
    );
  }

  Future<PetProfileStep1?> updatePetStep2({
    required PetProfileStep2Entity petProfileStep2Entity,
    required String petId,
  }) {
    return repository.updatePetStep2(
      petProfileStep2Entity: petProfileStep2Entity,
      petId: petId,
    );
  }

  Future<CompleteProfileResponse> completePetProfile({
    required String documentType,
    required String petVaccinations,
    required PlatformFile? files,
    required String petId,
  }) {
    return repository.completePetProfile(
      documentType: documentType,
      petVaccinations: petVaccinations,
      files: files,
      petId: petId,
    );
  }

  Future<CompleteProfileResponse> updatePetProfile({
    required String documentType,
    required String petVaccinations,
    required PlatformFile? files,
    required String petId,
  }) {
    return repository.updatePetProfile(
      documentType: documentType,
      petVaccinations: petVaccinations,
      files: files,
      petId: petId,
    );
  }

  Future<CompleteProfileResponse> skipPetProfile({required String petId}) {
    return repository.skipPetProfile(petId: petId);
  }

  Future<CompleteProfileResponse> editProfile({
    required String? petId,
    required EditProfileRequest editRequest,
  }) {
    return repository.editProfile(petId: petId, editRequest: editRequest);
  }
}
