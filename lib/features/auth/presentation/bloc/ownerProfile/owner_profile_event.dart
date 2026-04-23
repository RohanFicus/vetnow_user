import 'package:equatable/equatable.dart';

abstract class OwnerProfileEvent extends Equatable {
  const OwnerProfileEvent();

  @override
  List<Object?> get props => [];
}

class FirstNameChanged extends OwnerProfileEvent {
  final String firstName;
  const FirstNameChanged(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class LastNameChanged extends OwnerProfileEvent {
  final String lastName;
  const LastNameChanged(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class EmailChanged extends OwnerProfileEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class CityChanged extends OwnerProfileEvent {
  final String city;
  const CityChanged(this.city);

  @override
  List<Object?> get props => [city];
}


class CountryChanged extends OwnerProfileEvent {
  final String country;
  const CountryChanged(this.country);

  @override
  List<Object?> get props => [country];
}

class StateChanged extends OwnerProfileEvent {
  final String state;
  const StateChanged(this.state);

  @override
  List<Object?> get props => [state];
}

class AddressSelected extends OwnerProfileEvent {
  final String country;
  final String state;
  final String city;
  final String address;

  const AddressSelected({required this.country, required this.state, required this.city, required this.address});

  @override
  List<Object?> get props => [country, state, city , address];
}

class OnSubmitted extends OwnerProfileEvent {}

class OwnerProfileCallLocally extends OwnerProfileEvent {}

class OwnerDashBoardCallLocally extends OwnerProfileEvent {}

class ClearSharedPref extends OwnerProfileEvent {}
