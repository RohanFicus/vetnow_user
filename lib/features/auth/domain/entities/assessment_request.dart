import 'package:vetnow_user/features/auth/domain/entities/assessment_question_entity.dart';

class AssessmentRequest {
  String? petId;
  String? assessmentType;
  List<AssessmentQuestionEntity>? answers;

  AssessmentRequest({this.petId, this.assessmentType, this.answers});

  AssessmentRequest.fromJson(Map<String, dynamic> json) {
    petId = json['petId'];
    assessmentType = json['assessmentType'];
    if (json['answers'] != null) {
      answers = <AssessmentQuestionEntity>[];
      json['answers'].forEach((v) {
        answers!.add(AssessmentQuestionEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['petId'] = petId;
    data['assessmentType'] = assessmentType;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  String? questionId;
  String? answerValue;

  Answers({this.questionId, this.answerValue});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    answerValue = json['answerValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionId'] = questionId;
    data['answerValue'] = answerValue;
    return data;
  }
}
