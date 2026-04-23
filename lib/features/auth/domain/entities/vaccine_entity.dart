class VaccineEntity {
  final String? vaccineId;
  final String? vaccineName;
  final String? vaccineCode;
  final String? status;
  final String? vaccinationDate;

  VaccineEntity({
    required this.vaccineId,
    required this.vaccineName,
    required this.vaccineCode,
    required this.status,
    required this.vaccinationDate,
  });

  VaccineEntity copyWith({
    String? vaccineId,
    String? vaccineName,
    String? vaccineCode,
    String? status,
    String? vaccinationDate,
  }) {
    return VaccineEntity(
      vaccineId: vaccineId ?? this.vaccineId,
      vaccineName: vaccineName ?? this.vaccineName,
      vaccineCode: vaccineCode ?? this.vaccineCode,
      status: status ?? this.status,
      vaccinationDate: vaccinationDate ?? this.vaccinationDate,
    );
  }

  VaccineEntity toEntity() {
    return VaccineEntity(
      vaccineId: vaccineId ?? '',
      vaccineName: vaccineName ?? '',
      vaccineCode: vaccineCode ?? '',
      status: status ?? '',
      vaccinationDate: vaccinationDate ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "vaccineId": vaccineId,
      "vaccineCode": vaccineCode,
      "vaccineName": vaccineName,
      "status": status,
      "vaccinationDate": vaccinationDate,
    };
  }
}
