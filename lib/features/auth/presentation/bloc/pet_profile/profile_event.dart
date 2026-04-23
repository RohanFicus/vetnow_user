import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/edit_profile_request_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class PetIdChanged extends ProfileEvent {
  final String id;

  const PetIdChanged(this.id);

  @override
  List<Object?> get props => [id];
}
class PetNameChanged extends ProfileEvent {
  final String name;

  const PetNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class PetBirthdayChanged extends ProfileEvent {
  final String birthday;

  const PetBirthdayChanged(this.birthday);

  @override
  List<Object?> get props => [birthday];
}

class PetAgeChanged extends ProfileEvent {
  final int age;

  const PetAgeChanged(this.age);

  @override
  List<Object?> get props => [age];
}

class PetGenderChanged extends ProfileEvent {
  final String sex;

  const PetGenderChanged(this.sex);

  @override
  List<Object?> get props => [sex];
}

class PetSpayedChanged extends ProfileEvent {
  final bool spayed;

  const PetSpayedChanged(this.spayed);

  @override
  List<Object?> get props => [spayed];
}

class PetNeuteredChanged extends ProfileEvent {
  final bool petNeutered;

  const PetNeuteredChanged(this.petNeutered);

  @override
  List<Object?> get props => [petNeutered];
}

class MilkingStatusChanged extends ProfileEvent {
  final bool milkingStatus;

  const MilkingStatusChanged(this.milkingStatus);

  @override
  List<Object?> get props => [milkingStatus];
}

class PregnancyStatusChanged extends ProfileEvent {
  final bool pregnancyStatus;

  const PregnancyStatusChanged(this.pregnancyStatus);

  @override
  List<Object?> get props => [pregnancyStatus];
}

class PetSpeciesChanged extends ProfileEvent {
  final String speciesId;

  const PetSpeciesChanged(this.speciesId);

  @override
  List<Object?> get props => [speciesId];
}

class SpeciesSelected extends ProfileEvent {
  final SpeciesModel specieSelected;

  const SpeciesSelected(this.specieSelected);

  @override
  List<Object?> get props => [specieSelected];
}

class BreedsSelected extends ProfileEvent {
  final BreedsModel breedSelected;

  const BreedsSelected(this.breedSelected);

  @override
  List<Object?> get props => [breedSelected];
}

class OtherBreedChanged extends ProfileEvent {
  final String otherBread;

  const OtherBreedChanged(this.otherBread);

  @override
  List<Object?> get props => [otherBread];
}

class SpeciesCall extends ProfileEvent {}

class Step1Submit extends ProfileEvent {}

class Step2Submit extends ProfileEvent {}

class Step3Submit extends ProfileEvent {}

class SkipSubmit extends ProfileEvent {}

class ProfileCallLocally extends ProfileEvent {}

class BreedReset extends ProfileEvent {}

class BreedsCall extends ProfileEvent {
  final String id;

  const BreedsCall(this.id);

  @override
  List<Object?> get props => [id];
}

//Step 2

class PetWeightChanged extends ProfileEvent {
  final double weight;

  const PetWeightChanged(this.weight);

  @override
  List<Object?> get props => [weight];
}

class PetHeightChanged extends ProfileEvent {
  final String height;

  const PetHeightChanged(this.height);

  @override
  List<Object?> get props => [height];
}

class PetNotesChanged extends ProfileEvent {
  final String notes;

  const PetNotesChanged(this.notes);

  @override
  List<Object?> get props => [notes];
}

class PetColorChanged extends ProfileEvent {
  final String color;

  const PetColorChanged(this.color);

  @override
  List<Object?> get props => [color];
}

//Step 3

class VaccineCall extends ProfileEvent {
  final String id;

  const VaccineCall(this.id);

  @override
  List<Object?> get props => [id];
}

class VaccineSelected extends ProfileEvent {
  final VaccineModel vaccine;

  const VaccineSelected(this.vaccine);
}

class FileSelected extends ProfileEvent {
  final PlatformFile? medicalFile;

  const FileSelected(this.medicalFile);
}

class VaccineDateChanged extends ProfileEvent {
  final int index;
  final String vaccinatedDate;

  const VaccineDateChanged({required this.index, required this.vaccinatedDate});

  @override
  List<Object?> get props => [vaccinatedDate];
}

class VaccineStatusChanged extends ProfileEvent {
  final int index;
  final String status;

  const VaccineStatusChanged({required this.index, required this.status});

  @override
  List<Object?> get props => [status];
}

class FileRemoved extends ProfileEvent {}

class EditProfileSubmitted extends ProfileEvent {
  final String petId;
  final EditProfileRequest editRequest;

  const EditProfileSubmitted({required this.petId, required this.editRequest});

  @override
  List<Object?> get props => [petId, editRequest];
}
