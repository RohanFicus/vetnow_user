import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class PetLocalModel {
  @HiveField(0)
  late String petId;

  @HiveField(1)
  late Map<String, dynamic> profile;

  @HiveField(2)
  late List<Map<String, dynamic>> vaccinations;

  @HiveField(3)
  late List<Map<String, dynamic>> documents;

  @HiveField(4)
  late Map<String, dynamic>? latestAssessment;
}
