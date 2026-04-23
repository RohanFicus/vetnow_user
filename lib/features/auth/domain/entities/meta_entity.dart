// domain/entities/meta_entity.dart
class MetaEntity {
  final String? accessToken;
  final int? expiresIn;
  final String? refreshToken;

  MetaEntity({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
  });
}
