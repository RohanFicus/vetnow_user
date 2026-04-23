import 'package:vetnow_user/features/auth/domain/repository/auth_repository.dart';

import '../../data/models/local/user_local_model.dart';

class GetLocalUserUseCase {
  final AuthRepository repository;

  GetLocalUserUseCase(this.repository);

  Future<UserLocalModel> call() {
    return repository.getLocalUser();
  }
}
