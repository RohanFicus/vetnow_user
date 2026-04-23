class DashBoardResponseModal {
  User? user;
  List<Pets>? pets;
  DoctorProfileResponse? doctorProfileResponse;
  DoctorAvailabilityResponse? doctorAvailabilityResponse;
  List<AppointmentResponse>? appointmentResponseList;

  DashBoardResponseModal({
    this.user,
    this.pets,
    this.doctorProfileResponse,
    this.doctorAvailabilityResponse,
    this.appointmentResponseList,
  });

  DashBoardResponseModal.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    if (json['pets'] != null) {
      pets = [];
      json['pets'].forEach((v) {
        pets!.add(Pets.fromJson(v));
      });
    }

    doctorProfileResponse = json['doctorProfileResponse'] != null
        ? DoctorProfileResponse.fromJson(json['doctorProfileResponse'])
        : null;

    doctorAvailabilityResponse = json['doctorAvailabilityResponse'] != null
        ? DoctorAvailabilityResponse.fromJson(json['doctorAvailabilityResponse'])
        : null;

    if (json['appointmentResponseList'] != null) {
      appointmentResponseList = [];
      json['appointmentResponseList'].forEach((v) {
        appointmentResponseList!.add(AppointmentResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (user != null) data['user'] = user!.toJson();
    if (pets != null) {
      data['pets'] = pets!.map((v) => v.toJson()).toList();
    }
    if (doctorProfileResponse != null) {
      data['doctorProfileResponse'] = doctorProfileResponse!.toJson();
    }
    if (doctorAvailabilityResponse != null) {
      data['doctorAvailabilityResponse'] = doctorAvailabilityResponse!.toJson();
    }
    if (appointmentResponseList != null) {
      data['appointmentResponseList'] =
          appointmentResponseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? countryCode;
  String? address;
  String? role;
  String? profileImage;
  bool? isActive;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.countryCode,
    this.address,
    this.role,
    this.profileImage,
    this.isActive,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['countryCode'];
    address = json['address'];
    role = json['role'];
    profileImage = json['profileImage'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['countryCode'] = countryCode;
    data['address'] = address;
    data['role'] = role;
    data['profileImage'] = profileImage;
    data['isActive'] = isActive;
    return data;
  }
}

class Pets {
  Profile? profile;
  List<Vaccinations>? vaccinations;
  List<DocumentsDetail>? documents;
  LatestAssessment? latestAssessment;

  Pets({
    this.profile,
    this.vaccinations,
    this.documents,
    this.latestAssessment,
  });

  Pets.fromJson(Map<String, dynamic> json) {
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;

    if (json['vaccinations'] != null) {
      vaccinations = <Vaccinations>[];
      json['vaccinations'].forEach((v) {
        vaccinations!.add(Vaccinations.fromJson(v));
      });
    }

    if (json['documents'] != null) {
      documents = <DocumentsDetail>[];
      json['documents'].forEach((v) {
        documents!.add(DocumentsDetail.fromJson(v));
      });
    }

    latestAssessment = json['latestAssessment'] != null
        ? LatestAssessment.fromJson(json['latestAssessment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (vaccinations != null) {
      data['vaccinations'] = vaccinations!.map((v) => v.toJson()).toList();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    if (latestAssessment != null) {
      data['latestAssessment'] = latestAssessment!.toJson();
    }

    return data;
  }
}

class Profile {
  String? id;
  String? petUniqueId;
  String? speciesId;
  String? speciesName;
  String? breedId;
  String? breedName;
  String? name;
  String? dateOfBirth;
  int? ageMonths;
  String? sex;
  bool? isNeutered;
  bool? isSpayed;
  bool? isMilking;
  bool? isPregnant;
  double? weightKg;
  String? color;
  String? qrCodeFileName;
  bool? profileCompleted;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Profile({
    this.id,
    this.petUniqueId,
    this.speciesId,
    this.speciesName,
    this.breedId,
    this.breedName,
    this.name,
    this.dateOfBirth,
    this.ageMonths,
    this.sex,
    this.isNeutered,
    this.isSpayed,
    this.isMilking,
    this.isPregnant,
    this.weightKg,
    this.color,
    this.qrCodeFileName,
    this.profileCompleted,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petUniqueId = json['petUniqueId'];
    speciesId = json['speciesId'];
    speciesName = json['speciesName'];
    breedId = json['breedId'];
    breedName = json['breedName'];
    name = json['name'];
    dateOfBirth = json['dateOfBirth'];
    ageMonths = json['ageMonths'];
    sex = json['sex'];
    isNeutered = json['isNeutered'];
    isSpayed = json['isSpayed'];
    isMilking = json['isMilking'];
    isPregnant = json['isPregnant'];
    weightKg = json['weightKg']?.toDouble();
    color = json['color'];
    qrCodeFileName = json['qrCodeFileName'];
    profileCompleted = json['profileCompleted'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['petUniqueId'] = petUniqueId;
    data['speciesId'] = speciesId;
    data['speciesName'] = speciesName;
    data['breedId'] = breedId;
    data['breedName'] = breedName;
    data['name'] = name;
    data['dateOfBirth'] = dateOfBirth;
    data['ageMonths'] = ageMonths;
    data['sex'] = sex;
    data['isNeutered'] = isNeutered;
    data['isSpayed'] = isSpayed;
    data['isMilking'] = isMilking;
    data['isPregnant'] = isPregnant;
    data['weightKg'] = weightKg;
    data['color'] = color;
    data['qrCodeFileName'] = qrCodeFileName;
    data['profileCompleted'] = profileCompleted;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class LatestAssessment {
  String? assessmentId;
  AssessmentPet? pet;
  String? assessmentType;
  int? totalScore;
  OverallRisk? overallRisk;
  WarningMessage? warningMessage;
  String? assessedAt;

  LatestAssessment({
    this.assessmentId,
    this.pet,
    this.assessmentType,
    this.totalScore,
    this.overallRisk,
    this.warningMessage,
    this.assessedAt,
  });

  LatestAssessment.fromJson(Map<String, dynamic> json) {
    assessmentId = json['assessmentId'];
    pet = json['pet'] != null ? AssessmentPet.fromJson(json['pet']) : null;
    assessmentType = json['assessmentType'];
    totalScore = json['totalScore'];
    overallRisk = json['overallRisk'] != null
        ? OverallRisk.fromJson(json['overallRisk'])
        : null;
    warningMessage = json['warningMessage'] != null
        ? WarningMessage.fromJson(json['warningMessage'])
        : null;
    assessedAt = json['assessedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['assessmentId'] = assessmentId;
    if (pet != null) data['pet'] = pet!.toJson();
    data['assessmentType'] = assessmentType;
    data['totalScore'] = totalScore;
    if (overallRisk != null) data['overallRisk'] = overallRisk!.toJson();
    if (warningMessage != null) {
      data['warningMessage'] = warningMessage!.toJson();
    }
    data['assessedAt'] = assessedAt;
    return data;
  }
}

class AssessmentPet {
  String? id;
  String? name;

  AssessmentPet({this.id, this.name});

  AssessmentPet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class OverallRisk {
  String? level;
  int? severity;
  String? labelEn;
  String? labelHi;
  String? descriptionEn;
  String? descriptionHi;

  OverallRisk({
    this.level,
    this.severity,
    this.labelEn,
    this.labelHi,
    this.descriptionEn,
    this.descriptionHi,
  });

  OverallRisk.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    severity = json['severity'];
    labelEn = json['labelEn'];
    labelHi = json['labelHi'];
    descriptionEn = json['descriptionEn'];
    descriptionHi = json['descriptionHi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['level'] = level;
    data['severity'] = severity;
    data['labelEn'] = labelEn;
    data['labelHi'] = labelHi;
    data['descriptionEn'] = descriptionEn;
    data['descriptionHi'] = descriptionHi;
    return data;
  }
}

class WarningMessage {
  String? textEn;
  String? textHi;

  WarningMessage({this.textEn, this.textHi});

  WarningMessage.fromJson(Map<String, dynamic> json) {
    textEn = json['textEn'];
    textHi = json['textHi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['textEn'] = textEn;
    data['textHi'] = textHi;
    return data;
  }
}

class Vaccinations {
  String? vaccineId;
  String? vaccineName;
  String? vaccineCode;
  String? status;
  String? vaccinationDate;

  Vaccinations({
    this.vaccineId,
    this.vaccineName,
    this.vaccineCode,
    this.status,
    this.vaccinationDate,
  });

  Vaccinations.fromJson(Map<String, dynamic> json) {
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

class DocumentsDetail {
  String? id;
  String? petId;
  String? documentType;
  String? fileUrl;
  String? fileName;
  int? fileSizeKb;
  String? createdAt;

  DocumentsDetail({
    this.id,
    this.petId,
    this.documentType,
    this.fileUrl,
    this.fileName,
    this.fileSizeKb,
    this.createdAt,
  });

  DocumentsDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petId = json['petId'];
    documentType = json['documentType'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    fileSizeKb = json['fileSizeKb'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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

class DoctorProfileResponse {
  String? doctorId;
  String? userId;
  String? fullName;
  String? email;
  String? mobile;
  String? profileImage;
  String? approvalStatus;
  int? consultationFee;
  double? commissionPercent;
  bool? isEnabled;
  String? createdAt;
  String? updatedAt;
  DoctorAvailabilityResponse? doctorAvailabilityResponse;

  DoctorProfileResponse({
    this.doctorId,
    this.userId,
    this.fullName,
    this.email,
    this.mobile,
    this.profileImage,
    this.approvalStatus,
    this.consultationFee,
    this.commissionPercent,
    this.isEnabled,
    this.createdAt,
    this.updatedAt,
    this.doctorAvailabilityResponse,
  });

  DoctorProfileResponse.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    userId = json['userId'];
    fullName = json['fullName'];
    email = json['email'];
    mobile = json['mobile'];
    profileImage = json['profileImage'];
    approvalStatus = json['approvalStatus'];
    consultationFee = json['consultationFee'];
    commissionPercent = json['commissionPercent']?.toDouble();
    isEnabled = json['isEnabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    doctorAvailabilityResponse = json['doctorAvailabilityResponse'] != null
        ? DoctorAvailabilityResponse.fromJson(
            json['doctorAvailabilityResponse'],
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['doctorId'] = doctorId;
    data['userId'] = userId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['profileImage'] = profileImage;
    data['approvalStatus'] = approvalStatus;
    data['consultationFee'] = consultationFee;
    if (commissionPercent != null) {
      data['commissionPercent'] = commissionPercent;
    }
    data['isEnabled'] = isEnabled;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (doctorAvailabilityResponse != null) {
      data['doctorAvailabilityResponse'] = doctorAvailabilityResponse!.toJson();
    }
    return data;
  }
}

class DoctorAvailabilityResponse {
  String? id;
  String? doctorId;
  List<String>? workingDays;
  int? slotDurationMinutes;
  bool? morningActive;
  String? morningStart;
  String? morningEnd;
  bool? afternoonActive;
  String? afternoonStart;
  String? afternoonEnd;
  bool? eveningActive;
  String? eveningStart;
  String? eveningEnd;
  bool? isActive;

  DoctorAvailabilityResponse({
    this.id,
    this.doctorId,
    this.workingDays,
    this.slotDurationMinutes,
    this.morningActive,
    this.morningStart,
    this.morningEnd,
    this.afternoonActive,
    this.afternoonStart,
    this.afternoonEnd,
    this.eveningActive,
    this.eveningStart,
    this.eveningEnd,
    this.isActive,
  });

  DoctorAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctorId'];
    workingDays = json['workingDays']?.cast<String>();
    slotDurationMinutes = json['slotDurationMinutes'];
    morningActive = json['morningActive'];
    morningStart = json['morningStart'];
    morningEnd = json['morningEnd'];
    afternoonActive = json['afternoonActive'];
    afternoonStart = json['afternoonStart'];
    afternoonEnd = json['afternoonEnd'];
    eveningActive = json['eveningActive'];
    eveningStart = json['eveningStart'];
    eveningEnd = json['eveningEnd'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['doctorId'] = doctorId;
    data['workingDays'] = workingDays;
    data['slotDurationMinutes'] = slotDurationMinutes;
    data['morningActive'] = morningActive;
    data['morningStart'] = morningStart;
    data['morningEnd'] = morningEnd;
    data['afternoonActive'] = afternoonActive;
    data['afternoonStart'] = afternoonStart;
    data['afternoonEnd'] = afternoonEnd;
    data['eveningActive'] = eveningActive;
    data['eveningStart'] = eveningStart;
    data['eveningEnd'] = eveningEnd;
    data['isActive'] = isActive;
    return data;
  }
}

class AppointmentResponse {
  String? id;
  AppointmentDoctor? doctor;
  AppointmentPetOwner? petOwner;
  AppointmentPet? pet;
  Species? species;
  String? appointmentDate;
  String? appointmentTime;
  String? bookedBy;
  String? status;
  int? amount;
  String? paymentExpiresAt;
  String? paymentStatus;
  bool? isExpired;
  String? dashboardStatus;
  String? notes;
  String? consultationType;
  String? createdAt;
  String? updatedAt;
  List<AppointmentAttachment>? appointmentAttachmentResponse;

  AppointmentResponse({
    this.id,
    this.doctor,
    this.petOwner,
    this.pet,
    this.species,
    this.appointmentDate,
    this.appointmentTime,
    this.bookedBy,
    this.status,
    this.amount,
    this.paymentExpiresAt,
    this.paymentStatus,
    this.isExpired,
    this.dashboardStatus,
    this.notes,
    this.consultationType,
    this.createdAt,
    this.updatedAt,
    this.appointmentAttachmentResponse,
  });

  AppointmentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctor = json['doctor'] != null
        ? AppointmentDoctor.fromJson(json['doctor'])
        : null;
    petOwner = json['petOwner'] != null
        ? AppointmentPetOwner.fromJson(json['petOwner'])
        : null;
    pet = json['pet'] != null ? AppointmentPet.fromJson(json['pet']) : null;
    species =
        json['species'] != null ? Species.fromJson(json['species']) : null;
    appointmentDate = json['appointmentDate'];
    appointmentTime = json['appointmentTime'];
    bookedBy = json['bookedBy'];
    status = json['status'];
    amount = json['amount'];
    paymentExpiresAt = json['paymentExpiresAt'];
    paymentStatus = json['paymentStatus'];
    isExpired = json['isExpired'];
    dashboardStatus = json['dashboardStatus'];
    notes = json['notes'];
    consultationType = json['consultationType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    if (json['appointmentAttachmentResponse'] != null) {
      appointmentAttachmentResponse = [];
      json['appointmentAttachmentResponse'].forEach((v) {
        appointmentAttachmentResponse!.add(AppointmentAttachment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (doctor != null) data['doctor'] = doctor!.toJson();
    if (petOwner != null) data['petOwner'] = petOwner!.toJson();
    if (pet != null) data['pet'] = pet!.toJson();
    if (species != null) data['species'] = species!.toJson();
    if (appointmentDate != null) data['appointmentDate'] = appointmentDate;
    if (appointmentTime != null) data['appointmentTime'] = appointmentTime;
    if (bookedBy != null) data['bookedBy'] = bookedBy;
    if (status != null) data['status'] = status;
    if (amount != null) data['amount'] = amount;
    if (paymentExpiresAt != null) data['paymentExpiresAt'] = paymentExpiresAt;
    if (paymentStatus != null) data['paymentStatus'] = paymentStatus;
    if (isExpired != null) data['isExpired'] = isExpired;
    if (dashboardStatus != null) data['dashboardStatus'] = dashboardStatus;
    if (notes != null) data['notes'] = notes;
    if (consultationType != null) data['consultationType'] = consultationType;
    if (createdAt != null) data['createdAt'] = createdAt;
    if (updatedAt != null) data['updatedAt'] = updatedAt;
    if (appointmentAttachmentResponse != null) {
      data['appointmentAttachmentResponse'] = appointmentAttachmentResponse!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class AppointmentPetOwner {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? countryCode;
  String? address;
  String? role;
  String? profileImage;
  bool? isActive;

  AppointmentPetOwner({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.countryCode,
    this.address,
    this.role,
    this.profileImage,
    this.isActive,
  });

  AppointmentPetOwner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['countryCode'];
    address = json['address'];
    role = json['role'];
    profileImage = json['profileImage'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (email != null) data['email'] = email;
    if (mobile != null) data['mobile'] = mobile;
    if (countryCode != null) data['countryCode'] = countryCode;
    if (address != null) data['address'] = address;
    if (role != null) data['role'] = role;
    if (profileImage != null) data['profileImage'] = profileImage;
    if (isActive != null) data['isActive'] = isActive;
    return data;
  }
}

class AppointmentDoctor {
  String? doctorId;
  String? userId;
  String? fullName;
  String? email;
  String? mobile;
  String? approvalStatus;
  int? consultationFee;
  double? commissionPercent;
  bool? isEnabled;
  String? createdAt;
  String? updatedAt;
  DoctorAvailabilityResponse? doctorAvailabilityResponse;

  AppointmentDoctor({
    this.doctorId,
    this.userId,
    this.fullName,
    this.email,
    this.mobile,
    this.approvalStatus,
    this.consultationFee,
    this.commissionPercent,
    this.isEnabled,
    this.createdAt,
    this.updatedAt,
    this.doctorAvailabilityResponse,
  });

  AppointmentDoctor.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    userId = json['userId'];
    fullName = json['fullName'];
    email = json['email'];
    mobile = json['mobile'];
    approvalStatus = json['approvalStatus'];
    consultationFee = json['consultationFee'];
    commissionPercent = json['commissionPercent']?.toDouble();
    isEnabled = json['isEnabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    doctorAvailabilityResponse = json['doctorAvailabilityResponse'] != null
        ? DoctorAvailabilityResponse.fromJson(
            json['doctorAvailabilityResponse'],
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (doctorId != null) data['doctorId'] = doctorId;
    if (userId != null) data['userId'] = userId;
    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (mobile != null) data['mobile'] = mobile;
    if (approvalStatus != null) data['approvalStatus'] = approvalStatus;
    if (consultationFee != null) data['consultationFee'] = consultationFee;
    if (commissionPercent != null) {
      data['commissionPercent'] = commissionPercent;
    }
    if (isEnabled != null) data['isEnabled'] = isEnabled;
    if (createdAt != null) data['createdAt'] = createdAt;
    if (updatedAt != null) data['updatedAt'] = updatedAt;
    if (doctorAvailabilityResponse != null) {
      data['doctorAvailabilityResponse'] = doctorAvailabilityResponse!.toJson();
    }
    return data;
  }
}

class AppointmentPet {
  String? id;
  String? petUniqueId;
  String? speciesId;
  String? speciesName;
  String? breedId;
  String? breedName;
  String? name;
  String? dateOfBirth;
  int? ageMonths;
  String? sex;
  bool? isNeutered;
  bool? isSpayed;
  bool? isMilking;
  bool? isPregnant;
  double? weightKg;
  String? color;
  String? qrCodeFileName;
  bool? profileCompleted;
  bool? isActive;
  String? profileImage;
  String? createdAt;
  String? updatedAt;

  AppointmentPet({
    this.id,
    this.petUniqueId,
    this.speciesId,
    this.speciesName,
    this.breedId,
    this.breedName,
    this.name,
    this.dateOfBirth,
    this.ageMonths,
    this.sex,
    this.isNeutered,
    this.isSpayed,
    this.isMilking,
    this.isPregnant,
    this.weightKg,
    this.color,
    this.qrCodeFileName,
    this.profileCompleted,
    this.isActive,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  AppointmentPet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petUniqueId = json['petUniqueId'];
    speciesId = json['speciesId'];
    speciesName = json['speciesName'];
    breedId = json['breedId'];
    breedName = json['breedName'];
    name = json['name'];
    dateOfBirth = json['dateOfBirth'];
    ageMonths = json['ageMonths'];
    sex = json['sex'];
    isNeutered = json['isNeutered'];
    isSpayed = json['isSpayed'];
    isMilking = json['isMilking'];
    isPregnant = json['isPregnant'];
    weightKg = json['weightKg']?.toDouble();
    color = json['color'];
    qrCodeFileName = json['qrCodeFileName'];
    profileCompleted = json['profileCompleted'];
    isActive = json['isActive'];
    profileImage = json['profileImage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (petUniqueId != null) data['petUniqueId'] = petUniqueId;
    if (speciesId != null) data['speciesId'] = speciesId;
    if (speciesName != null) data['speciesName'] = speciesName;
    if (breedId != null) data['breedId'] = breedId;
    if (breedName != null) data['breedName'] = breedName;
    if (name != null) data['name'] = name;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth;
    if (ageMonths != null) data['ageMonths'] = ageMonths;
    if (sex != null) data['sex'] = sex;
    if (isNeutered != null) data['isNeutered'] = isNeutered;
    if (isSpayed != null) data['isSpayed'] = isSpayed;
    if (isMilking != null) data['isMilking'] = isMilking;
    if (isPregnant != null) data['isPregnant'] = isPregnant;
    if (weightKg != null) data['weightKg'] = weightKg;
    if (color != null) data['color'] = color;
    if (qrCodeFileName != null) data['qrCodeFileName'] = qrCodeFileName;
    if (profileCompleted != null) data['profileCompleted'] = profileCompleted;
    if (isActive != null) data['isActive'] = isActive;
    if (profileImage != null) data['profileImage'] = profileImage;
    if (createdAt != null) data['createdAt'] = createdAt;
    if (updatedAt != null) data['updatedAt'] = updatedAt;
    return data;
  }
}

class Species {
  String? id;
  String? code;
  String? nameEn;
  String? nameHi;
  String? iconUrl;
  bool? isActive;
  bool? producesMilk;

  Species({
    this.id,
    this.code,
    this.nameEn,
    this.nameHi,
    this.iconUrl,
    this.isActive,
    this.producesMilk,
  });

  Species.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    nameEn = json['nameEn'];
    nameHi = json['nameHi'];
    iconUrl = json['iconUrl'];
    isActive = json['isActive'];
    producesMilk = json['producesMilk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (code != null) data['code'] = code;
    if (nameEn != null) data['nameEn'] = nameEn;
    if (nameHi != null) data['nameHi'] = nameHi;
    if (iconUrl != null) data['iconUrl'] = iconUrl;
    if (isActive != null) data['isActive'] = isActive;
    if (producesMilk != null) data['producesMilk'] = producesMilk;
    return data;
  }
}

class AppointmentAttachment {
  String? id;
  String? appointmentId;
  String? fileUrl;
  String? fileName;
  String? createdAt;

  AppointmentAttachment({
    this.id,
    this.appointmentId,
    this.fileUrl,
    this.fileName,
    this.createdAt,
  });

  AppointmentAttachment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentId = json['appointmentId'];
    fileUrl = json['fileUrl'];
    fileName = json['fileName'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (appointmentId != null) data['appointmentId'] = appointmentId;
    if (fileUrl != null) data['fileUrl'] = fileUrl;
    if (fileName != null) data['fileName'] = fileName;
    if (createdAt != null) data['createdAt'] = createdAt;
    return data;
  }
}
