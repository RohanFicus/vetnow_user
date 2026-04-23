class OwnerProfileEntity {
  final String? id;
  final String? mobile;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? role;
  final String? address;
  final String? profileImage;
  final bool? isActive;

  OwnerProfileEntity({
    required this.id,
    required this.mobile,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.profileImage,
    required this.role,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "mobile": mobile,
      "firstName": firstName,
      "lastName": lastName,
      "profileImage": profileImage,
      "address": address,
      "role": role,
      "isActive": isActive,
      "email": email,
    };
  }

  factory OwnerProfileEntity.fromJson(Map<String, dynamic> json) {
    return OwnerProfileEntity(
      id: json["id"],
      mobile: json["mobile"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      address: json["address"],
      profileImage: json["profileImage"],
      role: json["role"],
      isActive: json["isActive"],
      email: json["email"],
    );
  }
}
