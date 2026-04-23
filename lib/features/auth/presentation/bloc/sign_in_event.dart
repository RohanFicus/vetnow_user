import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class PhoneChanged extends SignInEvent {
  final String phone;

  const PhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class TermsToggled extends SignInEvent {
  final bool accepted;

  const TermsToggled(this.accepted);

  @override
  List<Object?> get props => [accepted];
}

class CountrySelected extends SignInEvent {
  final String country;

  const CountrySelected(this.country);

  @override
  List<Object?> get props => [country];
}

class SubmitPressed extends SignInEvent {}
