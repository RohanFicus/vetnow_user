class SpeciesEntity {
  final String? id;
  final String? code;
  final String? nameEn;
  final String? nameHi;
  final String? iconUrl;
  final bool? isActive;

  SpeciesEntity({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameHi,
    required this.iconUrl,
    required this.isActive,
  });

  SpeciesEntity toEntity() {
    return SpeciesEntity(
      id: id ?? '',
      nameEn: nameEn ?? '',
      nameHi: nameHi ?? '',
      iconUrl: iconUrl ?? '',
      isActive: isActive ?? false,
      code: code ?? '',
    );
  }
}
