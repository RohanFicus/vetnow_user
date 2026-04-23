import 'package:vetnow_user/features/auth/domain/entities/otp_verify_result.dart';

import '../../domain/repository/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<OtpVerifyResult> call({
    required String requestId,
    required String otp,
  }) {
    return repository.verifyOtp(requestId: requestId, otp: otp);
  }
}
