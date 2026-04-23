class OwnerProfileResponseModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? role;
  final String? profileImage;
  final String? address;

  final bool? isActive;

  OwnerProfileResponseModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.address,
    required this.role,
    required this.profileImage,
    required this.isActive,
  });

  factory OwnerProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return OwnerProfileResponseModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      mobile: json['mobile'],
      role: json['role'],
      address: json['address'],
      profileImage: json['profileImage'],
      isActive: json['isActive'],
    );
  }
}
