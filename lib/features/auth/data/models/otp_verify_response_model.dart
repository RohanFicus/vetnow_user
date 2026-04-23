class OtpVerifyResponseModel {
  final String userId;
  final String mobile;
  final String role;

  OtpVerifyResponseModel({
    required this.userId,
    required this.mobile,
    required this.role,
  });

  factory OtpVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponseModel(
      userId: json['userId'],
      mobile: json['mobile'],
      role: json['role'],
    );
  }
}
