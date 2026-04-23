class AssessmentQuestion {
  final String id;
  final String category;
  final String questionEn;
  final String inputType;
  final List<AssessmentOption> options;
  final bool isMultiSelect;

  AssessmentQuestion({
    required this.id,
    required this.category,
    required this.questionEn,
    required this.inputType,
    required this.options,
    this.isMultiSelect = false,
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: json['id'],
      category: json['category'],
      questionEn: json['questionEn'],
      inputType: json['inputType'],
      isMultiSelect: json['isMultiSelect'] ?? false,
      options: (json['options'] as List)
          .map((o) => AssessmentOption.fromJson(o))
          .toList(),
    );
  }
}

class AssessmentOption {
  final String id;
  final String labelEn;
  final String value;
  final int score;

  AssessmentOption({
    required this.id,
    required this.labelEn,
    required this.value,
    required this.score,
  });

  factory AssessmentOption.fromJson(Map<String, dynamic> json) {
    return AssessmentOption(
      id: json['id'],
      labelEn: json['labelEn'],
      value: json['value'],
      score: json['score'],
    );
  }
}
