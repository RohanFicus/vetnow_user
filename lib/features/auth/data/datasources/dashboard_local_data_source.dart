import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/dashboard_response_model.dart';

abstract class DashboardLocalDataSource {
  Future<void> cacheDashboard(DashBoardResponseModal dashboard);
  Future<DashBoardResponseModal?> getCachedDashboard();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const _boxName = 'dashboardBox';
  static const _key = 'cached_dashboard';

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  @override
  Future<void> cacheDashboard(DashBoardResponseModal dashboard) async {
    final box = await _getBox();
    await box.put(_key, jsonEncode(dashboard.toJson()));
  }

  @override
  Future<DashBoardResponseModal?> getCachedDashboard() async {
    final box = await _getBox();
    final String? jsonString = box.get(_key);
    if (jsonString != null) {
      try {
        return DashBoardResponseModal.fromJson(jsonDecode(jsonString));
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
