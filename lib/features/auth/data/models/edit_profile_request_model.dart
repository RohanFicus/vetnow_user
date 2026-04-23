
class EditProfileRequest {
  final String? name;
  final String? speciesId;
  final String? breedId;
  final String? dateOfBirth;
  final String? sex;
  bool? isNeutered;
  bool? isSpayed;
  bool? isMilking;
  bool? isPregnant;
  final double? weightKg;
  final String? color;
  final List<VaccinationUpdate>? vaccinations;

  EditProfileRequest({
    this.name,
    this.speciesId,
    this.breedId,
    this.dateOfBirth,
    this.sex,
    this.isNeutered,
    this.isSpayed,
    this.isMilking,
    this.weightKg,
    this.color,
    this.vaccinations
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (speciesId != null) 'speciesId': speciesId,
      if (breedId != null) 'breedId': breedId,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (sex != null) 'sex': sex,
      if (isNeutered != null) 'isNeutered': isNeutered,
      if (isSpayed != null) 'isSpayed': isSpayed,
      if (isMilking != null) 'isMilking': isMilking,
      if (weightKg != null) 'weightKg': weightKg,
      if (color != null) 'color': color,
    };
  }

  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> data = toJson();
    
    // Convert vaccinations to JSON string for FormData
    if (vaccinations != null) {
      data['vaccinations'] = vaccinations!.map((v) => v.toJson()).toList().toString();
    }
    
    return data;
  }
}

class VaccinationUpdate {
  final String? vaccineId;
  final String? vaccineName;
  final String? administeredDate;
  final String? nextDueDate;
  final String? notes;
  final bool? isDeleted;

  VaccinationUpdate({
    this.vaccineId,
    this.vaccineName,
    this.administeredDate,
    this.nextDueDate,
    this.notes,
    this.isDeleted,
  });

  Map<String, dynamic> toJson() {
    return {
      if (vaccineId != null) 'vaccineId': vaccineId,
      if (vaccineName != null) 'vaccineName': vaccineName,
      if (administeredDate != null) 'administeredDate': administeredDate,
      if (nextDueDate != null) 'nextDueDate': nextDueDate,
      if (notes != null) 'notes': notes,
      if (isDeleted != null) 'isDeleted': isDeleted,
    };
  }
}
