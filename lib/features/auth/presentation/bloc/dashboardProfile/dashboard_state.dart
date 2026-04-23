import 'package:equatable/equatable.dart';
import 'package:vetnow_user/features/auth/data/models/appointment_booking_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_success_model.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/symptoms_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/assessment_question_entity.dart';

class DashboardState extends Equatable {
  final User? user;
  final List<Pets> pets;
  final List<AppointmentResponse> appointments; // ✅ ADDED
  final List<SymptomsResponseModel> symptomsList; // ✅ ADDED

  final DoctorProfileResponse? doctorProfile; // ✅ ADDED
  final DoctorAvailabilityResponse? doctorAvailability; // ✅ ADDED

  final List<AssessmentResponseModel> assessmentList;
  final List<AssessmentQuestionEntity> answersList;
  final List<String>? categories;

  final bool isLoading;
  final bool bookingSuccess; // ✅ ADDED
  final bool paymentSuccess; // ✅ ADDED
  final String? error;
  final String? selectedSpeciesId;
  final AppointmentBookingResponseModel? lastBookedAppointment; // ✅ UPDATED

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;

  final int currentStep;
  final AssessmentSuccessModel? assessmentSuccessModel;

  const DashboardState({
    this.user,
    this.pets = const [],
    this.appointments = const [], // ✅
    this.symptomsList = const [], // ✅
    this.doctorProfile, // ✅
    this.doctorAvailability,
    this.assessmentList = const [],
    this.answersList = const [],
    this.categories = const [],
    this.isLoading = false,
    this.bookingSuccess = false, // ✅
    this.paymentSuccess = false, // ✅
    this.selectedSpeciesId,
    this.lastBookedAppointment, // ✅
    this.error,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.currentStep = 0,
    this.assessmentSuccessModel,
  });

  factory DashboardState.initial() => const DashboardState(
    user: null,
    pets: [],
    appointments: [], // ✅
    symptomsList: [], // ✅
    doctorProfile: null, // ✅
    doctorAvailability: null,
    assessmentList: [],
    answersList: [],
    categories: [],
    isLoading: false,
    bookingSuccess: false, // ✅
    paymentSuccess: false, // ✅
    error: null,
    selectedSpeciesId: null,
    lastBookedAppointment: null, // ✅
    firstName: null,
    lastName: null,
    mobile: null,
    email: null,
    currentStep: 0,
    assessmentSuccessModel: null,
  );

  DashboardState copyWith({
    User? user,
    List<Pets>? pets,
    List<AppointmentResponse>? appointments, // ✅
    List<SymptomsResponseModel>? symptomsList, // ✅
    DoctorProfileResponse? doctorProfile, // ✅
    DoctorAvailabilityResponse? doctorAvailability,

    List<AssessmentResponseModel>? assessmentList,
    List<AssessmentQuestionEntity>? answersList,
    List<String>? categories,

    bool? isLoading,
    bool? bookingSuccess, // ✅
    bool? paymentSuccess, // ✅
    String? selectedSpeciesId,
    AppointmentBookingResponseModel? lastBookedAppointment, // ✅
    String? error,

    String? firstName,
    String? lastName,
    String? email,
    String? mobile,

    int? currentStep,
    AssessmentSuccessModel? assessmentSuccessModel,
  }) {
    return DashboardState(
      user: user ?? this.user,
      pets: pets ?? this.pets,
      appointments: appointments ?? this.appointments, // ✅
      symptomsList: symptomsList ?? this.symptomsList, // ✅
      doctorProfile: doctorProfile ?? this.doctorProfile, // ✅
      doctorAvailability: doctorAvailability ?? this.doctorAvailability,

      assessmentList: assessmentList ?? this.assessmentList,
      answersList: answersList ?? this.answersList,
      categories: categories ?? this.categories,

      isLoading: isLoading ?? this.isLoading,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess, // ✅
      paymentSuccess: paymentSuccess ?? this.paymentSuccess, // ✅
      selectedSpeciesId: selectedSpeciesId ?? this.selectedSpeciesId,
      lastBookedAppointment: lastBookedAppointment ?? this.lastBookedAppointment, // ✅
      error: error,

      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,

      currentStep: currentStep ?? this.currentStep,
      assessmentSuccessModel:
      assessmentSuccessModel ?? this.assessmentSuccessModel,
    );
  }

  @override
  List<Object?> get props => [
    user,
    pets,
    appointments,
    symptomsList,
    doctorProfile, // ✅ IMPORTANT
    doctorAvailability,

    assessmentList,
    answersList,
    categories,
    isLoading,
    bookingSuccess, // ✅
    paymentSuccess, // ✅
    error,
    currentStep,
    selectedSpeciesId,
    lastBookedAppointment, // ✅
    assessmentSuccessModel,
  ];
}
