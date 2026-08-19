import 'package:equatable/equatable.dart';

import '../../domain/entities/otp_entity.dart';

class SignInState extends Equatable {
  final String phone;
  final bool termsAccepted;
  final bool isButtonEnabled;
  final String selectedCountryCode;
  final String selectedCountryFlag;
  final bool isLoading;
  final String? error;
  final String? phoneError;
  final OtpEntity? otpResult;

  const SignInState({
    this.phone = '',
    this.termsAccepted = false,
    this.isButtonEnabled = false,
    this.selectedCountryCode = '+91',
    this.selectedCountryFlag = '🇮🇳',
    required this.isLoading,
    this.error,
    this.phoneError,
    this.otpResult,
  });

  factory SignInState.initial() => SignInState(
    phone: "",
    selectedCountryCode: '+91',
    selectedCountryFlag: '🇮🇳',
    termsAccepted: false,
    isButtonEnabled: false,
    isLoading: false,
    otpResult: null,
  );

  SignInState copyWith({
    String? phone,
    bool? termsAccepted,
    bool? isButtonEnabled,
    String? selectedCountryCode,
    String? selectedCountryFlag,
    bool? isLoading,
    String? error,
    String? phoneError,
    OtpEntity? otpResult,
  }) {
    return SignInState(
      phone: phone ?? this.phone,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
      selectedCountryFlag: selectedCountryFlag ?? this.selectedCountryFlag,
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
    selectedCountryCode,
    selectedCountryFlag,
    isLoading,
    error,
    phoneError,
  ];
}
