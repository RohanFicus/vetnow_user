import '../../domain/repository/auth_repository.dart';
import '../entities/otp_entity.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<OtpEntity> call({required String phone, required String countryCode}) {
    return repository.sendOtp(phone: phone, countryCode: countryCode);
  }
}
