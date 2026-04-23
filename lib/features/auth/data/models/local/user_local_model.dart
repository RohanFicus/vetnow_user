import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserLocalModel {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String firstName;

  @HiveField(2)
  late String lastName;

  @HiveField(3)
  late String mobile;

  @HiveField(4)
  late String role;

  @HiveField(5)
  late bool isActive;
}
