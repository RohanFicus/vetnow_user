class OtpResponseModel {
  final String requestId;
  final int expiresIn;

  OtpResponseModel({
    required this.requestId,
    required this.expiresIn,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      requestId: json['requestId'],
      expiresIn: json['expiresIn'],
    );
  }
}
