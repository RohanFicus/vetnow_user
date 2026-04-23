class AssessmentQuestionEntity {
  late final String questionId;
  late final String answerId;
  late final String answerValue;
  late final String category;

  AssessmentQuestionEntity({
    required this.questionId,
    required this.answerValue,
    required this.answerId,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionId'] = questionId;
    data['answerValue'] = answerValue;
    return data;
  }

  AssessmentQuestionEntity.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    answerValue = json['answerValue'];
    answerId = json['answerId'];
    category = json['category'];
  }
}
