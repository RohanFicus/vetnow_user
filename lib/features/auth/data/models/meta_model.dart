class MetaModel {
  final TokenModel? token;

  MetaModel({this.token});

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      token: json['token'] != null ? TokenModel.fromJson(json['token']) : null,
    );
  }
}

class TokenModel {
  final String accessToken;
  final int expiresIn;
  final String refreshToken;

  TokenModel({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
      refreshToken: json['refreshToken'],
    );
  }
}
