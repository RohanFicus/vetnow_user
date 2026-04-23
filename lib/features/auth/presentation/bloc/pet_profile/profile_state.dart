import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/breeds_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/species_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/vaccine_entity.dart';

class ProfileState extends Equatable {
  final bool isComplete;
  final bool isLoading;
  final bool step1Success;
  final bool step2Success;
  final bool step3Success;
  final bool skipSuccess;
  final bool editProfileSuccess;
  final String? error;

  //Step 1
  final String petName;
  final String petBirthday;
  final int petAgeInYears;
  final String petSex;
  final bool milkingStatus;
  final bool pregnancyStatus;
  final bool petSpayed;
  final bool petNeutered;
  final String spiecesId;
  final String otherBread;
  final SpeciesModel? specieSelected;
  final String breedId;
  final BreedsModel? breedSelected;
  final List<SpeciesModel> speciesEntityList;
  final List<BreedsModel> breedsEntityList;
  final List<VaccineModel> vaccineEntityList;

  final SpeciesEntity? speciesEntity;
  final BreedsEntity? breedsEntity;

  // Step 2
  final double weight;
  final String color;
  final String height;
  final String notes;
  final String petId;
  final String qrCodeFileName;

  //Step 3
  final VaccineModel? vaccineSelected;
  final PlatformFile? medicalFile;
  final List<VaccineEntity> vaccineList;

  bool get isStep1Valid =>
      petName.trim().isNotEmpty & petBirthday.trim().isNotEmpty &&
      petSex.trim().isNotEmpty &&
      petSex.trim().isNotEmpty &&
      //specieSelected != null &&
      breedSelected != null;

  bool get isStep2Valid => weight != 0.0 && color.trim().isNotEmpty;

  bool get isStep3Valid => medicalFile?.name.trim().isNotEmpty == true;
  //vaccineSelected != null &&

  const ProfileState({
    this.petName = '',
    this.petBirthday = '',
    required this.petAgeInYears,
    this.petSex = '',
    this.milkingStatus = false,
    this.pregnancyStatus = false,
    this.qrCodeFileName = '',
    this.spiecesId = '',
    this.otherBread = '',
    this.petId = '',
    this.petSpayed = false,
    this.petNeutered = false,
    required this.specieSelected,
    this.breedId = '',
    required this.breedSelected,
    this.weight = 0.0,
    this.color = '',
    this.height = '',
    this.notes = '',
    required this.vaccineSelected,
    required this.medicalFile,
    this.isComplete = false,
    this.isLoading = false,
    this.step1Success = false,
    this.step2Success = false,
    this.step3Success = false,
    this.skipSuccess = false,
    this.error,
    this.speciesEntity,
    required this.breedsEntityList,
    required this.speciesEntityList,
    required this.vaccineEntityList,
    required this.vaccineList,
    this.breedsEntity,
    this.editProfileSuccess = false,
  });

  factory ProfileState.initial() => ProfileState(
    petName: "",
    petBirthday: "",
    petAgeInYears: 0,
    petSex: "",
    milkingStatus: false,
    pregnancyStatus: false,
    qrCodeFileName: "",
    spiecesId: "",
    otherBread: "",
    petSpayed: false,
    petNeutered: false,
    petId: "",
    breedId: "",
    weight: 0.0,
    color: "",
    notes: "",
    height: "",
    vaccineSelected: null,
    specieSelected: null,
    breedSelected: null,
    medicalFile: PlatformFile(name: "", size: 0),
    isComplete: false,
    isLoading: false,
    step1Success: false,
    step2Success: false,
    step3Success: false,
    skipSuccess: false,
    speciesEntity: null,
    breedsEntity: null,
    speciesEntityList: [],
    breedsEntityList: [],
    vaccineEntityList: [],
    vaccineList: [],
  );

  ProfileState copyWith({
    String? petName,
    String? petBirthday,
    int? petAgeInYears,
    String? petSex,
    bool? milkingStatus,
    bool? pregnancyStatus,
    String? spiecesId,
    String? otherBread,
    String? petId,
    bool? petSpayed,
    bool? petNeutered,
    double? weight,
    String? color,
    String? qrCodeFileName,
    String? height,
    String? notes,
    VaccineModel? vaccineSelected,
    String? breedId,
    BreedsModel? breedSelected,
    SpeciesModel? specieSelected,
    PlatformFile? medicalFile,
    bool? isComplete,
    bool? isLoading,
    bool? step1Success,
    bool? step2Success,
    bool? step3Success,
    bool? skipSuccess,
    bool? editProfileSuccess,
    String? error,
    SpeciesEntity? speciesEntity,
    BreedsEntity? breedsEntity,
    List<SpeciesModel>? speciesEntityList,
    List<BreedsModel>? breedsEntityList,
    List<VaccineModel>? vaccineEntityList,
    List<VaccineEntity>? vaccineList,
  }) {
    return ProfileState(
      petName: petName ?? this.petName,
      petBirthday: petBirthday ?? this.petBirthday,
      petAgeInYears: petAgeInYears ?? this.petAgeInYears,
      petSex: petSex ?? this.petSex,
      milkingStatus: milkingStatus ?? this.milkingStatus,
      pregnancyStatus: pregnancyStatus ?? this.pregnancyStatus,
      petSpayed: petSpayed ?? this.petSpayed,
      petNeutered: petNeutered ?? this.petNeutered,
      spiecesId: spiecesId ?? this.spiecesId,
      otherBread: otherBread ?? this.otherBread,
      breedId: breedId ?? this.breedId,
      specieSelected: specieSelected ?? this.specieSelected,
      breedSelected: breedSelected ?? this.breedSelected,
      petId: petId ?? this.petId,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      height: height ?? this.height,
      notes: notes ?? this.notes,
      vaccineSelected: vaccineSelected ?? this.vaccineSelected,
      medicalFile: medicalFile ?? this.medicalFile,
      isComplete: isComplete ?? this.isComplete,
      isLoading: isLoading ?? this.isLoading,
      step1Success: step1Success ?? this.step1Success,
      step2Success: step2Success ?? this.step2Success,
      step3Success: step3Success ?? this.step3Success,
      skipSuccess: skipSuccess ?? this.skipSuccess,
      error: error,
      speciesEntity: speciesEntity ?? this.speciesEntity,
      breedsEntity: breedsEntity ?? this.breedsEntity,
      speciesEntityList: speciesEntityList ?? this.speciesEntityList,
      breedsEntityList: breedsEntityList ?? this.breedsEntityList,
      vaccineEntityList: vaccineEntityList ?? this.vaccineEntityList,
      vaccineList: vaccineList ?? this.vaccineList,
    );
  }

  @override
  List<Object?> get props => [
    petName,
    petBirthday,
    petAgeInYears,
    petSex,
    milkingStatus,
    pregnancyStatus,
    breedId,
    spiecesId,
    otherBread,
    petSpayed,
    petNeutered,
    specieSelected,
    breedSelected,
    petId,
    weight,
    color,
    height,
    notes,
    vaccineSelected,
    medicalFile,
    isComplete,
    isLoading,
    error,
    speciesEntityList,
    breedsEntityList,
    vaccineEntityList,
    vaccineList,
  ];
}
