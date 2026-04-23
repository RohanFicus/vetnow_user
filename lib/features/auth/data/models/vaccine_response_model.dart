class VaccineResponseModel {
  final List<VaccineModel> data;

  VaccineResponseModel({required this.data});

  factory VaccineResponseModel.fromJson(Map<String, dynamic> json) {
    return VaccineResponseModel(
      data: (json['data'] as List)
          .map((e) => VaccineModel.fromJson(e))
          .toList(),
    );
  }
}

class VaccineModel {
  final String? id;
  final String? code;
  final String? nameEn;
  final String? nameHi;
  final String? speciesId;
  final String? descriptionEn;
  final String? descriptionHi;
  final String? vaccinationDate;
  final bool? isActive;

  VaccineModel({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameHi,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.isActive,
    required this.speciesId,
    required this.vaccinationDate,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      id: json['id'],
      code: json['code'],
      nameEn: json['nameEn'],
      descriptionEn: json['descriptionEn'],
      descriptionHi: json['descriptionHi'],
      nameHi: json['nameHi'],
      isActive: json['isActive'],
      speciesId: json['speciesId'],
      vaccinationDate: json['vaccinationDate'],
    );
  }
}
