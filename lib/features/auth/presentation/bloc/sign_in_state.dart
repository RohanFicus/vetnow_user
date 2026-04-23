import 'package:equatable/equatable.dart';

import '../../domain/entities/otp_entity.dart';

class SignInState extends Equatable {
  final String phone;
  final bool termsAccepted;
  final bool isButtonEnabled;
  final String selectedCountry;
  final bool isLoading;
  final String? error;
  final String? phoneError;
  final OtpEntity? otpResult;

  const SignInState({
    this.phone = '',
    this.termsAccepted = false,
    this.isButtonEnabled = false,
    this.selectedCountry = 'India',
    required this.isLoading,
    this.error,
    this.phoneError,
    this.otpResult,
  });

  factory SignInState.initial() => SignInState(
    phone: "",
    selectedCountry: 'India',
    termsAccepted: false,
    isButtonEnabled: false,
    isLoading: false,
    otpResult: null,
  );

  SignInState copyWith({
    String? phone,
    bool? termsAccepted,
    bool? isButtonEnabled,
    String? selectedCountry,
    bool? isLoading,
    String? error,
    String? phoneError,
    OtpEntity? otpResult,
  }) {
    return SignInState(
      phone: phone ?? this.phone,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      isLoading: isLoading ?? this.isLoading,
      phoneError: phoneError ?? this.phoneError,
      error: error,
      otpResult: otpResult,
    );
  }

  @override
  List<Object?> get props => [
    phone,
    termsAccepted,
    isButtonEnabled,
    selectedCountry,
    isLoading,
    error,
    phoneError,
  ];
}
