import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/network/api_exception.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';

import '../../domain/usecases/send_otp_usecase.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SendOtpUseCase sendOtpUseCase;
  final SecureStorageService storageService;

  SignInBloc(this.sendOtpUseCase, this.storageService)
    : super(SignInState.initial()) {
    on<PhoneChanged>(_onPhoneChanged);
    on<TermsToggled>(_onTermsToggled);
    on<CountrySelected>(_onCountrySelected);
    on<SubmitPressed>(_onSubmit);
  }

  void _onPhoneChanged(PhoneChanged event, Emitter<SignInState> emit) {
    final isValidPhone = event.phone.length == 10;
    String? error;
    if (event.phone.isEmpty) {
      error = "Required";
    } else if (event.phone.length != 10) {
      error = "Invalid";
    } else {
      error = null;
    }

    emit(
      state.copyWith(
        phone: event.phone,
        phoneError: error,
        isButtonEnabled: isValidPhone && state.termsAccepted,
      ),
    );
  }

  void _onTermsToggled(TermsToggled event, Emitter<SignInState> emit) {
    emit(
      state.copyWith(
        termsAccepted: event.accepted,
        isButtonEnabled: event.accepted && state.phone.length == 10,
      ),
    );
  }

  void _onCountrySelected(CountrySelected event, Emitter<SignInState> emit) {
    emit(state.copyWith(
      selectedCountryCode: event.code,
      selectedCountryFlag: event.flag,
    ));
  }

  Future<void> _onSubmit(SubmitPressed event, Emitter<SignInState> emit) async {
    print("Pressed");
    // API call or navigation handled via BlocListener
    emit(state.copyWith(isLoading: true, error: null, otpResult: null));
    try {
      final result = await sendOtpUseCase(
        phone: state.phone,
        countryCode: state.selectedCountryCode,
      );
      if (result.requestId == null || result.requestId!.isEmpty) {
        throw ApiException("Failed to generate OTP request ID", 0);
      }
      storageService.saveRequestId(result.requestId!);
      print("Id${result.requestId}");
      emit(state.copyWith(isLoading: false, otpResult: result));
    } catch (e) {
      String message = "Failed to send OTP";
      if (e is ApiException) {
        message = e.message;
      }
      emit(state.copyWith(isLoading: false, error: message));
    }
  }
}
