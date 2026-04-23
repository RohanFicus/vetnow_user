import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vetnow_user/core/mock/mock_data.dart';
import 'package:vetnow_user/core/network/api_response_handler.dart';
import 'package:vetnow_user/features/auth/data/models/appointment_booking_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_success_model.dart';
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
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient client;

  DashboardRemoteDataSourceImpl(this.client);

  @override
  Future<ApiResponse<DashBoardResponseModal, void>> getDashboardApi() async {
    try {
      final response = await client.dio.get("/api/v1/pet-owner/dashboard");
      return ApiResponseHandler.handleResponse(
        response,
        (json) => DashBoardResponseModal.fromJson(json),
        null,
      );
    } catch (e) {
      return ApiResponse(
        status: true,
        message: 'Success (Mock)',
        data: MockData.dashboard(),
      );
    }
  }

  @override
  Future<ApiResponse<List<AssessmentResponseModel>, void>>
  getAssessmentQuestionsApi({required String speciesId}) async {
    try {
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
    } catch (e) {
      return ApiResponse(
        status: true,
        message: 'Success (Mock)',
        data: MockData.assessmentQuestions(),
      );
    }
  }

  @override
  Future<ApiResponse<List<SymptomsResponseModel>, void>> getSymptomsApi({
    required String speciesId,
  }) async {
    try {
      final response = await client.dio.get(
        "/api/v1/pet-owner/symptoms",
        queryParameters: {'speciesId': speciesId},
      );
      return ApiResponseHandler.handleResponse(
        response,
        (json) => (json as List)
            .map((e) => SymptomsResponseModel.fromJson(e))
            .toList(),
        null,
      );
    } catch (e) {
      return ApiResponse(
        status: true,
        message: 'Success (Mock)',
        data: MockData.symptoms(speciesId: speciesId),
      );
    }
  }

  @override
  Future<ApiResponse<AssessmentSuccessModel, void>> submitAnswers(
    AssessmentRequest? assessmentRequest,
  ) async {
    try {
      final response = await client.dio.post(
        "/api/v1/pet-health/assessments",
        data: assessmentRequest,
      );

      return ApiResponseHandler.handleResponse(
        response,
        (json) => AssessmentSuccessModel.fromJson(json),
        null,
      );
    } catch (e) {
      return ApiResponse(
        status: true,
        message: 'Success (Mock)',
        data: MockData.assessmentSuccess(petId: assessmentRequest?.petId ?? 'pet-001'),
      );
    }
  }

  @override
  Future<ApiResponse<AppointmentBookingResponseModel, void>> bookAppointment(
    AppointmentRequest appointmentRequest,
  ) async {
    try {
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
    } catch (e) {
      return ApiResponse(
        status: true,
        message: 'Success (Mock)',
        data: AppointmentBookingResponseModel(
          appointmentId: "APT-${DateTime.now().millisecondsSinceEpoch}",
          paymentOrderId: "order_demo_${DateTime.now().millisecondsSinceEpoch}",
          amount: 110000, // 1100 in paise
        ),
      );
    }
  }

  @override
  Future<ApiResponse<void, void>> verifyPayment(
    PaymentVerifyRequest paymentVerifyRequest,
  ) async {
    try {
      final response = await client.dio.post(
        "/api/v1/payments/verify",
        data: paymentVerifyRequest.toJson(),
      );
      return ApiResponseHandler.handleResponse(response, (json) => null, null);
    } catch (e) {
      return ApiResponse(
        status: true,
        message: 'Success (Mock)',
        data: null,
      );
    }
  }
}
