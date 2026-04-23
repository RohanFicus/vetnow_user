class PetProfileStep1Entity {
  String? speciesId;
  String? breedId;
  String? otherBread;
  String? name;
  String? dateOfBirth;
  String? ageMonths;
  String? sex;
  bool? isNeutered;
  bool? isSpayed;
  bool? isMilking;
  bool? isPregnant;

  PetProfileStep1Entity({
    this.speciesId,
    this.breedId,
    this.otherBread,
    this.name,
    this.dateOfBirth,
    this.ageMonths,
    this.sex,
    this.isNeutered,
    this.isSpayed,
    this.isMilking,
    this.isPregnant,
  });

  PetProfileStep1Entity.fromJson(Map<String, dynamic> json) {
    speciesId = json['speciesId'];
    breedId = json['breedId'];
    otherBread = json['otherBread'];
    name = json['name'];
    dateOfBirth = json['dateOfBirth'];
    ageMonths = json['ageMonths'];
    sex = json['sex'];
    isNeutered = json['isNeutered'];
    isSpayed = json['isSpayed'];
    isMilking = json['isMilking'];
    isPregnant = json['isPregnant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['speciesId'] = speciesId;
    data['breedId'] = breedId;
    data['otherBread'] = otherBread;
    data['name'] = name;
    data['dateOfBirth'] = dateOfBirth;
    data['ageMonths'] = ageMonths;
    data['sex'] = sex;
    data['isSpayed'] = isSpayed;
    data['isNeutered'] = isNeutered;
    data['isMilking'] = isMilking;
    data['isPregnant'] = isPregnant;
    return data;
  }
}
