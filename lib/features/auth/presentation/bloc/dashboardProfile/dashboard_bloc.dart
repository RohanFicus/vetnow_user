import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/network/api_exception.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/assessment_question_entity.dart';
import 'package:vetnow_user/features/auth/domain/entities/assessment_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/owner_profile_entity.dart';
import 'package:vetnow_user/features/auth/domain/usecases/dashboard_usecase.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUseCase dashboardUseCase;
  final SecureStorageService storageService;

  DashboardBloc(this.dashboardUseCase, this.storageService)
    : super(DashboardState.initial()) {
    on<OnDashboardCall>(_onDashboardCall);
    on<AnswerSelected>(_onAnswerSelected);
    on<SpeciesIdChanged>(_onSpeciesIdChanged);
    on<CurrentStepChanged>(_onCurrentStepChanged);
    on<OnAssessmentQuestionCall>(_onAssessmentQuestionCall);
    //CompletedProfile
    on<OwnerProfileCallLocally>(_onOwnerProfileCallLocally);
    on<FetchAssessmentQuestions>(_onFetchAssessmentQuestions);
    on<SubmitAnswers>(_onSubmitAnswers);
    on<BookAppointmentEvent>(_onBookAppointment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<FetchSymptomsEvent>(_onFetchSymptoms);
  }

  Future<void> _onFetchSymptoms(
    FetchSymptomsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final symptoms = await dashboardUseCase.getSymptomsApi(
        speciesId: event.speciesId,
      );
      emit(state.copyWith(isLoading: false, symptomsList: symptoms));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, paymentSuccess: false));
    try {
      await dashboardUseCase.verifyPayment(event.paymentVerifyRequest);
      emit(state.copyWith(isLoading: false, paymentSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
          paymentSuccess: false,
        ),
      );
    }
  }

  Future<void> _onBookAppointment(
    BookAppointmentEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, bookingSuccess: false));
    try {
      final appointmentBookingResponse =
          await dashboardUseCase.bookAppointment(event.appointmentRequest);
      emit(
        state.copyWith(
          isLoading: false,
          bookingSuccess: true,
          lastBookedAppointment: appointmentBookingResponse,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
          bookingSuccess: false,
        ),
      );
    }
  }

  void _onAnswerSelected(AnswerSelected event, Emitter<DashboardState> emit) {
    if (event.assessmentQuestionEntity == null) return;

    final updatedList = List<AssessmentQuestionEntity>.from(state.answersList);

    final index = updatedList.indexWhere(
      (e) => e.category == event.assessmentQuestionEntity!.category,
    );

    if (index != -1) {
      updatedList[index] = event.assessmentQuestionEntity!;
    } else {
      updatedList.add(event.assessmentQuestionEntity!);
    }

    final isLastQuestion = state.currentStep >= state.assessmentList.length - 1;

    emit(
      state.copyWith(
        answersList: updatedList,
        currentStep: isLastQuestion ? state.currentStep : state.currentStep + 1,
      ),
    );
  }

  void _onSpeciesIdChanged(
    SpeciesIdChanged event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(selectedSpeciesId: event.speciesId, error: null));
  }

  void _onCurrentStepChanged(
    CurrentStepChanged event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(currentStep: event.currentStep, error: null));
  }

  Future<void> _onDashboardCall(
    OnDashboardCall event,
    Emitter<DashboardState> emit,
  ) async {
    final requestId = await storageService.getRequestId();

    if (requestId == null) {
      throw Exception("Request ID not found");
    }
    print("Pressed");
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await dashboardUseCase.getDashBoardApi();
      DashBoardResponseModal dashBoardResponseModal = result;
      storageService.saveDashboardDataJson(dashBoardResponseModal.toJson());

      OwnerProfileEntity ownerProfileEntity = OwnerProfileEntity(
        firstName: dashBoardResponseModal.user?.firstName.toString(),
        lastName: dashBoardResponseModal.user?.lastName.toString(),
        mobile: dashBoardResponseModal.user?.mobile.toString(),
        email: dashBoardResponseModal.user?.email.toString(),
        isActive: dashBoardResponseModal.user?.isActive,
        role: dashBoardResponseModal.user?.role.toString(),
        id: dashBoardResponseModal.user?.id.toString(),
        profileImage: dashBoardResponseModal.user?.profileImage.toString(),
        address: dashBoardResponseModal.user?.address.toString(),
      );
      storageService.saveCustomerProfileJson(ownerProfileEntity.toJson());
      emit(
        state.copyWith(
          user: result.user,
          pets: result.pets,
          appointments: result.appointmentResponseList,
          doctorProfile: result.doctorProfileResponse,
          doctorAvailability: result.doctorAvailabilityResponse,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onAssessmentQuestionCall(
    OnAssessmentQuestionCall event,
    Emitter<DashboardState> emit,
  ) async {
    final requestId = await storageService.getRequestId();

    if (requestId == null) {
      throw Exception("Request ID not found");
    }
    print("Pressed");
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await dashboardUseCase.getAssessmentQuestionsApi(
        speciesId: event.speciesId.toString(),
      );
      emit(state.copyWith(assessmentList: result, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onOwnerProfileCallLocally(
    OwnerProfileCallLocally event,
    Emitter<DashboardState> emit,
  ) async {
    final json = await storageService.getDashboardDataJson();
    final dashBoard = DashBoardResponseModal.fromJson(json!);
    if (dashBoard.user != null) {
      emit(
        state.copyWith(
          isLoading: false,
          user: dashBoard.user,
          pets: dashBoard.pets,
          appointments: dashBoard.appointmentResponseList,
          doctorProfile: dashBoard.doctorProfileResponse,
          doctorAvailability: dashBoard.doctorAvailabilityResponse,
        ),
      );
    }
  }

  Future<void> _onFetchAssessmentQuestions(
    FetchAssessmentQuestions event,
    Emitter<DashboardState> emit,
  ) async {
    final questions = event.assessments;
    emit(
      state.copyWith(
        assessmentList: event.assessments,
        categories: questions
            ?.map((e) => e.category)
            .whereType<String>() // removes nulls safely
            .toSet()
            .toList(),
      ),
    );
  }

  Future<void> _onSubmitAnswers(
    SubmitAnswers event,
    Emitter<DashboardState> emit,
  ) async {
    final requestId = await storageService.getRequestId();
    AssessmentRequest assessmentRequest = AssessmentRequest(
      petId: event.petId,
      answers: state.answersList,
      assessmentType: 'GENERAL',
    );
    if (requestId == null) {
      throw Exception("Request ID not found");
    }
    print("Pressed ${assessmentRequest.toJson()}");
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        assessmentSuccessModel: null,
      ),
    );
    try {
      final result = await dashboardUseCase.submitAnswers(
        assessmentRequest: assessmentRequest,
      );

      emit(state.copyWith(isLoading: false, assessmentSuccessModel: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Failed to submit assessment"));
    }
  }
}
