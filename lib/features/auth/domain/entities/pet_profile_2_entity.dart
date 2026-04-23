class PetProfileStep2Entity {
  double? weightKg;
  String? color;

  PetProfileStep2Entity({this.weightKg, this.color});

  PetProfileStep2Entity.fromJson(Map<String, dynamic> json) {
    weightKg = json['weightKg'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weightKg'] = weightKg;
    data['color'] = color;

    return data;
  }
}
