import 'package:hive/hive.dart';

import '../models/local/user_local_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserLocalModel user);
  UserLocalModel? getUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _boxName = 'userBox';

  @override
  Future<void> saveUser(UserLocalModel user) async {
    final box = await Hive.openBox<UserLocalModel>(_boxName);
    await box.put('user', user);
  }

  @override
  UserLocalModel? getUser() {
    final box = Hive.box<UserLocalModel>(_boxName);
    return box.get('user');
  }

  @override
  Future<void> clearUser() async {
    final box = Hive.box<UserLocalModel>(_boxName);
    await box.clear();
  }
}
