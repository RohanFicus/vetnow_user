class AssessmentSuccessModel {
  String? assessmentId;
  Pet? pet;
  String? assessmentType;
  int? totalScore;
  OverallRisk? overallRisk;
  List<NeedsAttention>? needsAttention;
  WarningMessage? warningMessage;
  String? assessedAt;

  AssessmentSuccessModel({
    this.assessmentId,
    this.pet,
    this.assessmentType,
    this.totalScore,
    this.overallRisk,
    this.needsAttention,
    this.warningMessage,
    this.assessedAt,
  });

  AssessmentSuccessModel.fromJson(Map<String, dynamic> json) {
    assessmentId = json['assessmentId'];
    pet = json['pet'] != null ? Pet.fromJson(json['pet']) : null;
    assessmentType = json['assessmentType'];
    totalScore = json['totalScore'];
    overallRisk = json['overallRisk'] != null
        ? OverallRisk.fromJson(json['overallRisk'])
        : null;
    if (json['needsAttention'] != null) {
      needsAttention = <NeedsAttention>[];
      json['needsAttention'].forEach((v) {
        needsAttention!.add(NeedsAttention.fromJson(v));
      });
    }
    warningMessage = json['warningMessage'] != null
        ? WarningMessage.fromJson(json['warningMessage'])
        : null;
    assessedAt = json['assessedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assessmentId'] = assessmentId;
    if (pet != null) {
      data['pet'] = pet!.toJson();
    }
    data['assessmentType'] = assessmentType;
    data['totalScore'] = totalScore;
    if (overallRisk != null) {
      data['overallRisk'] = overallRisk!.toJson();
    }
    if (needsAttention != null) {
      data['needsAttention'] = needsAttention!.map((v) => v.toJson()).toList();
    }
    if (warningMessage != null) {
      data['warningMessage'] = warningMessage!.toJson();
    }
    data['assessedAt'] = assessedAt;
    return data;
  }
}

class Pet {
  String? id;
  String? name;

  Pet({this.id, this.name});

  Pet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['severity'] = severity;
    data['labelEn'] = labelEn;
    data['labelHi'] = labelHi;
    data['descriptionEn'] = descriptionEn;
    data['descriptionHi'] = descriptionHi;
    return data;
  }
}

class NeedsAttention {
  String? category;
  String? titleEn;
  String? titleHi;
  String? valueEn;
  String? valueHi;
  String? severity;

  NeedsAttention({
    this.category,
    this.titleEn,
    this.titleHi,
    this.valueEn,
    this.valueHi,
    this.severity,
  });

  NeedsAttention.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    titleEn = json['titleEn'];
    titleHi = json['titleHi'];
    valueEn = json['valueEn'];
    valueHi = json['valueHi'];
    severity = json['severity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['titleEn'] = titleEn;
    data['titleHi'] = titleHi;
    data['valueEn'] = valueEn;
    data['valueHi'] = valueHi;
    data['severity'] = severity;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['textEn'] = textEn;
    data['textHi'] = textHi;
    return data;
  }
}
