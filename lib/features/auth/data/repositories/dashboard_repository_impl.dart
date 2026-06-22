import 'package:vetnow_user/features/auth/data/datasources/dashboard_local_data_source.dart';
import 'package:vetnow_user/features/auth/data/datasources/dashboard_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/models/appointment_booking_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_success_model.dart';
import 'package:vetnow_user/features/auth/data/models/available_slots_model.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/symptoms_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/assessment_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/payment_verify_request.dart';
import 'package:vetnow_user/features/auth/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDataSource;

  DashboardRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<DashBoardResponseModal> getDashBoardApi() async {
    try {
      final response = await remoteDataSource.getDashboardApi();

      // If server returned data (even if it's the mock data from RemoteDataSource catch block)
      if (response.status && response.data != null) {
        // Only update local DB if it's NOT just the default empty object
        // and we want to ensure we persist the latest server response
        await localDataSource.cacheDashboard(response.data!);
        return response.data!;
      }
    } catch (e) {
      // API call failed completely (No internet / Server 500)
    }

    // Fallback to local DB for Profile, Pets, and Appointments
    final cachedData = await localDataSource.getCachedDashboard();
    if (cachedData != null) {
      return cachedData;
    }

    // If no cache exists, return empty model
    return DashBoardResponseModal();
  }

  @override
  Future<List<AssessmentResponseModel>> getAssessmentQuestionsApi({
    required String speciesId,
  }) async {
    final response = await remoteDataSource.getAssessmentQuestionsApi(
      speciesId: speciesId,
    );
    return response.data ?? [];
  }

  @override
  Future<List<SymptomsResponseModel>> getSymptomsApi({
    required String speciesId,
  }) async {
    final response = await remoteDataSource.getSymptomsApi(
      speciesId: speciesId,
    );
    return response.data ?? [];
  }

  @override
  Future<AssessmentSuccessModel> submitAnswers({
    required AssessmentRequest? assessmentRequest,
  }) async {
    final response = await remoteDataSource.submitAnswers(assessmentRequest);

    AssessmentSuccessModel assessmentSuccessModel =
        response.data ?? AssessmentSuccessModel();
    return assessmentSuccessModel;
  }

  @override
  Future<AppointmentBookingResponseModel> bookAppointment(
    AppointmentRequest appointmentRequest,
  ) async {
    final response = await remoteDataSource.bookAppointment(appointmentRequest);
    return response.data ??
        AppointmentBookingResponseModel(
          appointmentId: '',
          paymentOrderId: '',
          amount: 0,
        );
  }

  @override
  Future<void> verifyPayment(PaymentVerifyRequest paymentVerifyRequest) async {
    await remoteDataSource.verifyPayment(paymentVerifyRequest);
    // Note: Ideally, after successful payment verification,
    // we should trigger a dashboard refresh to update the local appointment status.
  }

  @override
  Future<AvailableSlotsModel> getAvailableSlots({
    required String doctorId,
    required String date,
  }) async {
    final response = await remoteDataSource.getAvailableSlotsApi(
      doctorId: doctorId,
      date: date,
    );
    return response.data ?? AvailableSlotsModel();
  }
}
