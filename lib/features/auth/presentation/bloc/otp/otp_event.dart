import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpChanged extends OtpEvent {
  final String otp;
  const OtpChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class OtpSubmitted extends OtpEvent {}

class OtpResendRequested extends OtpEvent {}
