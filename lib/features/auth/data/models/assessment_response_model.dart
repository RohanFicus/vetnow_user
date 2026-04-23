class AssessmentResponseModel {
  final String? id;
  final String? category;
  final String? questionEn;
  final String? questionHi;
  final String? inputType;
  final int? weight;
  final bool? isMultiSelect;
  final List<OptionModel>? options;

  AssessmentResponseModel({
    this.id,
    this.category,
    this.questionEn,
    this.questionHi,
    this.isMultiSelect,
    this.inputType,
    this.weight,
    this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category": category,
      "questionEn": questionEn,
      "questionHi": questionHi,
      "inputType": inputType,
      "weight": weight,
      "isMultiSelect": isMultiSelect,
      "options": options?.map((e) => e.toJson()).toList(),
    };
  }

  factory AssessmentResponseModel.fromJson(Map<String, dynamic> json) {
    return AssessmentResponseModel(
      id: json['id'],
      category: json['category'],
      questionEn: json['questionEn'],
      questionHi: json['questionHi'],
      isMultiSelect: json['isMultiSelect'],
      inputType: json['inputType'],
      weight: json['weight'],
      options: (json['options'] as List?)
          ?.map((e) => OptionModel.fromJson(e))
          .toList(),
    );
  }
}

class OptionModel {
  final String? id;
  final String? labelEn;
  final String? labelHi;
  final String? value;
  final int? score;

  OptionModel({this.id, this.labelEn, this.labelHi, this.value, this.score});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "labelEn": labelEn,
      "labelHi": labelHi,
      "value": value,
      "score": score,
    };
  }

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      labelEn: json['labelEn'],
      labelHi: json['labelHi'],
      value: json['value'],
      score: json['score'],
    );
  }
}
