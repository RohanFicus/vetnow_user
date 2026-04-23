import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/owner_profile_entity.dart';
import 'package:vetnow_user/features/auth/domain/usecases/owner_profile_usecase.dart';

import 'owner_profile_event.dart';
import 'owner_profile_state.dart';

class OwnerProfileBloc extends Bloc<OwnerProfileEvent, OwnerProfileState> {
  final OwnerProfileUseCase ownerProfileUseCase;
  final SecureStorageService storageService;

  OwnerProfileBloc(this.ownerProfileUseCase, this.storageService)
    : super(OwnerProfileState.initial()) {
    on<FirstNameChanged>(_onFirstNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<EmailChanged>(_onEmailNameChanged);
    on<CityChanged>(_onCityNameChanged);
    on<CountryChanged>(_onCountryChanged);
    on<AddressSelected>(_onAddressSelected);
    on<StateChanged>(_onStateChanged);
    on<OnSubmitted>(_onOnSubmitted);

    //CompletedProfile
    on<OwnerProfileCallLocally>(_onOwnerProfileCallLocally);
    on<OwnerDashBoardCallLocally>(_onOwnerDashBoardCallLocally);
    on<ClearSharedPref>(_onClearSharedPref);
  }

  void _onFirstNameChanged(
    FirstNameChanged event,
    Emitter<OwnerProfileState> emit,
  ) {
    emit(
      state.copyWith(
        firstName: event.firstName,
        error: null,
        isProfileEdited: true,
      ),
    );
  }

  void _onLastNameChanged(
    LastNameChanged event,
    Emitter<OwnerProfileState> emit,
  ) {
    emit(
      state.copyWith(
        lastName: event.lastName,
        error: null,
        isProfileEdited: true,
      ),
    );
  }

  void _onEmailNameChanged(
    EmailChanged event,
    Emitter<OwnerProfileState> emit,
  ) {
    emit(
      state.copyWith(email: event.email, error: null, isProfileEdited: true),
    );
  }

  // Handler
  void _onAddressSelected(
    AddressSelected event,
    Emitter<OwnerProfileState> emit,
  ) {
    emit(
      state.copyWith(
        country: event.country,
        state: event.state,
        city: event.city,
        address: event.address,
        isProfileEdited: true,
      ),
    );
  }

  void _onCountryChanged(
    CountryChanged event,
    Emitter<OwnerProfileState> emit,
  ) {
    emit(state.copyWith(country: event.country, error: null));
  }

  void _onStateChanged(StateChanged event, Emitter<OwnerProfileState> emit) {
    emit(state.copyWith(state: event.state, error: null));
  }

  void _onCityNameChanged(CityChanged event, Emitter<OwnerProfileState> emit) {
    emit(state.copyWith(city: event.city, error: null));
  }

  Future<void> _onOnSubmitted(
    OnSubmitted event,
    Emitter<OwnerProfileState> emit,
  ) async {
    final token = await storageService.getToken();

    if (token == null) {
      throw Exception("Request ID not found");
    }
    print("Pressed $token");
    // API call or navigation handled via BlocListener
    emit(
      state.copyWith(isLoading: true, error: null, ownerProfileEntity: null),
    );
    try {
      final result = await ownerProfileUseCase(
        email: state.email,
        firstName: state.firstName,
        lastName: state.lastName,
        address: "${state.city}, ${state.state}, ${state.country}",
        image: File(''),
      );
      print("Id${result.role}");
      OwnerProfileEntity ownerProfileEntity = result;
      storageService.saveCustomerProfileJson(ownerProfileEntity.toJson());
      emit(state.copyWith(isLoading: false, ownerProfileEntity: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Failed to send OTP"));
    }
  }

  Future<void> _onOwnerProfileCallLocally(
    OwnerProfileCallLocally event,
    Emitter<OwnerProfileState> emit,
  ) async {
    final json = await storageService.getCustomerProfileJson();
    final petProfile = OwnerProfileEntity.fromJson(json!);
    if (petProfile.id != null) {
      emit(
        state.copyWith(
          isLoading: false,
          firstName: petProfile.firstName,
          email: petProfile.email,
          lastName: petProfile.lastName,
          mobile: petProfile.mobile,
          address: petProfile.address,
        ),
      );
    }
  }

  Future<void> _onOwnerDashBoardCallLocally(
    OwnerDashBoardCallLocally event,
    Emitter<OwnerProfileState> emit,
  ) async {
    final json = await storageService.getDashboardDataJson();
    final dashBoard = DashBoardResponseModal.fromJson(json!);
    if (dashBoard.user != null) {
      emit(
        state.copyWith(
          isLoading: false,
          doctorProfile: dashBoard.doctorProfileResponse, // ✅
        ),
      );
    }
  }

  Future<void> _onClearSharedPref(
    ClearSharedPref event,
    Emitter<OwnerProfileState> emit,
  ) async {
    final json = await storageService.getCustomerProfileJson();
    final petProfile = OwnerProfileEntity.fromJson(json!);
    await storageService.clearAll();
    if (petProfile.id != null) {
      emit(state.copyWith(isLoading: false, error: "Logged Out"));
    }
  }
}
