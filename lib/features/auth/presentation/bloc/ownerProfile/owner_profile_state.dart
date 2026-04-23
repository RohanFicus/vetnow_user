import 'package:equatable/equatable.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/owner_profile_entity.dart';

class OwnerProfileState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String city;
  final String country;
  final String address;
  final String state;
  final String mobile;
  final bool isLoading;
  final String? error;
  final OwnerProfileEntity? ownerProfileEntity;
  final DoctorProfileResponse? doctorProfile; // ✅ ADDED
  final bool isProfileEdited; // 👈 NEW


  const OwnerProfileState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.address = '',
    this.mobile = '',
    this.isLoading = false,
    this.error,
    this.ownerProfileEntity,
    this.doctorProfile,
    this.isProfileEdited = false,

  });

  factory OwnerProfileState.initial() => OwnerProfileState(
    firstName: "",
    lastName: "",
    email: "",
    city: "",
    country: "",
    address: "",
    state: "",
    isLoading: false,
    ownerProfileEntity: null,
    doctorProfile: null,
    isProfileEdited: false
  );

  bool get isFormValid =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      country.isNotEmpty &&
      state.isNotEmpty &&
      city.isNotEmpty &&
      _isValidEmail(email);

  OwnerProfileState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? city,
    String? country,
    String? state,
    String? address,
    bool? isLoading,
    String? error,
    OwnerProfileEntity? ownerProfileEntity,
    DoctorProfileResponse? doctorProfile,
    bool? isProfileEdited,
  }) {
    return OwnerProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      city: city ?? this.city,
      state: state ?? this.state,
      address: address ?? this.address,
      country: country ?? this.country,
      mobile: mobile ?? this.mobile,
      isLoading: isLoading ?? this.isLoading,
      isProfileEdited: isProfileEdited ?? this.isProfileEdited  ,
      error: error,
      ownerProfileEntity: ownerProfileEntity,
      doctorProfile: doctorProfile,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    city,
    country,
    address,
    state,
    mobile,
    isLoading,
    error,
    ownerProfileEntity,
    doctorProfile, // ✅
  ];
}

bool _isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}
