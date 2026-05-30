import 'package:equatable/equatable.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/payment_verify_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/assessment_question_entity.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class AnswerSelected extends DashboardEvent {
  final AssessmentQuestionEntity? assessmentQuestionEntity;

  const AnswerSelected(this.assessmentQuestionEntity);

  @override
  List<Object?> get props => [assessmentQuestionEntity];
}

class SpeciesIdChanged extends DashboardEvent {
  final String? speciesId;

  const SpeciesIdChanged(this.speciesId);

  @override
  List<Object?> get props => [speciesId];
}

class LastNameChanged extends DashboardEvent {
  final String lastName;

  const LastNameChanged(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class EmailChanged extends DashboardEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class CityChanged extends DashboardEvent {
  final String city;

  const CityChanged(this.city);

  @override
  List<Object?> get props => [city];
}

class CurrentStepChanged extends DashboardEvent {
  final int currentStep;

  const CurrentStepChanged(this.currentStep);

  @override
  List<Object?> get props => [currentStep];
}

class OnDashboardCall extends DashboardEvent {}

class OnAssessmentQuestionCall extends DashboardEvent {
  final String speciesId;

  const OnAssessmentQuestionCall(this.speciesId);

  @override
  List<Object?> get props => [speciesId];
}

class OwnerProfileCallLocally extends DashboardEvent {}

class FetchAssessmentQuestions extends DashboardEvent {
  final List<AssessmentResponseModel>? assessments;

  const FetchAssessmentQuestions({this.assessments});

  @override
  List<Object?> get props => [assessments];
}

class SubmitAnswers extends DashboardEvent {
  final String petId;

  const SubmitAnswers(this.petId);

  @override
  List<Object?> get props => [petId];
}

class BookAppointmentEvent extends DashboardEvent {
  final AppointmentRequest appointmentRequest;

  const BookAppointmentEvent(this.appointmentRequest);

  @override
  List<Object?> get props => [appointmentRequest];
}

class VerifyPaymentEvent extends DashboardEvent {
  final PaymentVerifyRequest paymentVerifyRequest;

  const VerifyPaymentEvent(this.paymentVerifyRequest);

  @override
  List<Object?> get props => [paymentVerifyRequest];
}

class FetchSymptomsEvent extends DashboardEvent {
  final String speciesId;

  const FetchSymptomsEvent(this.speciesId);

  @override
  List<Object?> get props => [speciesId];
}

class FetchAvailableSlotsEvent extends DashboardEvent {
  final String doctorId;
  final String date;

  const FetchAvailableSlotsEvent({required this.doctorId, required this.date});

  @override
  List<Object?> get props => [doctorId, date];
}
