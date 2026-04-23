class SymptomsResponseModel {
  final String id;
  final String nameEn;
  final String nameHi;
  final String? description;
  final String? iconUrl;
  final bool isActive;

  SymptomsResponseModel({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    this.description,
    this.iconUrl,
    required this.isActive,
  });

  factory SymptomsResponseModel.fromJson(Map<String, dynamic> json) {
    return SymptomsResponseModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameHi: json['nameHi'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameHi': nameHi,
      'description': description,
      'iconUrl': iconUrl,
      'isActive': isActive,
    };
  }
}
