import 'package:equatable/equatable.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';

class OtpState extends Equatable {
  final String otp;
  final bool isComplete;
  final bool isLoading;
  final String? error;
  final DashBoardResponseModal? otpVerifyEntity;

  const OtpState({
    this.otp = '',
    this.isComplete = false,
    this.isLoading = false,
    this.error,
    this.otpVerifyEntity,
  });

  factory OtpState.initial() => OtpState(
    otp: "",
    isComplete: false,
    isLoading: false,
    otpVerifyEntity: null,
  );

  OtpState copyWith({
    String? otp,
    bool? isComplete,
    bool? isLoading,
    String? error,
    DashBoardResponseModal? otpVerifyEntity,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      isComplete: isComplete ?? this.isComplete,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      otpVerifyEntity: otpVerifyEntity,
    );
  }

  @override
  List<Object?> get props => [otp, isComplete, isLoading, error];
}
