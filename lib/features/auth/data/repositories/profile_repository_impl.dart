import 'package:file_picker/file_picker.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/complete_profile_response.dart';
import 'package:vetnow_user/features/auth/data/models/edit_profile_request_model.dart';
import 'package:vetnow_user/features/auth/data/models/pet_profile_1_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_1_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_2_entity.dart';
import 'package:vetnow_user/features/auth/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final SecureStorageService storageService;

  ProfileRepositoryImpl(this.remoteDataSource, this.storageService);

  @override
  Future<List<SpeciesModel>> getSpecies() async {
    final response = await remoteDataSource.getSpecies();

    if (!response.status) {
      return [];
    }
    print("GetSpecies ${response.status}");
    final models = response.data ?? [];
    return models.toList();
  }

  @override
  Future<List<BreedsModel>> getBreeds({required String speciesId}) async {
    final response = await remoteDataSource.getBreeds(speciesId: speciesId);

    if (!response.status) {
      return [];
    }

    final models = response.data ?? [];
    return models.toList();
  }

  @override
  Future<List<VaccineModel>> getVaccineList({required String speciesId}) async {
    final response = await remoteDataSource.getVaccineList(
      speciesId: speciesId,
    );

    if (!response.status) {
      return [];
    }

    final models = response.data ?? [];
    return models.toList();
  }

  @override
  Future<PetProfileStep1> createPetStep1({
    required PetProfileStep1Entity petProfileStep1Entity,
  }) async {
    final response = await remoteDataSource.createPetStep1(
      petProfileStep1Entity,
    );

    PetProfileStep1 petProfileStep1 = response.data ?? PetProfileStep1();
    return petProfileStep1;
  }

  @override
  Future<PetProfileStep1> updatePetStep1({
    required PetProfileStep1Entity? petProfileStep1Entity,
    required String petId,
  }) async {
    final response = await remoteDataSource.updatePetStep1(
      petProfileStep1Entity,
      petId,
    );

    if (!response.status) {
      throw Exception(response.message ?? "Failed to update pet step 1");
    }

    return response.data ?? PetProfileStep1();
  }

  @override
  Future<PetProfileStep1> createPetStep2({
    required String petId,
    required PetProfileStep2Entity? petProfileStep2Entity,
  }) async {
    final response = await remoteDataSource.createPetStep2(
      petProfileStep2Entity,
      petId,
    );

    if (!response.status) {
      throw Exception(response.message ?? "Failed to create pet step 2");
    }

    return response.data ?? PetProfileStep1();
  }

  @override
  Future<PetProfileStep1> updatePetStep2({
    required PetProfileStep2Entity petProfileStep2Entity,
    required String petId,
  }) async {
    final response = await remoteDataSource.updatePetStep2(
      petProfileStep2Entity,
      petId,
    );

    if (!response.status) {
      throw Exception(response.message ?? "Failed to update pet step 2");
    }

    print("UpdatePetStep2 ${response.status}");
    return response.data ?? PetProfileStep1();
  }

  @override
  Future<CompleteProfileResponse> completePetProfile({
    required String documentType,
    required String petVaccinations,
    required PlatformFile? files,
    required String petId,
  }) async {
    final response = await remoteDataSource.completePetProfile(
      documentType,
      petVaccinations,
      files,
      petId,
    );

    CompleteProfileResponse completeProfileResponse =
        response.data ?? CompleteProfileResponse();
    return completeProfileResponse;
  }

  @override
  Future<CompleteProfileResponse> updatePetProfile({
    required String documentType,
    required String petVaccinations,
    required PlatformFile? files,
    required String petId,
  }) async {
    final response = await remoteDataSource.updatePetProfile(
      documentType: documentType,
      petVaccinations: petVaccinations,
      files: files,
      petId: petId,
    );

    if (!response.status) {
      throw Exception(response.message ?? "Failed to update pet profile");
    }

    await storageService.savePetProfileJson(
      response.data?.toJson() ?? CompleteProfileResponse().toJson(),
    );
    return response.data ?? CompleteProfileResponse();
  }

  @override
  Future<CompleteProfileResponse> skipPetProfile({
    required String petId,
  }) async {
    final response = await remoteDataSource.skipPetProfile(petId: petId);

    await storageService.savePetProfileJson(
      response.data?.toJson() ?? CompleteProfileResponse().toJson(),
    );
    return response.data ?? CompleteProfileResponse();
  }

  @override
  Future<CompleteProfileResponse> editProfile({
    required String? petId,
    required EditProfileRequest editRequest,
  }) async {
    final response = await remoteDataSource.editProfile(
      petId: petId,
      editRequest: editRequest,
    );

    await storageService.savePetProfileJson(
      response.data?.toJson() ?? CompleteProfileResponse().toJson(),
    );
    return response.data ?? CompleteProfileResponse();
  }
}
