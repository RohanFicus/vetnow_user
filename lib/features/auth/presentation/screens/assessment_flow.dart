import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/datasources/dashboard_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_response_model.dart';
import 'package:vetnow_user/features/auth/data/repositories/dashboard_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/entities/assessment_question_entity.dart';
import 'package:vetnow_user/features/auth/domain/usecases/dashboard_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/result_screen.dart';

class AssessmentFlow extends StatelessWidget {
  final List<AssessmentResponseModel>? assessments;
  final String petId;
  final String petName;

  AssessmentFlow({
    super.key,
    required this.assessments,
    required this.petId,
    required this.petName,
  });

  // Mock Data mimicking your JSON structure
  final List<Map<String, dynamic>> rawQuestions = [
    {
      "id": "1",
      "category": "NUTRITION",
      "questionEn":
          "Which of the following best describes {petName}'s primary diet?",
      "inputType": "OPTION",
      "options": [
        {"id": "a", "labelEn": "Kibble / dry food", "value": "DRY", "score": 5},
        {"id": "b", "labelEn": "Canned / wet food", "value": "WET", "score": 5},
        {"id": "c", "labelEn": "Even mix of both", "value": "MIX", "score": 5},
      ],
    },
    {
      "id": "2",
      "category": "ACTIVITY",
      "questionEn":
          "Which of the following best describes {petName}'s lifestyle?",
      "inputType": "OPTION",
      "options": [
        {"id": "d", "labelEn": "Very active", "value": "HIGH", "score": 5},
        {"id": "e", "labelEn": "Moderately active", "value": "MED", "score": 5},
        {"id": "f", "labelEn": "Prefers to lounge", "value": "LOW", "score": 5},
      ],
    },
    {
      "id": "3",
      "category": "HEALTH",
      "questionEn":
          "Which of the following best describes {petName}'s lifestyle?",
      "inputType": "OPTION",
      "options": [
        {"id": "d", "labelEn": "Very active", "value": "HIGH", "score": 5},
        {"id": "e", "labelEn": "Moderately active", "value": "MED", "score": 5},
        {"id": "f", "labelEn": "Prefers to lounge", "value": "LOW", "score": 5},
      ],
    },
    {
      "id": "4",
      "category": "MEDICATIONS",
      "questionEn":
          "Which of the following best describes {petName}'s lifestyle?",
      "inputType": "OPTION",
      "options": [
        {"id": "d", "labelEn": "Very active", "value": "HIGH", "score": 5},
        {"id": "e", "labelEn": "Moderately active", "value": "MED", "score": 5},
        {"id": "f", "labelEn": "Prefers to lounge", "value": "LOW", "score": 5},
      ],
    },
    {
      "id": "4",
      "category": "GROOMING",
      "questionEn":
          "Which of the following best describes {petName}'s lifestyle?",
      "inputType": "OPTION",
      "options": [
        {"id": "d", "labelEn": "Very active", "value": "HIGH", "score": 5},
        {"id": "e", "labelEn": "Moderately active", "value": "MED", "score": 5},
        {"id": "f", "labelEn": "Prefers to lounge", "value": "LOW", "score": 5},
      ],
    },
  ];

  late List<AssessmentResponseModel> questions;
  late List<String> categories = [];

  // @override
  // void initState() {
  //   super.initState();
  //   questions = rawQuestions
  //       .map((q) => AssessmentQuestion.fromJson(q))
  //       .toList();
  // }

  // void next() {
  //   if (currentStep < questions.length - 1) {
  //     setState(() {
  //       currentStep++;
  //       selectedOptionId = null;
  //     });
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => ResultScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // questions = assessments
    //     !.map((q) => AssessmentResponseModel.fromJson(q)).toList();
    //var q = assessments![currentStep];

    return BlocProvider(
      create: (_) =>
          sl<DashboardBloc>()
            ..add(OwnerProfileCallLocally())
            ..add(FetchAssessmentQuestions(assessments: assessments)),
      child: BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (previous, current) =>
            previous.user != current.user ||
            previous.pets != current.pets ||
            previous.isLoading != current.isLoading ||
            previous.error != current.error,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.assessmentSuccessModel != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  assessmentSuccessData: state.assessmentSuccessModel,
                ),
              ),
            );
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            final q = assessments?[state.currentStep];
            String? displayTitle = q?.questionEn?.replaceAll(
              "{petName}",
              petName,
            );
            print("assessments${assessments?.first.questionEn}");
            assessments?.map((e) => {categories.add(e.category.toString())});
            final hasAnsweredCurrentCategory = assessments?.any(
              (e) => e.category == q?.category,
            );
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  "Pet Health Assessment",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  _buildStepper(q?.category, state),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (q?.category == "ACTIVITY")
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Lifestyle",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          SizedBox(height: 15),
                          Text(
                            displayTitle.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 25),
                          ...?q?.options?.map(
                            (opt) => _buildOptionTile(
                              opt,
                              context,
                              state,
                              q.category,
                              q.id,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.currentStep == state.assessmentList.length - 1)
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3B76E1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            context.read<DashboardBloc>().add(
                              SubmitAnswers(petId),
                            );
                          }, //selectedOptionId == null ? null : next,
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepper(String? currentCat, DashboardState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: state.categories!.map((cat) {
        final index = state.categories!.indexOf(cat);

        final isActive = index == state.currentStep;
        final isDone = index < state.currentStep.toInt();

        return Column(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone || isActive ? Colors.blue : Colors.grey[300],
            ),
            Text(
              cat,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOptionTile(
    OptionModel opt,
    BuildContext context,
    DashboardState state,
    String? category,
    String? questionId,
  ) {
    final isSelected =
        state.answersList.any(
          (e) => e.category == category && e.answerId == opt.id.toString(),
        ) ??
        false;
    return GestureDetector(
      onTap: () {
        print("object ${questionId.toString()}");
        context.read<DashboardBloc>().add(
          AnswerSelected(
            AssessmentQuestionEntity(
              questionId: questionId.toString(),
              answerValue: opt.value.toString(),
              answerId: opt.id.toString(),
              category: category.toString(),
            ),
          ),
        );
        //print("Answers ${state.answersList.first.answerValue}");
        //setState(() => selectedOptionId = opt.id)
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(opt.labelEn.toString(), style: TextStyle(fontSize: 16)),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Colors.green : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
