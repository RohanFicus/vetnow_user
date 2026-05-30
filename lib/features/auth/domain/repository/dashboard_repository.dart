import 'package:vetnow_user/features/auth/data/models/appointment_booking_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_success_model.dart';
import 'package:vetnow_user/features/auth/data/models/available_slots_model.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/symptoms_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/assessment_request.dart';

import 'package:vetnow_user/features/auth/domain/entities/payment_verify_request.dart';

abstract class DashboardRepository {
  Future<DashBoardResponseModal> getDashBoardApi();
  Future<AssessmentSuccessModel> submitAnswers({
    required AssessmentRequest? assessmentRequest,
  });
  Future<List<AssessmentResponseModel>> getAssessmentQuestionsApi({
    required String speciesId,
  });
  Future<List<SymptomsResponseModel>> getSymptomsApi({
    required String speciesId,
  });
  Future<AppointmentBookingResponseModel> bookAppointment(
    AppointmentRequest appointmentRequest,
  );
  Future<void> verifyPayment(PaymentVerifyRequest paymentVerifyRequest);
  Future<AvailableSlotsModel> getAvailableSlots({
    required String doctorId,
    required String date,
  });
}
