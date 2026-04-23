class CompleteProfileResponse {
  PetResponse? petResponse;
  List<PetVaccinationResponse>? petVaccinationResponse;
  List<PetDocumentResponse>? petDocumentResponse;

  CompleteProfileResponse({
    this.petResponse,
    this.petVaccinationResponse,
    this.petDocumentResponse,
  });

  CompleteProfileResponse.fromJson(Map<String, dynamic> json) {
    petResponse = json['petResponse'] != null
        ? PetResponse.fromJson(json['petResponse'])
        : null;
    if (json['petVaccinationResponse'] != null) {
      petVaccinationResponse = <PetVaccinationResponse>[];
      json['petVaccinationResponse'].forEach((v) {
        petVaccinationResponse!.add(PetVaccinationResponse.fromJson(v));
      });
    }
    if (json['petDocumentResponse'] != null) {
      petDocumentResponse = <PetDocumentResponse>[];
      json['petDocumentResponse'].forEach((v) {
        petDocumentResponse!.add(PetDocumentResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (petResponse != null) {
      data['petResponse'] = petResponse!.toJson();
    }
    if (petVaccinationResponse != null) {
      data['petVaccinationResponse'] = petVaccinationResponse!
          .map((v) => v.toJson())
          .toList();
    }
    if (petDocumentResponse != null) {
      data['petDocumentResponse'] = petDocumentResponse!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class PetResponse {
  String? id;
  String? petUniqueId;
  String? speciesId;
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

  PetResponse({
    this.id,
    this.petUniqueId,
    this.speciesId,
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

  PetResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petUniqueId = json['petUniqueId'];
    speciesId = json['speciesId'];
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

class PetVaccinationResponse {
  String? vaccineId;
  String? vaccineName;
  String? vaccineCode;
  String? status;
  String? vaccinationDate;

  PetVaccinationResponse({
    this.vaccineId,
    this.vaccineName,
    this.vaccineCode,
    this.status,
    this.vaccinationDate,
  });

  PetVaccinationResponse.fromJson(Map<String, dynamic> json) {
    vaccineId = json['vaccineId'];
    vaccineName = json['vaccineName'];
    vaccineCode = json['vaccineCode'];
    status = json['status'];
    vaccinationDate = json['vaccinationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vaccineId'] = vaccineId;
    data['vaccineName'] = vaccineName;
    data['vaccineCode'] = vaccineCode;
    data['status'] = status;
    data['vaccinationDate'] = vaccinationDate;
    return data;
  }
}

class PetDocumentResponse {
  String? id;
  String? petId;
  String? documentType;
  String? fileUrl;
  String? fileName;
  String? fileSizeKb;
  String? createdAt;

  PetDocumentResponse({
    this.id,
    this.petId,
    this.documentType,
    this.fileUrl,
    this.fileName,
    this.fileSizeKb,
    this.createdAt,
  });

  PetDocumentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petId = json['petId'];
    documentType = json['documentType'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    fileSizeKb = json['fileSizeKb'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['petId'] = petId;
    data['documentType'] = documentType;
    data['fileUrl'] = fileUrl;
    data['fileName'] = fileName;
    data['fileSizeKb'] = fileSizeKb;
    data['createdAt'] = createdAt;
    return data;
  }
}
