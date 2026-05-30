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

class DashboardUseCase {
  final DashboardRepository repository;

  DashboardUseCase(this.repository);

  Future<DashBoardResponseModal> getDashBoardApi() {
    return repository.getDashBoardApi();
  }

  Future<List<AssessmentResponseModel>> getAssessmentQuestionsApi({
    required String speciesId,
  }) {
    return repository.getAssessmentQuestionsApi(speciesId: speciesId);
  }

  Future<List<SymptomsResponseModel>> getSymptomsApi({
    required String speciesId,
  }) {
    return repository.getSymptomsApi(speciesId: speciesId);
  }

  Future<AssessmentSuccessModel> submitAnswers({
    required AssessmentRequest? assessmentRequest,
  }) {
    return repository.submitAnswers(assessmentRequest: assessmentRequest);
  }

  Future<AppointmentBookingResponseModel> bookAppointment(AppointmentRequest appointmentRequest) {
    return repository.bookAppointment(appointmentRequest);
  }

  Future<void> verifyPayment(PaymentVerifyRequest paymentVerifyRequest) {
    return repository.verifyPayment(paymentVerifyRequest);
  }

  Future<AvailableSlotsModel> getAvailableSlots({
    required String doctorId,
    required String date,
  }) {
    return repository.getAvailableSlots(doctorId: doctorId, date: date);
  }
}
