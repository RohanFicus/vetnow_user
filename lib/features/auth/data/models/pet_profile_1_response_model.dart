class PetProfileStep1 {
  String? id;
  String? petUniqueId;
  String? speciesId;
  String? breedId;
  String? name;
  String? dateOfBirth;
  int? ageMonths;
  String? sex;
  bool? isSpayedNeutered;
  double? weightKg;
  String? color;
  String? qrCodeFileName;
  bool? profileCompleted;
  String? createdAt;
  String? updatedAt;

  PetProfileStep1({
    this.id,
    this.petUniqueId,
    this.speciesId,
    this.breedId,
    this.name,
    this.dateOfBirth,
    this.ageMonths,
    this.sex,
    this.isSpayedNeutered,
    this.weightKg,
    this.color,
    this.qrCodeFileName,
    this.profileCompleted,
    this.createdAt,
    this.updatedAt,
  });

  PetProfileStep1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petUniqueId = json['petUniqueId'];
    speciesId = json['speciesId'];
    breedId = json['breedId'];
    name = json['name'];
    dateOfBirth = json['dateOfBirth'];
    ageMonths = json['ageMonths'];
    sex = json['sex'];
    isSpayedNeutered = json['isSpayedNeutered'];
    weightKg = json['weightKg'];
    color = json['color'];
    qrCodeFileName = json['qrCodeFileName'];
    profileCompleted = json['profileCompleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['petUniqueId'] = petUniqueId;
    data['speciesId'] = speciesId;
    data['breedId'] = breedId;
    data['name'] = name;
    data['dateOfBirth'] = dateOfBirth;
    data['ageMonths'] = ageMonths;
    data['sex'] = sex;
    data['isSpayedNeutered'] = isSpayedNeutered;
    data['weightKg'] = weightKg;
    data['color'] = color;
    data['qrCodeFileName'] = qrCodeFileName;
    data['profileCompleted'] = profileCompleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
