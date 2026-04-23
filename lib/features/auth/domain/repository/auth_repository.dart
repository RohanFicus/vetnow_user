import 'dart:io';

import 'package:vetnow_user/features/auth/domain/entities/otp_verify_result.dart';
import 'package:vetnow_user/features/auth/domain/entities/owner_profile_entity.dart';

import '../../data/models/local/user_local_model.dart';
import '../entities/otp_entity.dart';

abstract class AuthRepository {
  Future<UserLocalModel> getLocalUser();

  Future<OtpEntity> sendOtp({
    required String phone,
    required String countryCode,
  });

  Future<OtpVerifyResult> verifyOtp({
    required String requestId,
    required String otp,
  });

  Future<OwnerProfileEntity> createOwnerProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required File image,
  });
}
