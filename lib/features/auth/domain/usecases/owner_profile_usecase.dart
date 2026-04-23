import 'dart:io';

import '../../domain/repository/auth_repository.dart';
import '../entities/owner_profile_entity.dart';

class OwnerProfileUseCase {
  final AuthRepository repository;

  OwnerProfileUseCase(this.repository);

  Future<OwnerProfileEntity> call({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required File image,
  }) {
    return repository.createOwnerProfile(
      image: image,
      lastName: lastName,
      firstName: firstName,
      email: email,
      address: address,
    );
  }
}
