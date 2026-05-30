class AvailableSlotsModel {
  List<Slot>? morning;
  List<Slot>? afternoon;
  List<Slot>? evening;

  AvailableSlotsModel({this.morning, this.afternoon, this.evening});

  AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    if (json['MORNING'] != null) {
      morning = <Slot>[];
      json['MORNING'].forEach((v) {
        morning!.add(Slot.fromJson(v));
      });
    }
    if (json['AFTERNOON'] != null) {
      afternoon = <Slot>[];
      json['AFTERNOON'].forEach((v) {
        afternoon!.add(Slot.fromJson(v));
      });
    }
    if (json['EVENING'] != null) {
      evening = <Slot>[];
      json['EVENING'].forEach((v) {
        evening!.add(Slot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (morning != null) {
      data['MORNING'] = morning!.map((v) => v.toJson()).toList();
    }
    if (afternoon != null) {
      data['AFTERNOON'] = afternoon!.map((v) => v.toJson()).toList();
    }
    if (evening != null) {
      data['EVENING'] = evening!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slot {
  String? time;
  String? category;

  Slot({this.time, this.category});

  Slot.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['category'] = category;
    return data;
  }
}
