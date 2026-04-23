import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vetnow_user/core/config/app_mode.dart';
import 'package:vetnow_user/core/mock/mock_data.dart';
import 'package:vetnow_user/core/network/api_response_handler.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/meta_model.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/api_response.dart';
import '../../data/models/otp_response_model.dart';
import '../models/owner_profile_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<OtpResponseModel, void>> sendOtp({
    required String phone,
    required String countryCode,
  });

  Future<ApiResponse<DashBoardResponseModal, MetaModel>> verifyOtp({
    required String requestId,
    required String otp,
  });

  Future<ApiResponse<OwnerProfileResponseModel, void>> createOwnerProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required File image,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<ApiResponse<OtpResponseModel, void>> sendOtp({
    required String phone,
    required String countryCode,
  }) async {
    final response = await client.dio.post(
      "/api/v1/auth/otp/request",
      data: {"mobile": phone, "countryCode": countryCode},
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => OtpResponseModel.fromJson(json),
      null,
    );
  }

  @override
  Future<ApiResponse<DashBoardResponseModal, MetaModel>> verifyOtp({
    required String requestId,
    required String otp,
  }) async {
    final response = await client.dio.post(
      "/api/v1/auth/otp/verify",
      data: {"requestId": requestId, "otp": otp},
    );

    print("Meta:: ${response.data}");

    return ApiResponseHandler.handleResponse(
      response,
      (json) => DashBoardResponseModal.fromJson(json),
      (json) => MetaModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<OwnerProfileResponseModel, void>> createOwnerProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required File image,
  }) async {
    print("createOwnerProfile");
    final formData = FormData.fromMap({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "address": address,
    });
    // PRINT FIELDS
    for (var field in formData.fields) {
      print("FIELD => ${field.key}: ${field.value}");
    }
    final response = await client.dio.put(
      "/api/v1/user/pet_owner_profile",
      data: formData,
      //options: Options(contentType: 'multipart/form-data'),
    );

    return ApiResponseHandler.handleResponse(
      response,
      (json) => OwnerProfileResponseModel.fromJson(json),
      null,
    );
  }
}
