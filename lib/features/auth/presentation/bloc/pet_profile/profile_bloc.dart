import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/network/api_exception.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/complete_profile_response.dart';
import 'package:vetnow_user/features/auth/data/models/edit_profile_request_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_1_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/pet_profile_2_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/vaccine_entity.dart';
import 'package:vetnow_user/features/auth/domain/usecases/profile_usecase.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUseCase profileUseCase;
  final SecureStorageService storageService;
  final String? petId; // Add petId for edit mode

  ProfileBloc(this.profileUseCase, this.storageService, {this.petId})
    : super(ProfileState.initial()) {
    /// ---------------- STEP 1 ----------------
    on<SpeciesCall>(_onSpeciesCall);
    on<BreedsCall>(_onBreedsCall);
    on<VaccineCall>(_onVaccineCall);

    on<SpeciesSelected>(_onSpeciesSelected);
    on<BreedsSelected>(_onBreedsSelected);
    on<OtherBreedChanged>(_onOtherBreedChanged);
    on<BreedReset>(_onBreedReset);

    on<PetNameChanged>((e, emit) => emit(state.copyWith(petName: e.name)));
    on<PetIdChanged>((e, emit) => emit(state.copyWith(petId: e.id)));
    on<PetBirthdayChanged>(_onPetBirthdayChanged);
    on<PetAgeChanged>((e, emit) => emit(state.copyWith(petAgeInYears: e.age)));
    on<PetGenderChanged>(
      (e, emit) => emit(
        state.copyWith(
          petSex: e.sex,
          milkingStatus: false,
          pregnancyStatus: false,
          petSpayed: false,
          petNeutered: false,
        ),
      ),
    );
    on<PetSpayedChanged>(
      (e, emit) =>
          emit(state.copyWith(petSpayed: e.spayed, petNeutered: false)),
    );
    on<PetNeuteredChanged>(
      (e, emit) =>
          emit(state.copyWith(petNeutered: e.petNeutered, petSpayed: false)),
    );
    on<MilkingStatusChanged>(
      (e, emit) => emit(state.copyWith(milkingStatus: e.milkingStatus)),
    );
    on<PregnancyStatusChanged>(
      (e, emit) => emit(state.copyWith(pregnancyStatus: e.pregnancyStatus)),
    );
    on<PetSpeciesChanged>(
      (e, emit) => emit(state.copyWith(spiecesId: e.speciesId)),
    );

    on<Step1Submit>(_onStep1Submit);

    /// ---------------- STEP 2 ----------------
    on<PetWeightChanged>((e, emit) => emit(state.copyWith(weight: e.weight)));
    on<PetColorChanged>((e, emit) => emit(state.copyWith(color: e.color)));
    on<Step2Submit>(_onStep2Submit);

    /// ---------------- STEP 3 ----------------
    on<VaccineSelected>(_onVaccineSelected);
    on<VaccineDateChanged>(_onVaccineDateChanged);
    on<VaccineStatusChanged>(_onVaccineStatusChanged);

    on<FileSelected>(
      (e, emit) => emit(state.copyWith(medicalFile: e.medicalFile)),
    );
    on<FileRemoved>((e, emit) => emit(state.copyWith(medicalFile: null)));

    on<Step3Submit>(_onStep3Submit);
    on<SkipSubmit>(_onSkipSubmit);
    on<EditProfileSubmitted>(_onEditProfileSubmitted);

    /// ---------------- LOCAL PROFILE ----------------
    on<ProfileCallLocally>(_onProfileCallLocally);
  }

  /// ============================================================
  /// STEP 1 API
  /// ============================================================

  Future<void> _onStep1Submit(
    Step1Submit event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.isStep1Valid) return;

    final requestId = await storageService.getRequestId();
    if (requestId == null) {
      emit(state.copyWith(error: "Session expired"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      print("object===> ${state.petId.toString()}");
      // Check if we're in edit mode (petId exists)
      if (state.petId.isNotEmpty) {
        // EDIT MODE: Use the new editProfile API
        final editRequest = EditProfileRequest(
          name: state.petName.isNotEmpty ? state.petName : null,
          //speciesId: state.spiecesId.isNotEmpty ? state.spiecesId : null,
          //breedId: state.breedSelected?.id,
          dateOfBirth: state.petBirthday.isNotEmpty ? state.petBirthday : null,
          sex: state.petSex.isNotEmpty ? state.petSex : null,
          isSpayed: state.petSpayed,
          isNeutered: state.petNeutered,
          isMilking: state.milkingStatus,
          weightKg: state.weight > 0 ? state.weight : null,
          color: state.color.isNotEmpty ? state.color : null,
        );

        final result = await profileUseCase.editProfile(
          petId: state.petId,
          editRequest: editRequest,
        );

        await storageService.savePetProfileJson(result.toJson());
        emit(
          state.copyWith(
            isLoading: false,
            step1Success: true,
            petId: result.petResponse?.id ?? petId,
          ),
        );
      } else {
        // CREATE MODE: Use existing createPetStep1 API
        final entity = PetProfileStep1Entity(
          speciesId: state.spiecesId.isNotEmpty
              ? state.spiecesId
              : state.specieSelected?.id,
          ageMonths: state.petAgeInYears.toString(),
          breedId: state.breedSelected?.id,
          dateOfBirth: state.petBirthday,
          isNeutered: state.petNeutered,
          isSpayed: state.petSpayed,
          name: state.petName,
          sex: state.petSex,
          isMilking: state.milkingStatus,
          isPregnant: state.pregnancyStatus,
          otherBread: state.otherBread,
        );

        print("Entity :: ${entity.toJson()}");

        final result = await profileUseCase.createPetStep1(
          petProfileStep1Entity: entity,
        );

        emit(
          state.copyWith(
            isLoading: false,
            step1Success: true,
            petId: result.id,
          ),
        );
      }
    } on ApiException catch (e) {
      emit(
        state.copyWith(isLoading: false, step1Success: false, error: e.message),
      );
    }
  }

  /// ============================================================
  /// STEP 2 API
  /// ============================================================

  Future<void> _onStep2Submit(
    Step2Submit event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.isStep2Valid) return;

    final requestId = await storageService.getRequestId();
    if (requestId == null) {
      emit(state.copyWith(error: "Session expired"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      if (petId != null) {
        // EDIT MODE: Use the new editProfile API
        final editRequest = EditProfileRequest(
          weightKg: state.weight > 0 ? state.weight : null,
          color: state.color.isNotEmpty ? state.color : null,
        );

        final result = await profileUseCase.editProfile(
          petId: petId,
          editRequest: editRequest,
        );

        await storageService.savePetProfileJson(result.toJson());
        emit(
          state.copyWith(
            isLoading: false,
            step1Success: true,
            petId: result.petResponse?.id ?? petId,
          ),
        );
      }
      else{
        await profileUseCase.createPetStep2(
          petProfileStep2Entity: PetProfileStep2Entity(
            weightKg: state.weight,
            color: state.color,
          ),
          petId: state.petId,
        );
      }
      emit(state.copyWith(isLoading: false, step2Success: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          step2Success: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// ============================================================
  /// STEP 3 API
  /// ============================================================

  Future<void> _onStep3Submit(
    Step3Submit event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.isStep3Valid) return;

    final requestId = await storageService.getRequestId();
    if (requestId == null) {
      emit(state.copyWith(error: "Session expired"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final petVaccinationsJson = jsonEncode(
        state.vaccineList.map((e) => e.toJson()).toList(),
      );

      final result = await profileUseCase.completePetProfile(
        documentType: "VACCINATION",
        petVaccinations: petVaccinationsJson,
        files: state.medicalFile,
        petId: state.petId,
      );

      await storageService.savePetProfileJson(result.toJson());

      emit(state.copyWith(isLoading: false, step3Success: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          step3Success: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSkipSubmit(
    SkipSubmit event,
    Emitter<ProfileState> emit,
  ) async {
    final requestId = await storageService.getRequestId();
    if (requestId == null) {
      emit(state.copyWith(error: "Session expired"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await profileUseCase.skipPetProfile(petId: state.petId);

      await storageService.savePetProfileJson(result.toJson());

      emit(state.copyWith(isLoading: false, skipSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          skipSuccess: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// ============================================================
  /// VACCINE LOGIC
  /// ============================================================

  void _onVaccineSelected(VaccineSelected event, Emitter<ProfileState> emit) {
    final list = List<VaccineEntity>.from(state.vaccineList);

    if (!list.any((v) => v.vaccineId == event.vaccine.id)) {
      list.add(
        VaccineEntity(
          vaccineName: event.vaccine.nameEn,
          vaccineId: event.vaccine.id,
          vaccineCode: event.vaccine.code,
          vaccinationDate: event.vaccine.vaccinationDate,
          status: "NOT SURE",
        ),
      );
    }

    emit(state.copyWith(vaccineList: list));
  }

  void _onVaccineDateChanged(
    VaccineDateChanged event,
    Emitter<ProfileState> emit,
  ) {
    final list = List<VaccineEntity>.from(state.vaccineList);
    list[event.index] = list[event.index].copyWith(
      vaccinationDate: event.vaccinatedDate,
    );
    emit(state.copyWith(vaccineList: list));
  }

  void _onVaccineStatusChanged(
    VaccineStatusChanged event,
    Emitter<ProfileState> emit,
  ) {
    final list = List<VaccineEntity>.from(state.vaccineList);
    list[event.index] = list[event.index].copyWith(status: event.status);
    emit(state.copyWith(vaccineList: list));
  }

  /// ============================================================
  /// DROPDOWN API CALLS
  /// ============================================================

  Future<void> _onSpeciesCall(
    SpeciesCall event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        breedSelected: null,
        breedsEntityList: [],
      ),
    );

    try {
      final result = await profileUseCase.callSpecies();
      emit(state.copyWith(isLoading: false, speciesEntityList: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onBreedsCall(
    BreedsCall event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        breedSelected: null,
        breedsEntityList: [],
      ),
    );

    try {
      final result = await profileUseCase.callBreed(speciesId: event.id);
      emit(state.copyWith(isLoading: false, breedsEntityList: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onVaccineCall(
    VaccineCall event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await profileUseCase.getVaccineList(speciesId: event.id);
      emit(state.copyWith(isLoading: false, vaccineEntityList: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSpeciesSelected(SpeciesSelected event, Emitter<ProfileState> emit) {
    print("_onSpeciesSelected");
    emit(
      state.copyWith(
        specieSelected: event.specieSelected,
        breedSelected: null,
        breedsEntityList: [],
      ),
    );
  }

  void _onBreedsSelected(BreedsSelected event, Emitter<ProfileState> emit) {
    print("_onBreedsSelected");
    emit(state.copyWith(breedSelected: event.breedSelected));
  }

  void _onOtherBreedChanged(
    OtherBreedChanged event,
    Emitter<ProfileState> emit,
  ) {
    print("_onOtherBreedChanged");
    emit(state.copyWith(otherBread: event.otherBread));
  }

  void _onBreedReset(BreedReset event, Emitter<ProfileState> emit) {
    print("_onBreedReset");
    emit(state.copyWith(breedSelected: null, breedsEntityList: []));
  }

  void _onPetBirthdayChanged(
    PetBirthdayChanged event,
    Emitter<ProfileState> emit,
  ) {
    print("Age in months ${event.birthday}");
    final DateTime? birthDate = DateTime.tryParse(event.birthday);
    print("Age in months ${event.birthday}");
    if (birthDate != null) {
      final DateTime now = DateTime.now();

      // Calculate total months
      int years = now.year - birthDate.year;
      int months = now.month - birthDate.month;
      int totalMonths = (years * 12) + months;

      // Adjustment: If the current day of the month is less than the birth day,
      // it means the last month isn't "full" yet.
      if (now.day < birthDate.day) {
        totalMonths--;
      }

      // Ensure we don't return negative age
      int calculatedAge = totalMonths < 0 ? 0 : totalMonths;
      print("Age in months $calculatedAge");
      // Update state with BOTH the birthday and the calculated age
      emit(
        state.copyWith(
          petBirthday: event.birthday,
          petAgeInYears: calculatedAge,
          // This variable seems to store months in your state
          error: null,
        ),
      );
    } else {
      emit(state.copyWith(petBirthday: event.birthday));
    }
  }

  /// ============================================================
  /// LOAD LOCAL PROFILE
  /// ============================================================

  Future<void> _onProfileCallLocally(
    ProfileCallLocally event,
    Emitter<ProfileState> emit,
  ) async {
    final json = await storageService.getPetProfileJson();
    if (json == null) return;

    final profile = CompleteProfileResponse.fromJson(json);
    final vaccinations = profile.petVaccinationResponse?.isNotEmpty == true
        ? profile.petVaccinationResponse!.first
        : null;

    emit(
      state.copyWith(
        petName: profile.petResponse?.name,
        petId: profile.petResponse?.petUniqueId,
        petBirthday: profile.petResponse?.dateOfBirth,
        petSex: profile.petResponse?.sex,
        petAgeInYears: profile.petResponse?.ageMonths,
        weight: profile.petResponse?.weightKg,
        color: profile.petResponse?.color,
        vaccineSelected: vaccinations != null
            ? VaccineModel(
                id: vaccinations.vaccineId,
                code: vaccinations.vaccineCode,
                nameEn: vaccinations.vaccineName,
                nameHi: "",
                descriptionEn: "",
                descriptionHi: "",
                isActive: false,
                speciesId: "",
                vaccinationDate: vaccinations.vaccinationDate,
              )
            : null,
      ),
    );
  }

  Future<void> _onEditProfileSubmitted(
    EditProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await profileUseCase.editProfile(
        petId: event.petId,
        editRequest: event.editRequest,
      );

      await storageService.savePetProfileJson(result.toJson());
      emit(state.copyWith(isLoading: false, editProfileSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          editProfileSuccess: false,
          error: e.toString(),
        ),
      );
    }
  }
}
