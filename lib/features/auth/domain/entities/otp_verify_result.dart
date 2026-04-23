// domain/entities/otp_verify_result.dart
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';

import 'meta_entity.dart';

class OtpVerifyResult {
  final DashBoardResponseModal? data;
  final MetaEntity? meta;

  OtpVerifyResult({this.data, this.meta});
}
