class BreedsResponseModel {
  final List<BreedsModel> data;

  BreedsResponseModel({required this.data});

  factory BreedsResponseModel.fromJson(Map<String, dynamic> json) {
    return BreedsResponseModel(
      data: (json['data'] as List).map((e) => BreedsModel.fromJson(e)).toList(),
    );
  }
}

class BreedsModel {
  final String? id;
  final String? code;
  final String? nameEn;
  final String? nameHi;
  final String? speciesId;
  final bool? isActive;

  BreedsModel({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameHi,
    required this.isActive,
    required this.speciesId,
  });

  factory BreedsModel.fromJson(Map<String, dynamic> json) {
    return BreedsModel(
      id: json['id'],
      code: json['code'],
      nameEn: json['nameEn'],
      nameHi: json['nameHi'],
      isActive: json['isActive'],
      speciesId: json['speciesId'],
    );
  }
}
