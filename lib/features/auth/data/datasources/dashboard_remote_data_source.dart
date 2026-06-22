import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vetnow_user/core/network/api_response_handler.dart';
import 'package:vetnow_user/features/auth/data/models/appointment_booking_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_success_model.dart';
import 'package:vetnow_user/features/auth/data/models/available_slots_model.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/symptoms_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/assessment_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/payment_verify_request.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/api_response.dart';

abstract class DashboardRemoteDataSource {
  Future<ApiResponse<DashBoardResponseModal, void>> getDashboardApi();

  Future<ApiResponse<List<AssessmentResponseModel>, void>>
  getAssessmentQuestionsApi({required String speciesId});

  Future<ApiResponse<List<SymptomsResponseModel>, void>> getSymptomsApi({
    required String speciesId,
  });

  Future<ApiResponse<AssessmentSuccessModel, void>> submitAnswers(
    AssessmentRequest? assessmentRequest,
  );

  Future<ApiResponse<AppointmentBookingResponseModel, void>> bookAppointment(
    AppointmentRequest appointmentRequest,
  );

  Future<ApiResponse<void, void>> verifyPayment(
    PaymentVerifyRequest paymentVerifyRequest,
  );

  Future<ApiResponse<AvailableSlotsModel, void>> getAvailableSlotsApi({
    required String doctorId,
    required String date,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient client;

  DashboardRemoteDataSourceImpl(this.client);

  @override
  Future<ApiResponse<DashBoardResponseModal, void>> getDashboardApi() async {
    final response = await client.dio.get("/api/v1/app/dashboard");
    return ApiResponseHandler.handleResponse(
      response,
      (json) => DashBoardResponseModal.fromJson(json),
      null,
    );
  }

  @override
  Future<ApiResponse<List<AssessmentResponseModel>, void>>
  getAssessmentQuestionsApi({required String speciesId}) async {
    final response = await client.dio.get(
      "/api/v1/pet-health/questions/$speciesId",
    );

    return ApiResponseHandler.handleResponse(
      response,
      (json) => (json as List)
          .map((e) => AssessmentResponseModel.fromJson(e))
          .toList(),
      null,
    );
  }

  @override
  Future<ApiResponse<List<SymptomsResponseModel>, void>> getSymptomsApi({
    required String speciesId,
  }) async {
    final response = await client.dio.get(
      "/api/v1/pet-owner/symptoms",
      queryParameters: {'speciesId': speciesId},
    );
    return ApiResponseHandler.handleResponse(
      response,
      (json) =>
          (json as List).map((e) => SymptomsResponseModel.fromJson(e)).toList(),
      null,
    );
  }

  @override
  Future<ApiResponse<AssessmentSuccessModel, void>> submitAnswers(
    AssessmentRequest? assessmentRequest,
  ) async {
    final response = await client.dio.post(
      "/api/v1/pet-health/assessments",
      data: assessmentRequest,
    );

    return ApiResponseHandler.handleResponse(
      response,
      (json) => AssessmentSuccessModel.fromJson(json),
      null,
    );
  }

  @override
  Future<ApiResponse<AppointmentBookingResponseModel, void>> bookAppointment(
    AppointmentRequest appointmentRequest,
  ) async {
    final Map<String, dynamic> data = appointmentRequest.toJson();
    debugPrint("API REQUEST: /api/v1/pet-owner/appointments - DATA: $data");

    if (appointmentRequest.attachments != null) {
      data['attachments'] = await MultipartFile.fromFile(
        appointmentRequest.attachments!.path,
        filename: appointmentRequest.attachments!.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(data);

    final response = await client.dio.post(
      "/api/v1/pet-owner/appointments",
      data: formData,
    );

    return ApiResponseHandler.handleResponse(
      response,
      (json) => AppointmentBookingResponseModel.fromJson(json),
      null,
    );
  }

  @override
  Future<ApiResponse<void, void>> verifyPayment(
    PaymentVerifyRequest paymentVerifyRequest,
  ) async {
    final response = await client.dio.post(
      "/api/v1/payments/verify",
      data: paymentVerifyRequest.toJson(),
    );
    return ApiResponseHandler.handleResponse(response, (json) => null, null);
  }

  @override
  Future<ApiResponse<AvailableSlotsModel, void>> getAvailableSlotsApi({
    required String doctorId,
    required String date,
  }) async {
    final response = await client.dio.get(
      "/api/v1/pet-owner/$doctorId/available-slots",
      queryParameters: {'date': date},
    );
    return ApiResponseHandler.handleResponse(
      response,
      (json) => AvailableSlotsModel.fromJson(json),
      null,
    );
  }
}
