import 'dart:io';

import 'package:vetnow_user/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/meta_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/otp_verify_result.dart';
import 'package:vetnow_user/features/auth/domain/entities/owner_profile_entity.dart';

import '../../domain/entities/otp_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/local/user_local_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<OtpEntity> sendOtp({
    required String phone,
    required String countryCode,
  }) async {
    final response = await remoteDataSource.sendOtp(
      phone: phone,
      countryCode: countryCode,
    );

    return OtpEntity(
      requestId: response.data?.requestId,
      expiresIn: response.data?.expiresIn,
    );
  }

  @override
  Future<OtpVerifyResult> verifyOtp({
    required String requestId,
    required String otp,
  }) async {
    final response = await remoteDataSource.verifyOtp(
      requestId: requestId,
      otp: otp,
    );

    print("METADATA :: ${response.data}");
    return OtpVerifyResult(
      data: response.data != null
          ? DashBoardResponseModal(
              user: response.data?.user,
              pets: response.data?.pets,
            )
          : null,
      meta: response.meta != null
          ? MetaEntity(
              accessToken: response.meta?.token?.accessToken,
              refreshToken: response.meta?.token?.refreshToken,
              expiresIn: response.meta?.token?.expiresIn,
            )
          : null,
    );
  }

  @override
  Future<OwnerProfileEntity> createOwnerProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required File image,
  }) async {
    final response = await remoteDataSource.createOwnerProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      address: address,
      image: image,
    );

    return OwnerProfileEntity(
      email: response.data?.email,
      firstName: response.data?.firstName,
      id: response.data?.id,
      isActive: response.data?.isActive,
      lastName: response.data?.lastName,
      profileImage: response.data?.profileImage,
      mobile: response.data?.mobile,
      address: response.data?.address,
      role: response.data?.role,
    );
  }

  @override
  Future<UserLocalModel> getLocalUser() async {
    // TODO: implement getLocalUser
    throw UnimplementedError();
  }
}
