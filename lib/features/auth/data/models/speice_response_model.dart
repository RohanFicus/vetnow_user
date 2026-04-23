class SpeiceResponseModel {
  final List<SpeciesModel> data;

  SpeiceResponseModel({required this.data});

  factory SpeiceResponseModel.fromJson(Map<String, dynamic> json) {
    return SpeiceResponseModel(
      data: (json['data'] as List)
          .map((e) => SpeciesModel.fromJson(e))
          .toList(),
    );
  }
}

class SpeciesModel {
  final String? id;
  final String? code;
  final String? nameEn;
  final String? nameHi;
  final String? iconUrl;
  final bool? isActive;

  SpeciesModel({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameHi,
    required this.isActive,
    required this.iconUrl,
  });

  factory SpeciesModel.fromJson(Map<String, dynamic> json) {
    return SpeciesModel(
      id: json['id'],
      code: json['code'],
      nameEn: json['nameEn'],
      nameHi: json['nameHi'],
      isActive: json['isActive'],
      iconUrl: json['iconUrl'],
    );
  }
}
