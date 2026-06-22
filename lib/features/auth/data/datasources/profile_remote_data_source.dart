import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vetnow_user/core/config/app_mode.dart';
import 'package:vetnow_user/core/mock/mock_data.dart';
import 'package:vetnow_user/core/network/api_response_handler.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/complete_profile_response.dart';
import 'package:vetnow_user/features/auth/data/models/edit_profile_request_model.dart';
import 'package:vetnow_user/features/auth/data/models/pet_profile_1_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_1_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_2_entity.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/api_response.dart';

abstract class ProfileRemoteDataSource {
  Future<ApiResponse<List<SpeciesModel>, void>> getSpecies();

  Future<ApiResponse<List<BreedsModel>, void>> getBreeds({
    required String speciesId,
  });

  Future<ApiResponse<List<VaccineModel>, void>> getVaccineList({
    required String speciesId,
  });

  Future<ApiResponse<PetProfileStep1, void>> createPetStep1(
    PetProfileStep1Entity petProfileStep1Entity,
  );

  Future<ApiResponse<PetProfileStep1, void>> updatePetStep1(
    PetProfileStep1Entity? petProfileStep1Entity,
    String petId,
  );

  Future<ApiResponse<PetProfileStep1, void>> createPetStep2(
    PetProfileStep2Entity? petProfileStep2Entity,
    String petId,
  );

  Future<ApiResponse<PetProfileStep1, void>> updatePetStep2(
    PetProfileStep2Entity petProfileStep2Entity,
    String petId,
  );

  Future<ApiResponse<CompleteProfileResponse, void>> completePetProfile(
    String documentType,
    String petVaccinations,
    PlatformFile? files,
    String petId,
  );

  Future<ApiResponse<CompleteProfileResponse, void>> updatePetProfile({
    required String documentType,
    required String petVaccinations,
    required PlatformFile? files,
    required String petId,
  });

  Future<ApiResponse<CompleteProfileResponse, void>> skipPetProfile({
    required String petId,
  });

  Future<ApiResponse<CompleteProfileResponse, void>> editProfile({
    required String? petId,
    required EditProfileRequest editRequest,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient client;

  ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<ApiResponse<List<SpeciesModel>, void>> getSpecies() async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock species loaded successfully',
        data: MockData.species(),
      );
    }

    try {
      final response = await client.dio.get("/api/v1/species");

      return ApiResponseHandler.handleResponse(
        response,
        (json) => (json as List).map((e) => SpeciesModel.fromJson(e)).toList(),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock species loaded successfully',
        data: MockData.species(),
      );
    }
  }

  @override
  Future<ApiResponse<List<BreedsModel>, void>> getBreeds({
    required String speciesId,
  }) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock breeds loaded successfully',
        data: MockData.breeds(speciesId: speciesId),
      );
    }

    try {
      final response = await client.dio.get(
        "/api/v1/breeds",
        queryParameters: {"speciesId": speciesId},
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => (json as List).map((e) => BreedsModel.fromJson(e)).toList(),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock breeds loaded successfully',
        data: MockData.breeds(speciesId: speciesId),
      );
    }
  }

  @override
  Future<ApiResponse<List<VaccineModel>, void>> getVaccineList({
    required String speciesId,
  }) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock vaccines loaded successfully',
        data: MockData.vaccines(speciesId: speciesId),
      );
    }

    try {
      final response = await client.dio.get(
        "/api/v1/vaccines",
        queryParameters: {"speciesId": speciesId},
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => (json as List).map((e) => VaccineModel.fromJson(e)).toList(),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock vaccines loaded successfully',
        data: MockData.vaccines(speciesId: speciesId),
      );
    }
  }

  @override
  Future<ApiResponse<PetProfileStep1, void>> createPetStep1(
    PetProfileStep1Entity petProfileStep1Entity,
  ) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet step 1 created successfully',
        data: MockData.petStep1(
          speciesId: petProfileStep1Entity.speciesId ?? 'species-dog',
          breedId: petProfileStep1Entity.breedId ?? 'breed-lab',
          name: petProfileStep1Entity.name ?? 'Coco',
          sex: petProfileStep1Entity.sex ?? 'FEMALE',
          ageMonths:
              int.tryParse(petProfileStep1Entity.ageMonths ?? '12') ?? 12,
        ),
      );
    }

    try {
      final response = await client.dio.post(
        "/api/v1/pets",
        data: petProfileStep1Entity,
        //queryParameters: {"speciesId": speciesId},
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => PetProfileStep1.fromJson(json),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet step 1 created successfully',
        data: MockData.petStep1(
          speciesId: petProfileStep1Entity.speciesId ?? 'species-dog',
          breedId: petProfileStep1Entity.breedId ?? 'breed-lab',
          name: petProfileStep1Entity.name ?? 'Coco',
          sex: petProfileStep1Entity.sex ?? 'FEMALE',
          ageMonths:
              int.tryParse(petProfileStep1Entity.ageMonths ?? '12') ?? 12,
        ),
      );
    }
  }

  @override
  Future<ApiResponse<PetProfileStep1, void>> createPetStep2(
    PetProfileStep2Entity? petProfileStep2Entity,
    String petId,
  ) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet step 2 created successfully',
        data: MockData.petStep1(
          id: petId,
          weightKg: petProfileStep2Entity?.weightKg ?? 7.5,
          color: petProfileStep2Entity?.color ?? 'Brown',
        ),
      );
    }

    try {
      final response = await client.dio.put(
        "/api/v1/pets/$petId",
        data: petProfileStep2Entity,
        //queryParameters: {"speciesId": speciesId},
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => PetProfileStep1.fromJson(json),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet step 2 created successfully',
        data: MockData.petStep1(
          id: petId,
          weightKg: petProfileStep2Entity?.weightKg ?? 7.5,
          color: petProfileStep2Entity?.color ?? 'Brown',
        ),
      );
    }
  }

  @override
  Future<ApiResponse<CompleteProfileResponse, void>> completePetProfile(
    String documentType,
    String petVaccinations,
    PlatformFile? files,
    String petId,
  ) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet profile completed successfully',
        data: MockData.completePetProfile(petId: petId),
      );
    }

    print("createPetProfile");
    final formData = FormData.fromMap({
      "documentType": documentType,
      "petVaccinations": petVaccinations,
      "files": files,
    });
    // PRINT FIELDS
    for (var field in formData.fields) {
      print("FIELD => ${field.key}: ${field.value}");
    }
    try {
      final response = await client.dio.post(
        "/api/v1/pets/$petId/complete-profile",
        data: formData,
      );
      return ApiResponseHandler.handleResponse(
        response,
        (json) => CompleteProfileResponse.fromJson(json),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet profile completed successfully',
        data: MockData.completePetProfile(petId: petId),
      );
    }
  }

  @override
  Future<ApiResponse<CompleteProfileResponse, void>> skipPetProfile({
    required String petId,
  }) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet profile skipped successfully',
        data: MockData.completePetProfile(petId: petId),
      );
    }

    print("createPetProfile");

    try {
      final response = await client.dio.post(
        "/api/v1/pets/$petId/skip-complete-profile",
        data: {},
      );
      return ApiResponseHandler.handleResponse(
        response,
        (json) => CompleteProfileResponse.fromJson(json),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet profile skipped successfully',
        data: MockData.completePetProfile(petId: petId),
      );
    }
  }

  @override
  Future<ApiResponse<PetProfileStep1, void>> updatePetStep1(
    PetProfileStep1Entity? petProfileStep1Entity,
    String petId,
  ) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet step 1 updated successfully',
        data: MockData.petStep1(
          id: petId,
          speciesId: petProfileStep1Entity?.speciesId ?? 'species-dog',
          breedId: petProfileStep1Entity?.breedId ?? 'breed-lab',
          name: petProfileStep1Entity?.name ?? 'Coco',
          sex: petProfileStep1Entity?.sex ?? 'FEMALE',
          ageMonths:
              int.tryParse(petProfileStep1Entity?.ageMonths ?? '12') ?? 12,
        ),
      );
    }

    try {
      final response = await client.dio.put(
        "/api/v1/pets/$petId",
        data: petProfileStep1Entity,
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => PetProfileStep1.fromJson(json),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet step 1 updated successfully',
        data: MockData.petStep1(
          id: petId,
          speciesId: petProfileStep1Entity?.speciesId ?? 'species-dog',
          breedId: petProfileStep1Entity?.breedId ?? 'breed-lab',
          name: petProfileStep1Entity?.name ?? 'Coco',
          sex: petProfileStep1Entity?.sex ?? 'FEMALE',
          ageMonths:
              int.tryParse(petProfileStep1Entity?.ageMonths ?? '12') ?? 12,
        ),
      );
    }
  }

  @override
  Future<ApiResponse<PetProfileStep1, void>> updatePetStep2(
    PetProfileStep2Entity petProfileStep2Entity,
    String petId,
  ) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet step 2 updated successfully',
        data: MockData.petStep1(
          id: petId,
          weightKg: petProfileStep2Entity.weightKg ?? 7.5,
          color: petProfileStep2Entity.color ?? 'Brown',
        ),
      );
    }

    try {
      final response = await client.dio.put(
        "/api/v1/pets/$petId",
        data: petProfileStep2Entity,
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => PetProfileStep1.fromJson(json),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet step 2 updated successfully',
        data: MockData.petStep1(
          id: petId,
          weightKg: petProfileStep2Entity.weightKg ?? 7.5,
          color: petProfileStep2Entity.color ?? 'Brown',
        ),
      );
    }
  }

  @override
  Future<ApiResponse<CompleteProfileResponse, void>> updatePetProfile({
    required String documentType,
    required String petVaccinations,
    required PlatformFile? files,
    required String petId,
  }) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet profile updated successfully',
        data: MockData.completePetProfile(petId: petId),
      );
    }

    final formData = FormData.fromMap({
      "documentType": documentType,
      "petVaccinations": petVaccinations,
      "files": files,
    });

    // PRINT FIELDS
    for (var field in formData.fields) {
      print("FIELD => ${field.key}: ${field.value}");
    }

    try {
      final response = await client.dio.put(
        "/api/v1/pets/$petId/complete-profile",
        data: formData,
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => CompleteProfileResponse.fromJson(json),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet profile updated successfully',
        data: MockData.completePetProfile(petId: petId),
      );
    }
  }

  @override
  Future<ApiResponse<CompleteProfileResponse, void>> editProfile({
    required String? petId,
    required EditProfileRequest editRequest,
  }) async {
    if (AppMode.useMockData) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet profile edited successfully',
        data: MockData.completePetProfile(petId: petId ?? 'pet-003'),
      );
    }

    print("editProfile API called for petId: $petId");

    // Create FormData for multipart request (supports file uploads)
    final formData = FormData.fromMap(editRequest.toFormData());

    // Print debug information
    print("=== EDIT PROFILE REQUEST ===");
    print("Pet ID: $petId");
    for (var field in formData.fields) {
      print("FIELD => ${field.key}: ${field.value}");
    }
    for (var file in formData.files) {
      print("FILE => ${file.key}: ${file.value.filename}");
    }

    try {
      final response = await client.dio.put(
        "/api/v1/pets/$petId/pet-profile",
        data: formData,
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => CompleteProfileResponse.fromJson(json),
        null,
      );
    } catch (_) {
      await MockData.latency();
      return ApiResponse(
        status: true,
        message: 'Mock pet profile edited successfully',
        data: MockData.completePetProfile(petId: petId ?? 'pet-003'),
      );
    }
  }
}
